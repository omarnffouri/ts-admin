import 'package:get/get.dart';

import '../controllers/application_detail_view_controller.dart';

class ApplicationDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApplicationDetailViewController>(
      ApplicationDetailViewController(),
    );
  }
}
