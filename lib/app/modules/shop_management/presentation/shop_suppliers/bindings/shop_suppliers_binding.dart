import 'package:get/get.dart';

import '../controllers/shop_suppliers_controller.dart';

class ShopSuppliersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopSuppliersController>(
      () => ShopSuppliersController(),
    );
  }
}
