import 'package:get/get.dart';

import '../controllers/service_orders_controller.dart';

class ServiceOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceOrdersController>(
      () => ServiceOrdersController(),
    );
  }
}
