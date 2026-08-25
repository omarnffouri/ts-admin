import 'package:get/get.dart';

import '../controllers/all_user_controller.dart';

class AllUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllUserController>(
      () => AllUserController(),
    );
  }
}
