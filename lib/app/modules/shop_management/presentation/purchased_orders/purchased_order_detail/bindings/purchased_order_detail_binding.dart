import 'package:get/get.dart';

import '../controllers/purchased_order_detail_controller.dart';

class PurchasedOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchasedOrderDetailController>(
      () => PurchasedOrderDetailController(),
    );
  }
}
