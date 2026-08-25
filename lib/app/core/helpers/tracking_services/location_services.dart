import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/values/constants.dart';

class AndroidLocationService {
  static const MethodChannel _channel = MethodChannel('tracking_service');

  static Future<bool> startLocationUpdates() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onLocationUpdate') {
        // final argument = call.arguments;
        // onLocationUpdate(argument);
      }
    });

    try {
      await _channel.invokeMethod('startLocationUpdates');
      return true;
    } catch (e) {
      debugPrint('Error starting location updates: $e');
      return false;
    }
  }

  static Future<void> stopLocationUpdates() async {
    final storage = CommonVariables.tracking;

    var isClockRunning = storage.read(isClockServiceRunning);

    if ((isClockRunning != null && isClockRunning == false)) {
      await _channel.invokeMethod('stopLocationUpdates');
    }
  }

  static void onLocationUpdate(dynamic locationData) {
    final storage = CommonVariables.tracking;
    var isClockRunning = storage.read(isClockServiceRunning);
    final dataToSend = {
      "latitude": locationData["latitude"].toString(),
      "longitude": locationData["longitude"].toString(),
      "heading": locationData["heading"].toString(),
      "speed": locationData["speed"].toString(),
    };

    debugPrint(">>>>> trackingCallback called <<<<<<");
    debugPrint(">>>>> locationData $dataToSend");
    if (isClockRunning != null && isClockRunning == true) {
      // send sendClockLocation to server
      sendClockLocation(dataToSend);
    }
  }
}

class IosLocationService {
  static const String startLocationService = "startLocationService";
  static const String stopLocationService = "stopLocationService";
  static const String isServiceRunning = "isServiceRunning";
  static const String hasLocationAlwaysPermission =
      "hasLocationAlwaysPermission";
  static const String requestForAlwaysLocationPermission =
      "requestForAlwaysLocationPermission";

//
//

  static const MethodChannel _channel = MethodChannel('locationServiceChannel');

  static Future<bool> startLocationUpdates() async {
    // setting a method callback handler
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onLocationUpdate') {
        // final argument = call.arguments;
        // Perform the desired action with the argument
        // onLocationUpdate(argument);
      }
    });

    try {
      final hasPermission = await _channel
          .invokeMethod(IosLocationService.hasLocationAlwaysPermission);
      if (hasPermission) {
        //
        await _channel.invokeMethod(IosLocationService.startLocationService);
        return true;
      } else {
        await _channel.invokeMethod(
            IosLocationService.requestForAlwaysLocationPermission);

        return false;
      }
    } catch (e) {
      debugPrint('Error starting location updates: $e');
      return false; // There was an error invoking the method
    }
  }

  static Future<void> stopLocationUpdates() async {
    final storage = CommonVariables.tracking;
    var isClockRunning = storage.read(isClockServiceRunning);

    if ((isClockRunning != null && isClockRunning == false)) {
      await _channel.invokeMethod(IosLocationService.stopLocationService);
    }
  }

  static Future<bool> serviceAlreadyRunning() async {
    final isRunning =
        await _channel.invokeMethod(IosLocationService.isServiceRunning);
    return isRunning;
  }

  static void onLocationUpdate(dynamic locationData) {
    final storage = CommonVariables.tracking;
    var isClockRunning = storage.read(isClockServiceRunning);

    final dataToSend = {
      "latitude": locationData["latitude"].toString(),
      "longitude": locationData["longitude"].toString(),
      "heading": locationData["heading"].toString(),
      "speed": locationData["speed"].toString(),
    };

    debugPrint(">>>>> trackingCallback called <<<<<<");
    debugPrint(">>>>> locationData $dataToSend");
    if (isClockRunning != null && isClockRunning == true) {
      // send sendClockLocation to server
      sendClockLocation(dataToSend);
    }
  }
} // end of ios class

void sendClockLocation(Map<String, dynamic> body) async {
  final user = Get.find<AuthController>().user.value;
  final collectionUUID = await CommonVariables.tracking.read(uuId);

  final String userId = user!.id.toString();
  final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final clockBody = {
    "user_id": userId,
    "timestamp": {".sv": "timestamp"},
    "name": "${user.name}",
    "lat": num.parse(body["latitude"].toString()),
    "lng": num.parse(body["longitude"].toString()),
  };

  final rootLogs = ApiConstants.isProduction
      ? "user_tracking_logs"
      : "user_tracking_logs_Staging";

  final rootLive = ApiConstants.isProduction
      ? "user_tracking_live"
      : "user_tracking_live_Staging";

  final logsRef = FirebaseDatabase.instance
      .ref()
      .child(rootLogs)
      .child(today)
      .child(userId)
      .child(collectionUUID);

  final liveRef = FirebaseDatabase.instance
      .ref()
      .child(rootLive)
      .child(today)
      .child(userId);

  final snapshot = await liveRef.get();

  try {
    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      String firstKey = data.keys.first;
      // Document exists, update its data
      if (firstKey == collectionUUID) {
        await liveRef.child(collectionUUID).update(clockBody);
      } else {
        // Document exists, but with old collection, remove and create new
        await liveRef.remove();
        await liveRef.child(collectionUUID).set(clockBody);
      }
    } else {
      // If the document does not exist, create it
      await liveRef.child(collectionUUID).set(clockBody);
    }
    await logsRef.push().set(clockBody);
  } catch (error) {
    debugPrint(error.toString());
  }
}
