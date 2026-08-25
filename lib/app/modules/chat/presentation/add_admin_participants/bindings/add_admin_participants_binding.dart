import 'package:get/get.dart';

import '../controllers/add_admin_participants_controller.dart';

class AddAdminParticipantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddAdminParticipantsController>(
      AddAdminParticipantsController(),
    );
  }
}
