import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/permission_helper.dart';

import 'package:ts_admin/app/core/helpers/tracking_services/location_services.dart';
// import 'package:ts_admin/app/core/utils/map_utils.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';

class LocationController extends GetxController {
  static LocationController get to => Get.find();
  Future<void> startTrack() async {
    if (Platform.isIOS) {
      final started = await IosLocationService.startLocationUpdates();
      if (!started) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: "Please grant location permission",
        );
      }
    } else if (Platform.isAndroid) {
      onStartLocationService();
    }
  }

  Future<void> onStartLocationService() async {
    // check permission
    // if (await ispermissionGranted() == false) {
    //   // CommonWidgets.showSnackBar(
    //   //   title: 'Error'.tr,
    //   //   message: "Please grant location permission",
    //   // );
    //   return;
    // }
    AndroidLocationService.startLocationUpdates();
  }

  Future<void> releaseTracking() async {
    if (Platform.isIOS) {
      await IosLocationService.stopLocationUpdates();
    } else if (Platform.isAndroid) {
      AndroidLocationService.stopLocationUpdates();
    }
  }

  Future<bool> serviceAlreadyRunning() async {
    if (Platform.isIOS) {
      return await IosLocationService.serviceAlreadyRunning();
    } else {
      return false;
    }
  }

  Future<bool> checkAndRequestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Try to open location settings and check again
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return false;
      }
    }

    // Check and handle location permission
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied.');
          return false;
        }
        break;
      case LocationPermission.deniedForever:
        // Open app settings if permissions are denied forever
        PermissionHelper.openSettings();
        debugPrint('Location permissions are permanently denied.');
        return false;

      case LocationPermission.whileInUse:
      case LocationPermission.always:
        debugPrint('Location permissions are granted.');
        return true;
      default:
    }

    // Check if permission was granted after requesting
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
