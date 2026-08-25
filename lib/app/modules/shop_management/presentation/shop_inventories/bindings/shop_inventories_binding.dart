import 'package:get/get.dart';

import '../controllers/shop_inventories_controller.dart';

class ShopInventoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopInventoriesController>(
      () => ShopInventoriesController(),
    );
  }
}
