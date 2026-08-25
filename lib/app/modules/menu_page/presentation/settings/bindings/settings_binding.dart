import 'package:get/get.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController());
  }
}
