import 'package:get/get.dart';

import '../controllers/reset_user_password_controller.dart';

class ResetUserPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ResetUserPasswordController>(
      ResetUserPasswordController(),
    );
  }
}
