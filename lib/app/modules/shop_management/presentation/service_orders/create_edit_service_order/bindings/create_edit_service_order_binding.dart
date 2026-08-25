import 'package:get/get.dart';

import '../controllers/create_edit_service_order_controller.dart';

class CreateEditServiceOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateEditServiceOrderController>(
      () => CreateEditServiceOrderController(),
    );
  }
}
