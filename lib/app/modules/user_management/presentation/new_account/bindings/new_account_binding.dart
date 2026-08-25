import 'package:get/get.dart';

import '../controllers/new_account_controller.dart';

class NewAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NewAccountController>(
      NewAccountController(),
    );
  }
}
