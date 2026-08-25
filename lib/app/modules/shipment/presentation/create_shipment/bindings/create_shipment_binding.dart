import 'package:get/get.dart';

import '../controllers/create_shipment_controller.dart';

class CreateShipmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateShipmentController>(
      () => CreateShipmentController(),
    );
  }
}
