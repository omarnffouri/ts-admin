import 'package:get/get.dart';

import '../controllers/inspection_details_controller.dart';

class InspectionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionDetailsController>(
      () => InspectionDetailsController(),
    );
  }
}
