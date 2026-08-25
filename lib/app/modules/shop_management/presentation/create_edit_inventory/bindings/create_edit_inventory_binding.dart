import 'package:get/get.dart';

import '../controllers/create_edit_inventory_controller.dart';

class CreateEditInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateEditInventoryController>(
      () => CreateEditInventoryController(),
    );
  }
}
