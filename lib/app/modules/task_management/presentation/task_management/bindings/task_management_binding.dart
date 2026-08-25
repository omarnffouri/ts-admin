import 'package:get/get.dart';
import '../controllers/task_management_controller.dart';

class TaskManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskManagementController>(() => TaskManagementController());
  }
}
