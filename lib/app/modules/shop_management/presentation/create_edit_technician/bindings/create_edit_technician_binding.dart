import 'package:get/get.dart';

import '../controllers/create_edit_technician_controller.dart';

class CreateEditTechnicianBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CreateEditTechnicianController>(
      CreateEditTechnicianController(),
    );
  }
}
