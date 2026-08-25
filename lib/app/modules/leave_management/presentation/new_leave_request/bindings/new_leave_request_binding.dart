import 'package:get/get.dart';

import '../controllers/new_leave_request_controller.dart';

class NewLeaveRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewLeaveRequestController>(
      () => NewLeaveRequestController(),
    );
  }
}
