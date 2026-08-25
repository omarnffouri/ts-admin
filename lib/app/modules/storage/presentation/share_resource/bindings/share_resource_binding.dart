import 'package:get/get.dart';

import '../controllers/share_resource_controller.dart';

class ShareResourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShareResourceController>(
      ShareResourceController(),
    );
  }
}
