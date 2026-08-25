import 'package:get/get.dart';

import '../controllers/create_trailer_controller.dart';

class CreateTrailerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTrailerController>(
      () => CreateTrailerController(),
    );
  }
}
