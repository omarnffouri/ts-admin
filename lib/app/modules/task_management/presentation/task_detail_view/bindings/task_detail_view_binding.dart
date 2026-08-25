import 'package:get/get.dart';

import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TaskDetailViewController>(
      TaskDetailViewController(),
    );
  }
}
