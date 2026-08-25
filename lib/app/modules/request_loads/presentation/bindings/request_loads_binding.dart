import 'package:get/get.dart';

import '../controllers/request_loads_controller.dart';

class RequestLoadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestLoadsController>(
      () => RequestLoadsController(),
    );
  }
}
