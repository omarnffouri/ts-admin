import 'package:get/get.dart';

import '../controllers/form_detail_view_controller.dart';

class FormDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FormDetailViewController>(
      FormDetailViewController(),
    );
  }
}
