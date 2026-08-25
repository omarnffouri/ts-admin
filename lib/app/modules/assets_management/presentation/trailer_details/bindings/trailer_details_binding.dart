import 'package:get/get.dart';

import '../controllers/trailer_details_controller.dart';

class TrailerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrailerDetailsController>(
      () => TrailerDetailsController(),
    );
  }
}
