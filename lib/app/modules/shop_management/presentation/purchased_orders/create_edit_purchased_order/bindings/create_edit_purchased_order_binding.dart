import 'package:get/get.dart';

import '../controllers/create_edit_purchased_order_controller.dart';

class CreateEditPurchasedOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateEditPurchasedOrderController>(
      () => CreateEditPurchasedOrderController(),
    );
  }
}
