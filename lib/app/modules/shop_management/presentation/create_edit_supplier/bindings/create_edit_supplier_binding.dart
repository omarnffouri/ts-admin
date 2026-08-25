import 'package:get/get.dart';

import '../controllers/create_edit_supplier_controller.dart';

class CreateEditSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateEditSupplierController>(
      () => CreateEditSupplierController(),
    );
  }
}
