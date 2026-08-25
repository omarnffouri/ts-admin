import 'package:get/get.dart';

import '../controllers/manage_leave_requests_controller.dart';

class ManageLeaveRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageLeaveRequestsController>(
      () => ManageLeaveRequestsController(),
    );
  }
}
