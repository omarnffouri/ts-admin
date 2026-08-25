import 'package:get/get.dart';

import '../controllers/create_truck_controller.dart';

class CreateTruckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTruckController>(
      () => CreateTruckController(),
    );
  }
}
