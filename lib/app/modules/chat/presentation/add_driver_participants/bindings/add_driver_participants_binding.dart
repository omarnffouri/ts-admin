import 'package:get/get.dart';

import '../controllers/add_driver_participants_controller.dart';

class AddDriverParticipantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddDriverParticipantsController>(
      AddDriverParticipantsController(),
    );
  }
}
