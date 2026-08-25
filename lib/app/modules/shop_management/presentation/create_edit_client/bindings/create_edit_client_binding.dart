import 'package:get/get.dart';

import '../controllers/create_edit_client_controller.dart';

class CreateEditClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateEditClientController>(
      () => CreateEditClientController(),
    );
  }
}
