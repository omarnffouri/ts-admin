import 'package:get/get.dart';

import '../controllers/new_inspection_controller.dart';

class NewInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NewInspectionController>(
      NewInspectionController(),
    );
  }
}
