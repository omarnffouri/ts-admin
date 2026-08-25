import 'package:get/get.dart';

import '../controllers/chat_theme_settings_controller.dart';

class ChatThemeSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatThemeSettingsController>(
      ChatThemeSettingsController(),
    );
  }
}
