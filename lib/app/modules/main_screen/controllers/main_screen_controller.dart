import 'dart:async';
import 'dart:io';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/pusher_manager.dart';
import 'package:ts_admin/app/core/helpers/voip_helper.dart';
import 'package:ts_admin/app/core/widgets/glass_bottom_nav_bar.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';
import 'package:ts_admin/app/core/widgets/location_service_dialog.dart';
import 'package:ts_admin/app/core/widgets/startup_permissions_dialog.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/safety/controllers/safety_controller.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/safety/views/safety_view.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/update_voip_token_usecase.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/oto_conversations/controllers/oto_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/menu/views/menu_page_view.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/clock_in_out_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/views/conversations_view.dart';
import 'package:ts_admin/app/modules/shipment/presentation/shipments/views/shipments_view.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/views/task_management_view.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../../../core/resources/app_colors.dart';
import '../../menu_page/presentation/menu/controllers/menu_page_controller.dart';

class MainScreenController extends GetxController {
  final tabController = PersistentTabController(initialIndex: 0).obs;

  final ThemeController theme = Get.find<ThemeController>();
  final updateVoipTokenUsecase = sl<UpdateVoipTokenUsecase>();
  final AuthController authController = Get.find<AuthController>();
  final menuPageController = Get.put(MenuPageController());
  final clockInOutController = Get.put(ClockInOutController());
  final safetyController = Get.put(SafetyController());

  final Rx<AppLifecycleState> appState = AppLifecycleState.resumed.obs;

  final pusher = sl<PusherManager>();

  StreamSubscription<ChannelReadEvent>? incommingCallSubscription;
  StreamSubscription<ChannelReadEvent>? incommingCallDeclinedSubscription;

  /// Read during build, never snapshotted — every tab gate resolves from
  /// `authController.user.value`, which can still be empty when this
  /// controller is created and fills in a moment later.
  bool get showSafetyTab => menuPageController.canViewSafety;

  bool get showShipmentTab => menuPageController.hasDispactherRules;

  final unreadCounts = 0.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    tabController.value;
    _checkForLocationService();
    Geolocator.getServiceStatusStream().listen((event) {
      if (event == ServiceStatus.disabled) {
        _showLocationServiceDialog();
      } else {
        // Only dismiss the LocationServiceDialog itself — never other routes
        // or dialogs. A bare Get.back() here used to pop whatever was on top
        // (the main screen right after login, or the mic permission dialog).
        if (_isLocationServiceDialogOpen && (Get.isDialogOpen ?? false)) {
          Get.back();
        }
      }
    });

    _fetchAndUpdateVoipToken();

