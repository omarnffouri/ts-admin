import 'package:get/get.dart';

import '../controllers/create_inspection_request_controller.dart';

class CreateInspectionRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateInspectionRequestController>(
      () => CreateInspectionRequestController(),
    );
  }
}
