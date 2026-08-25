import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ts_admin/app/core/widgets/permission_info_dialog.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class PermissionHelper {
  static int? _androidSdkVersion;

  static Future<int> _getAndroidSdkVersion() async {
    _androidSdkVersion ??=
        (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    return _androidSdkVersion!;
  }

  static bool _isPermissionUsable(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }

  static Future<bool> haveCameraPermission(String message) async {
    final status = await Permission.camera.request();

    switch (status) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        await _showPermissionInfoDialog(Permission.camera, message, status);
        break;

      case PermissionStatus.limited:
        return true;

      case PermissionStatus.provisional:
        break;
    }

    return false;
  }

  static Future<bool> haveMicPermission(String message) async {
    final status = await Permission.microphone.request();

    switch (status) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        await _showPermissionInfoDialog(Permission.microphone, message, status);
        break;

      case PermissionStatus.limited:
        return true;

      case PermissionStatus.provisional:
        break;
    }

    return false;
  }

  static Future<bool> haveAlwaysLocationPermission(String message) async {
    try {
      // checking location permission and service
      final havePermission = await haveLocationPermission(message);

      // if have location permission check for always location permission
      if (havePermission) {
        // checking taht device supports always location or not
        final supportsAlways = await supportsAlwaysLocation();

        // if supports always location permission then check for always
        // location permission status
        if (supportsAlways) {
          // Request "always" on both platforms via permission_handler.
          // On iOS this triggers the system "Change to Always Allow?"
          // upgrade prompt when the user has "While Using" — the previous
          // Geolocator.requestPermission() call only returned the current
          // status without ever offering the upgrade, so users who granted
          // "While Using" were sent straight to the settings dialog.
          var alwaysStatus = await Permission.locationAlways.request();

          // On iOS request() can resolve while the "Change to Always Allow?"
          // prompt is still on screen. Wait until the user answers it before
          // deciding, so the custom settings dialog never overlaps the
          // native prompt and only shows if the user declined.
          if (Platform.isIOS &&
              alwaysStatus != PermissionStatus.granted &&
              alwaysStatus != PermissionStatus.provisional) {
            alwaysStatus = await _statusAfterSystemPromptCloses();
          }

          final haveAlways = alwaysStatus == PermissionStatus.granted ||
              alwaysStatus == PermissionStatus.provisional;

          if (!haveAlways) {
            await _showPermissionInfoDialog(
                Permission.location, message, PermissionStatus.denied,
                openSettingText: "Open Location Settings",
                onOpenSettingsClick: () async {
              await Geolocator.openLocationSettings();
            });
            return false;
          }
          return true;
        }

        // means device dont supports always location but have location permission
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// While a native permission alert is on screen the Flutter app is
  /// [AppLifecycleState.inactive]; it returns to resumed once the user
  /// answers. Waits for that moment (with a timeout as safety net) and then
  /// re-reads the always-location status, so callers get the user's actual
  /// answer instead of a premature result.
  static Future<PermissionStatus> _statusAfterSystemPromptCloses() async {
    // give the lifecycle event a moment to propagate
    await Future.delayed(const Duration(milliseconds: 300));

    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      // a system prompt is showing — wait until the user answers it
      final completer = Completer<void>();
      final listener = AppLifecycleListener(
        onResume: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );
      try {
        await completer.future.timeout(const Duration(minutes: 2));
      } catch (_) {
      } finally {
        listener.dispose();
      }

      // small grace period so iOS reports the updated status
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return Permission.locationAlways.status;
  }

  static Future<bool> supportsAlwaysLocation() async {
    try {
      if (Platform.isIOS) {
        // All iOS devices support "Always" location permissions
        return true;
      } else if (Platform.isAndroid) {
        // Check the Android version
        // Android 10 (API level 29) and above
        return await _getAndroidSdkVersion() >= 29;
      }
    } catch (_) {}
    return false;
  }

  static Future<bool> locationServiceEnabled({String message = ""}) async {
    final serviceEnabled = Platform.isIOS
        ? await Geolocator.isLocationServiceEnabled()
        : await Permission.locationWhenInUse.serviceStatus.isEnabled;

    if (serviceEnabled) {
      return true;
    } else if (message.isNotEmpty) {
      await _showPermissionInfoDialog(
          Permission.location, message, PermissionStatus.denied,
          openSettingText: "Open Location Settings",
          onOpenSettingsClick: () async {
        await Geolocator.openLocationSettings();
      });
    }

    return false;
  }

  static Future<bool> haveLocationPermission(String message) async {
    // checking location service aviablity

    if (!(await locationServiceEnabled(message: message))) {
      return false;
    }

    // checking for location permission in ios using geo locator package
    if (Platform.isIOS) {
      final locationStatus = await Geolocator.requestPermission();
      switch (locationStatus) {
        case LocationPermission.denied:
        case LocationPermission.deniedForever:
        case LocationPermission.unableToDetermine:
          await _showPermissionInfoDialog(
              Permission.location, message, PermissionStatus.denied,
              openSettingText: "Open Location Settings",
              onOpenSettingsClick: () async {
            await Geolocator.openLocationSettings();
          });
          return false;

        case LocationPermission.whileInUse:
        case LocationPermission.always:
          return true;
      }
    }

    // else checking location permission on android using permission handler package
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        await _showPermissionInfoDialog(Permission.location, message, status,
            openSettingText: "Open Location Settings",
            onOpenSettingsClick: () async {
          await Geolocator.openLocationSettings();
        });
        break;

      case PermissionStatus.limited:
        return true;

      case PermissionStatus.provisional:
        break;
    }

    return false;
  }

  static Future<bool> havePhotosPermission(String message) async {
    if (Platform.isIOS) {
      final status = await Permission.photos.request();

      switch (status) {
        case PermissionStatus.granted:
          return true;

        case PermissionStatus.denied:
        case PermissionStatus.permanentlyDenied:
        case PermissionStatus.restricted:
          await _showPermissionInfoDialog(Permission.photos, message, status);
          break;

        case PermissionStatus.limited:
          return true;

        case PermissionStatus.provisional:
          break;
      }

      return false;
    }

    if (Platform.isAndroid) {
      final sdkVersion = await _getAndroidSdkVersion();

      if (sdkVersion >= 33) {
        // Android 13+: system photo picker handles its own permissions,
        // no need to request READ_MEDIA_IMAGES/READ_MEDIA_VIDEO
        return true;
      }

      // Android < 33: use storage permission
      var status = await Permission.storage.status;

      if (_isPermissionUsable(status)) {
        return true;
      }

      if (status.isPermanentlyDenied || status.isRestricted) {
        await _showPermissionInfoDialog(Permission.storage, message, status);
        return false;
      }

      status = await Permission.storage.request();

      if (_isPermissionUsable(status)) {
        return true;
      }

      // After request denied, show settings dialog
      await _showPermissionInfoDialog(Permission.storage, message, status);
      return false;
    }

    return false;
  }

  static Future<bool> haveStoragePermission(String message) async {
    if (Platform.isIOS) {
      return true;
    }

    final status = await Permission.storage.request();

    switch (status) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        await _showPermissionInfoDialog(Permission.storage, message, status);
        break;

      case PermissionStatus.limited:
        return true;

      case PermissionStatus.provisional:
        break;
    }

    return false;
  }

  static Future<bool> haveAppleMusicPermission(String message) async {
    final status = await Permission.mediaLibrary.request();

    switch (status) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        await _showPermissionInfoDialog(
            Permission.mediaLibrary, message, status);
        break;

      case PermissionStatus.limited:
        return true;

      case PermissionStatus.provisional:
        break;
    }

    return false;
  }

  static Future<bool> openSettings() async {
    return await openAppSettings();
  }

  static _showPermissionInfoDialog(
      Permission permission, String message, PermissionStatus permissionStatus,
      {String openSettingText = "Open App Settings",
      Function? onOpenSettingsClick}) async {
    // await Get.dialog(
    // PermissionInfoDialog(
    //   permissionCode: permissionCode,
    //   message: message,
    //   permissionStatus: permissionStatus,
    // ),
    // );

    await showGeneralDialog(
      barrierColor: Colors.black.applyOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 500, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: PermissionInfoDialog(
              permissionCode: permission,
              message: message,
              permissionStatus: permissionStatus,
              openSettingText: openSettingText,
              onOpenSettingsClick: onOpenSettingsClick,
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      context: Get.context!,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      },
    );
  }

  static needClockOut() async {
    //
    //
    // check location service enabled or not
    if (!(await locationServiceEnabled())) {
      return true;
    }

    //
    //
    // check for location permission
    bool haveLocationPermission = false;
    // checking for location permission in ios using geo locator package
    if (Platform.isIOS) {
      final locationStatus = await Geolocator.checkPermission();
      switch (locationStatus) {
        case LocationPermission.denied:
        case LocationPermission.deniedForever:
        case LocationPermission.unableToDetermine:
          break;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          haveLocationPermission = true;
      }
    } else if (Platform.isAndroid) {
      // else checking location permission on android using permission handler package
      final status = await Permission.location.status;

      switch (status) {
        case PermissionStatus.limited:
        case PermissionStatus.granted:
          haveLocationPermission = true;

        case PermissionStatus.denied:
        case PermissionStatus.permanentlyDenied:
        case PermissionStatus.restricted:
        case PermissionStatus.provisional:
          break;
      }
    }

    if (!haveLocationPermission) {
      return true;
    }

    //
    //
    // check device support always location or not
    if (!(await supportsAlwaysLocation())) {
      return false;
    }

    //
    //
    // check for always location permission
    bool haveAlwaysLocation = false;

    if (Platform.isIOS) {
      final locationStatus = await Geolocator.checkPermission();
      switch (locationStatus) {
        case LocationPermission.denied:
        case LocationPermission.deniedForever:
        case LocationPermission.unableToDetermine:
        case LocationPermission.whileInUse:
          break;
        case LocationPermission.always:
          haveAlwaysLocation = true;
          break;
      }
    } else if (Platform.isAndroid) {
      haveAlwaysLocation =
          (await Permission.locationAlways.status) == PermissionStatus.granted;
    }

    if (!haveAlwaysLocation) {
      return true;
    }

    return false;
  }
}
