import 'package:get/get.dart';

import '../controllers/create_announcement_controller.dart';

class CreateAnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAnnouncementController>(
      () => CreateAnnouncementController(),
    );
  }
}