    appState.listen((state) {
      if (state == AppLifecycleState.resumed &&
          authController.isAuthenticated) {
        //
        //
        // refreshing clock in states
        clockInOutController.refeshClockInState();

        //
        //
        // ensuring socket connection
        try {
          if (sl.isRegistered<PusherManager>()) {
            sl<PusherManager>().ensureConnection();
          }
        } catch (_) {}

        //
        //
        // checking if chat details active refesh the chat details
        try {
          if (Get.isRegistered<ChatDetailController>()) {
            Get.find<ChatDetailController>().getChatDetails();
          }
        } catch (_) {}
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _runStartupDialogs();
  }

  /// Completes with whether the upgrade dialog will be shown, as reported by
  /// the upgrader's `willDisplayUpgrade` callback (first evaluation wins).
  final _upgradeAlertEvaluated = Completer<bool>();

  /// Completes when the user acts on the upgrade dialog (Ignore/Later/Update).
  final _upgradeAlertDismissed = Completer<void>();

  void onUpgradeAlertEvaluated(bool display) {
    if (!_upgradeAlertEvaluated.isCompleted) {
      _upgradeAlertEvaluated.complete(display);
    }
  }

  void onUpgradeAlertDismissed() {
    if (!_upgradeAlertDismissed.isCompleted) {
      _upgradeAlertDismissed.complete();
    }
  }

  /// Runs the startup permissions flow only after the upgrade dialog is out
  /// of the way: either upgrader decided not to show it, or the user acted
  /// on it.
  Future<void> _runStartupDialogs() async {
    bool upgradeDialogShown;
    try {
      // A healthy store lookup resolves within the 5s TimeoutHttpClient cap.
      // When the lookup fails, UpgradeAlert never evaluates (versionInfo
      // stays null) and no callback fires — don't hold the permissions flow
      // hostage on that.
      upgradeDialogShown = await _upgradeAlertEvaluated.future
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      upgradeDialogShown = false;
    }

    if (upgradeDialogShown) {
      // No timeout here: while the upgrade dialog is up, the permissions
      // dialog must not appear on top of it. Every dialog button reports
      // the dismissal via [onUpgradeAlertDismissed].
      await _upgradeAlertDismissed.future;
    }

    await _runStartupPermissionsFlow();
  }

  /// Startup permission flow when landing on the main screen after login:
  ///
  /// 1. Shows [StartupPermissionsDialog] explaining why the app needs both
  ///    location and microphone access — but only when a native prompt can
  ///    still be shown for at least one of them.
  /// 2. On "Continue", requests the location permission first, then the
  ///    microphone permission — one at a time so the system prompts never
  ///    race or overlap.
  /// 3. When a permission was denied before or revoked from settings, the
  ///    native prompt can't appear anymore, so the matching "open settings"
  ///    dialog is shown instead.
  ///
  /// Skipped entirely when both permissions are already granted.
  Future<void> _runStartupPermissionsFlow() async {
    try {
      final micStatus = await Permission.microphone.status;
      final micGranted = micStatus.isGranted || micStatus.isLimited;

      final locationStatus = await Geolocator.checkPermission();
      final locationGranted = locationStatus == LocationPermission.whileInUse ||
          locationStatus == LocationPermission.always;

      if (micGranted && locationGranted) {
        return;
      }

      // don't stack on top of another dialog (e.g. LocationServiceDialog)
      if (Get.isDialogOpen ?? false) {
        return;
      }

      // deniedForever means the OS won't show the native prompt again (the
      // user denied it before or revoked it from settings) — only the
      // settings screen can fix it. iOS reports this reliably from
      // checkPermission; on Android it may still read as plain denied here,
      // but haveLocationPermission below catches it after the silent
      // request.
      final locationBlocked =
          locationStatus == LocationPermission.deniedForever;

      // The startup dialog leads into the native prompts, so only show it
      // when at least one of them can actually appear. When location is
      // blocked and the mic is already granted, go straight to the
      // open-settings dialog instead.
      final canPromptNatively =
          (!locationGranted && !locationBlocked) || !micGranted;

      if (canPromptNatively) {
        final proceed = await Get.dialog<bool>(
          const StartupPermissionsDialog(),
          barrierDismissible: false,
        );

        if (proceed != true) {
          return;
        }
      }

      // location first — haveLocationPermission shows the native
      // While-Using prompt when it can, and the "Open Location Settings"
      // dialog when the permission is denied or was revoked. The upgrade to
      // Always is requested later, at clock-in, where it's actually needed
      // (see _clockIn / PermissionHelper.haveAlwaysLocationPermission).
      if (!locationGranted) {
        try {
          await PermissionHelper.haveLocationPermission(
            "You need to allow location access to track shipments and clock in.",
          );
        } catch (e) {
          // e.g. location services disabled — the LocationServiceDialog flow
          // handles that; don't block the mic request on it.
          debugPrint('Error requesting location permission: $e');
        }
      }

      // then microphone — haveMicPermission shows the "open settings" dialog
      // if the permission ends up denied
      if (!micGranted) {
        await PermissionHelper.haveMicPermission(
          "You need to allow microphone access to receive and make calls.",
        );
      }
    } catch (e) {
      debugPrint('Error running startup permissions flow: $e');
    }
  }

  updateUnreadMessageCounts() {
    unreadCounts.value = 0;

    //
    // getting unread counts from one to one conversation
    try {
      if (Get.isRegistered<OtoConversationsController>()) {
        unreadCounts.value =
            Get.find<OtoConversationsController>().otoUnreadCounts.value;
      }
    } catch (_) {}

    //
    // getting unread counts from group conversation
    try {
      if (Get.isRegistered<GroupConversationsController>()) {
        unreadCounts.value +=
            Get.find<GroupConversationsController>().groupUnreadCounts.value;
      }
    } catch (_) {}
  }

  /// Tracks whether [LocationServiceDialog] is currently showing, so the
  /// service-status stream only dismisses that dialog and not whatever else
  /// happens to be on top (e.g. the mic permission dialog).
  bool _isLocationServiceDialogOpen = false;

  void _showLocationServiceDialog() {
    if (_isLocationServiceDialogOpen) {
      return;
    }
    _isLocationServiceDialogOpen = true;
    Get.dialog(const LocationServiceDialog()).whenComplete(() {
      _isLocationServiceDialogOpen = false;
    });
  }

  _checkForLocationService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _showLocationServiceDialog();
    }
  }

  /// Tabs for the glassmorphism navigation bar. Order must stay in sync with
  /// [buildScreens].
  List<GlassNavItem> buildGlassItems() {
    return [
      GlassNavItem(title: "Home", icon: Assets.icons.home),
      GlassNavItem(title: "Tasks", icon: Assets.icons.taskManagement),
      if (showSafetyTab)
        GlassNavItem(
          title: "Safety",
          icon: Assets.icons.assetManagementIcon,
        ),
      GlassNavItem(title: "Chat", icon: Assets.icons.chat),
      if (showShipmentTab)
        GlassNavItem(title: "Shipment", icon: Assets.icons.shipments),
      GlassNavItem(title: "Menu", icon: Assets.icons.menu),
    ];
  }

  List<Widget> buildScreens() {
    return [
      const ClockInOutView(),
      const TaskManagementView(),
      if (showSafetyTab) const SafetyView(),
      const ConversationsView(),
      if (showShipmentTab) const ShipmentsView(),
      const MenuPageView(),
    ];
  }

  void _fetchAndUpdateVoipToken() async {
    if (!Platform.isIOS) {
      return;
    }
    //
    try {
      //
      final token = await VoipHelper.fetchVoipToken();
      if (token.isEmpty) {
        return;
      }

      //
      // hit update voip token api
      final response = await updateVoipTokenUsecase.call(token);

      response.fold((successful) {
        // print("Voip update response ====> $successful");
      }, (failure) {
        // print("Failure while updating voip token ===> ${failure.message}");
      });
    } catch (_) {
      // print("Error while hitting update voip token api ===> $e");
    }
  }
}
