import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/controllers/call_events_controller.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/compressed_images_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/storage_files_manager.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/local_notification.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../controllers/auth_controller.dart';

class SplashController extends GetxController {
  static const _navigationDelay = Duration(milliseconds: 500);

  final storage = GetStorage();
  bool _isRouting = false;

  @override
  void onInit() {
    try {
      Get.find<CompressedImagesManager>().clearImagesCompressedFolder();
      Get.find<StorageFilesManager>().deleteWorkingDirectory();
    } catch (_) {}
    super.onInit();
    nextPage();
  }

  void nextPage() async {
    if (_isRouting) {
      return;
    }
    _isRouting = true;

    AuthController authController = Get.put(AuthController(), permanent: true);
    Get.put(CallEventsController(), permanent: true);
    final userDetails = await storage.read(UserPrefKeys.userDetails);
    final isLoggedIn = await storage.read(AuthenticationPrefKeys.isLoggedIn);
    final token = await storage.read(AuthenticationPrefKeys.token);
    final userId = await storage.read(UserPrefKeys.userId);
    if (isLoggedIn == true &&
        userDetails != null &&
        token != null &&
        userId != null) {
      try {
        authController.user.value = UserEntity.fromEntity(userDetails);
        authController.isAuthenticated = true;
        // Independent GETs; only Pusher needs the realtime config first.
        await Future.wait([
          authController.refreshProfile(),
          authController.userPermissionHelper.init(),
          authController.storeRealtimeConfiguration(),
        ]);
        // A 401 above already logged out — don't push MAIN_SCREEN over it.
        if (!authController.isAuthenticated) return;
        await initPusherManager();
        await Future.delayed(_navigationDelay);
        Get.offAllNamed(Routes.MAIN_SCREEN);

        //
        // if app starts from a terminated state then check for notification and take action accordingly
        FirebaseMessaging.instance.getInitialMessage().then((message) async {
          RemoteNotification? notification = message?.notification!;
          if (message != null && notification != null) {
            debugPrint('A new getInitialMessage event was published! $message');
            debugPrint("title ${notification.title}");

            await Future.delayed(const Duration(seconds: 1));
            LocalNotification.handleMessage(message.data);
          }
        });
      } catch (e) {
        await Future.delayed(_navigationDelay);
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      await Future.delayed(_navigationDelay);
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
