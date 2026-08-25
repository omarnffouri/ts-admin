import 'package:get/get.dart';

import '../controllers/shop_clients_controller.dart';

class ShopClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopClientsController>(
      () => ShopClientsController(),
    );
  }
}
