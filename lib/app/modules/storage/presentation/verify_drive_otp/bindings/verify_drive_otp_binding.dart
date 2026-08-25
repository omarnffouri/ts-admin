import 'package:get/get.dart';

import '../controllers/verify_drive_otp_controller.dart';

class VerifyDriveOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyDriveOtpController>(
      () => VerifyDriveOtpController(),
    );
  }
}
