import 'package:get/get.dart';

import '../controllers/shipment_details_controller.dart';

class ShipmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShipmentDetailsController>(
      ShipmentDetailsController(),
    );
  }
}
