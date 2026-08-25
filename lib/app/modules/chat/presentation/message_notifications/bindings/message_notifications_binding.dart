import 'package:get/get.dart';

import '../controllers/message_notifications_controller.dart';

class MessageNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MessageNotificationsController>(
      MessageNotificationsController(),
    );
  }
}
