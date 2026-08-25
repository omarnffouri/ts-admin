import 'package:get/get.dart';

import '../controllers/delete_user_controller.dart';

class DeleteUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DeleteUserController>(
      DeleteUserController(),
    );
  }
}
