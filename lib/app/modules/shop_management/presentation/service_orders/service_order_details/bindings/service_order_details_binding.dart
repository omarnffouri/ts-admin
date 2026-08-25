import 'package:get/get.dart';

import '../controllers/service_order_details_controller.dart';

class ServiceOrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceOrderDetailsController>(
      () => ServiceOrderDetailsController(),
    );
  }
}
