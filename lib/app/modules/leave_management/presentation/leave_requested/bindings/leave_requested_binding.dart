import 'package:get/get.dart';

import '../controllers/leave_requested_controller.dart';

class LeaveRequestedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveRequestedController>(
      () => LeaveRequestedController(),
    );
  }
}
