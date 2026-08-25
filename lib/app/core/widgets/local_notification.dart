import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/chat_navigation.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/modules/annoucments/presentation/announcements/controllers/annoucments_controller.dart';
import 'package:ts_admin/app/modules/chat/domain/params/buzz_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';

class LocalNotification {
  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: notificationTap,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.initialize(const DarwinInitializationSettings());

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) async {
    // print("object");

    RemoteNotification? notification = message.notification;
    final body = message.data;
    final type = body['notification_type'];

    BigPictureStyleInformation? bigPic;

    if (type == "web") {
      try {
        if (Get.isRegistered<AnnoucmentsController>()) {
          final announcementsController = Get.find<AnnoucmentsController>();
          announcementsController.getAllAnnoucements();
        }
      } catch (_) {}

      // check if body of image is not empty
      try {
        final img = body['image'];
        if ((img ?? "").isNotEmpty) {
          bigPic = await fetchData(img);
        }
      } catch (_) {}
    }

    String? notificationMessage;

    //
    // fetch the message of the notification
    try {
      notificationMessage = type == "chat"
          ? body['message']
          : type == "web"
              ? removeAllHtmlTags(body['message'] ?? "")
              : body['body'];
    } catch (_) {}

    //
    // if notification type is chat then check if message string in notification is empty
    // then consider notification as media message notification
    // and also check if notification belogs to the currenly active/opened chat then return/ignore
    if (type == "chat") {
      try {
        if ((body['message'] as String).isEmpty) {
          notificationMessage = "media 📎";
        }
      } catch (_) {}

      try {
        if (Get.isRegistered<ChatDetailController>()) {
          final chatDetailController = Get.find<ChatDetailController>();

          //
          // check if message belongs to the opened converstions
          // then check if buzz then notify for buzz and return
          if (body['conversationId']?.toString() ==
              chatDetailController.conversationId.toString()) {
            final haveBuzz =
                (body['title'] ?? "").toString().toLowerCase().contains("buzz");

            if (haveBuzz) {
              final converstionId = chatDetailController.conversationId;
              final messageId = (body['messageId'] != null)
                  ? int.parse(body['messageId'].toString())
                  : null;
              chatDetailController.onBuzzReceived(
                BuzzMessageParams(
                  converstionId: converstionId,
                  messageId: messageId,
                ),
              );
            }

            return;
          }
        }
      } catch (_) {}
    }

    //! ---------------------------------------
    if (type == "user_role_updated") {
      Get.put(AuthController()).updateUserRoles();
    }

    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb && body.isNotEmpty) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        body['title'],
        notificationMessage,
        payload: json.encode(message.data),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            priority: Priority.high,
            importance: Importance.max,
            // largeIcon: ,
            styleInformation: bigPic,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
      );
    }
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp =
        RegExp(r'<[^>]*>|&[^;]+;', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').replaceAll('Html', '');
  }

  static notificationTap(NotificationResponse notificationResponse) {
    if (notificationResponse.payload == null) return;
    final Map<String, dynamic> data =
        json.decode(notificationResponse.payload!);
    if (data.containsKey('notification_type')) {
      handleMessage(data);
    }
    debugPrint('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
  }

  static handleMessage(Map<String, dynamic> data) async {
    //
    //
    // ignore: unused_local_variable
    final type = data['notification_type'];
    //switch case for each type of notification
    switch (type) {
      case "chat" || "group":
        // add the body of the notification to the chat
        try {
          final storage = GetStorage();
          final userDetails = await storage.read(UserPrefKeys.userDetails);
          final isLoggedIn =
              await storage.read(AuthenticationPrefKeys.isLoggedIn);
          final token = await storage.read(AuthenticationPrefKeys.token);
          final userId = await storage.read(UserPrefKeys.userId);
          if (isLoggedIn == true &&
              userDetails != null &&
              token != null &&
              userId != null) {
            Map<String, dynamic> body = getChatBody(data);
            await ChatNavigation.open(body);
          }
        } catch (_) {}
        break;

      default:
    }
  }

  static Map<String, dynamic> getChatBody(Map<String, dynamic> data) {
    String userName = data['sender_name'];
    String groupName = data['conversationName'];

    try {
      final names = groupName.split("|");
      if (names.length == 2) {
        userName = names.last.trim();
        groupName = names.first.trim();
      }
    } catch (_) {}

    final haveBuzz =
        (data['title'] ?? "").toString().toLowerCase().contains("buzz");

    // add the body of the notification to the chat
    final body = {
      "userId": int.parse(data['sender_model_id'].toString()),
      "userName": userName,
      "userImage": data['sender_image'],
      "userPhone": data['sender_phone'],
      "group_name": groupName,
      "type": data['conversationType'],
      "chatable": data['chatable'] == true ||
          data['chatable'].toString().toLowerCase() == "true",
      "conversation_id": int.parse(data['conversationId'].toString()),
      "modelType": data['sender_model_type'],
      "i_am_participant": true,
      "is_from_notification": true,
      "haveBuzz": haveBuzz,
      "buzzOnMessage": ((data['messageId'] != null) && haveBuzz)
          ? int.parse(data['messageId'].toString())
          : null,
    };
    return body;
  }

  static Future<BigPictureStyleInformation?> fetchData(String img) async {
    try {
      final http.Response response = await http.get(Uri.parse(img));
      BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(response.bodyBytes),
        ),
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(response.bodyBytes),
        ),
      );
      return bigPictureStyleInformation;
    } catch (_) {}

    return null;
  }
}
