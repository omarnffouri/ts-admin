import 'package:get/get.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Untagged on purpose — 40+ widgets resolve it as GetView<ChatDetailController>.
    // That means only one CHAT_DETAIL route may be alive at a time, which
    // ChatNavigation.open enforces. Navigate through it, never Get.toNamed here.
    Get.put<ChatDetailController>(
      ChatDetailController(),
    );
  }
}
