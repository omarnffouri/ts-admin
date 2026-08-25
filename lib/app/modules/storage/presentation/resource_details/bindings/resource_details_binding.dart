import 'package:get/get.dart';

import '../controllers/resource_details_controller.dart';

class ResourceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ResourceDetailsController>(
      ResourceDetailsController(),
    );
  }
}
