import 'package:get/get.dart';

import '../controllers/truck_details_controller.dart';

class TruckDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TruckDetailsController>(
      TruckDetailsController(),
    );
  }
}
