import 'dart:io';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/timeout_http_client.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/screens/base_screen.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/glass_bottom_nav_bar.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/menu/controllers/menu_page_controller.dart';
import 'package:upgrader/upgrader.dart';

import '../controllers/main_screen_controller.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView>
    with WidgetsBindingObserver {
  final controller = Get.find<MainScreenController>();

  static final _upgrader = Upgrader(
    client: TimeoutHttpClient(timeout: const Duration(seconds: 5)),
    durationUntilAlertAgain: const Duration(milliseconds: 500),
    willDisplayUpgrade: ({
      required bool display,
      installedVersion,
      versionInfo,
    }) {
      if (Get.isRegistered<MainScreenController>()) {
        Get.find<MainScreenController>().onUpgradeAlertEvaluated(display);
      }
    },
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    final canDismissUpdate = !ApiConstants.isProduction;

    return UpgradeAlert(
      upgrader: _upgrader,
      showIgnore: canDismissUpdate,
      showLater: canDismissUpdate,
      dialogStyle: UpgradeDialogStyle.cupertino,
      cupertinoButtonTextStyle: const TextStyle(
        color: AppColorsLight.mainColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onIgnore: () {
        controller.onUpgradeAlertDismissed();
        return true;
      },
      onLater: () {
        controller.onUpgradeAlertDismissed();
        return true;
      },
      onUpdate: () {
        controller.onUpgradeAlertDismissed();
        return true;
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: primaryColor,
          resizeToAvoidBottomInset: false,
          // Let pages draw under the floating nav bar so each one fills the whole
          // screen with its own background colour.
          extendBody: true,
          body: DoubleBack(
            onFirstBackPress: (ctx) {
              CommonWidgets.showSnackBar(
                title: '',
                message: 'Press back again to exit',
                isError: false,
              );
            },
            textStyle: TextStyle(fontSize: 16.sp, color: AppColorsLight.white),
            backgroundRadius: 20.r,
            child: Stack(
              children: [
                // Active page — each screen is a full Scaffold that owns its own
                // background, so it covers the entire area edge to edge.
                AppRedHeader(
                  child: BaseScreen(
                    child: AnimatedBuilder(
                      animation: controller.tabController.value,
                      builder: (context, _) {
                        final screens = controller.buildScreens();
                        final index = controller.tabController.value.index
                            .clamp(0, screens.length - 1);
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                          child: KeyedSubtree(
                            key: ValueKey<int>(index),
                            child: screens[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: Platform.isIOS ? -24 : 0,
                  child: SafeArea(
                    top: false,
                    child: GlassBottomNavBar(
                      controller: controller.tabController.value,
                      items: controller.buildGlassItems(),
                      onItemSelected: (value) {
                        if (Get.isRegistered<MenuPageController>()) {
                          Get.find<MenuPageController>().onTabChanged(value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        controller.appState.value = state;
      case AppLifecycleState.hidden:
        controller.appState.value = state;
        break;
      case AppLifecycleState.paused:
        controller.appState.value = state;
        break;
      case AppLifecycleState.resumed:
        controller.appState.value = state;
        break;
      case AppLifecycleState.detached:
        controller.appState.value = state;
        break;
    }
  }
}
