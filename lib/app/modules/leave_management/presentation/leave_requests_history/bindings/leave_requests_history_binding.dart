import 'package:get/get.dart';

import '../controllers/leave_requests_history_controller.dart';

class LeaveRequestsHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveRequestsHistoryController>(
      () => LeaveRequestsHistoryController(),
    );
  }
}
