import 'package:get/get.dart';

import '../controllers/user_detail_view_controller.dart';

class UserDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserDetailViewController>(
      UserDetailViewController(),
    );
  }
}
