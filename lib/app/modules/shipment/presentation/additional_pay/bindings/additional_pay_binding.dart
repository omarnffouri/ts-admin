import 'package:get/get.dart';

import '../controllers/additional_pay_controller.dart';

class AdditionalPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdditionalPayController>(
      () => AdditionalPayController(),
    );
  }
}
