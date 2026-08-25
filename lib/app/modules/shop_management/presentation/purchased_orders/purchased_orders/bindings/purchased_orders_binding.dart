import 'package:get/get.dart';

import '../controllers/purchased_orders_controller.dart';

class PurchasedOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchasedOrdersController>(
      () => PurchasedOrdersController(),
    );
  }
}
