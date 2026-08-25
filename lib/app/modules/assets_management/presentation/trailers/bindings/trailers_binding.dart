import 'package:get/get.dart';

import '../controllers/trailers_controller.dart';

class TrailersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TrailersController>(TrailersController());
  }
}
