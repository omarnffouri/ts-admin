import 'package:get/get.dart';

import '../controllers/technicians_controller.dart';

class TechniciansBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TechniciansController>(
      TechniciansController(),
    );
  }
}
