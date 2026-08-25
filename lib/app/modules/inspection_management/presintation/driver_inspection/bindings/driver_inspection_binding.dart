import 'package:get/get.dart';

import '../controllers/driver_inspection_controller.dart';

class DriverInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DriverInspectionController>(
      DriverInspectionController(),
    );
  }
}
