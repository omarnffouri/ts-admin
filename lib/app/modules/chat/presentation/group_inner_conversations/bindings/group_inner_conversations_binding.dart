import 'package:get/get.dart';

import '../controllers/group_inner_conversations_controller.dart';

class GroupInnerConversationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GroupInnerConversationsController>(
      GroupInnerConversationsController(),
    );
  }
}
