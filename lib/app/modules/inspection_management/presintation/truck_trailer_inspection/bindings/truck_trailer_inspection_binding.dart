import 'package:get/get.dart';

import '../controllers/truck_trailer_inspection_controller.dart';

class TruckTrailerInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TruckTrailerInspectionController>(
      TruckTrailerInspectionController(),
    );
  }
}
