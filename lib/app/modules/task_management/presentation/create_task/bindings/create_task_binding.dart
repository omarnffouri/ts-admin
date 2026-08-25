import 'package:get/get.dart';

import '../controllers/create_task_controller.dart';

class CreateTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CreateTaskController>(
      CreateTaskController(),
    );
  }
}
