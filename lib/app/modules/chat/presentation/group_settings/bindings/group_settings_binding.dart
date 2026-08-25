import 'package:get/get.dart';

import '../controllers/group_settings_controller.dart';

class GroupSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GroupSettingsController>(
      GroupSettingsController(),
    );
  }
}
