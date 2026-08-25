import 'package:get/get.dart';

import '../controllers/applications_controller.dart';

class ApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApplicationsController>(
      ApplicationsController(),
    );
  }
}
