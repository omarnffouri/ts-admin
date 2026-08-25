import 'package:get/get.dart';

import '../controllers/update_user_details_controller.dart';

class UpdateUserDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UpdateUserDetailsController>(
      UpdateUserDetailsController(),
    );
  }
}
