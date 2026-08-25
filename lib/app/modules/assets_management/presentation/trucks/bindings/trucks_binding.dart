import 'package:get/get.dart';

import '../controllers/trucks_controller.dart';

class TrucksBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TrucksController>(TrucksController());
  }
}
