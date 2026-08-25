import 'package:get/get.dart';

import '../controllers/view_all_task_controller.dart';

class ViewAllTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ViewAllTaskController>(
      ViewAllTaskController(),
    );
  }
}
