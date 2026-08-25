import 'package:get/get.dart';
import 'package:ts_admin/app/modules/chat/presentation/message_notifications/bindings/message_notifications_binding.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/menu/bindings/menu_page_binding.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/bindings/clock_in_out_binding.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/bindings/conversations_binding.dart';
import 'package:ts_admin/app/modules/shipment/presentation/shipments/bindings/shipments_binding.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/bindings/task_management_binding.dart';

import '../controllers/main_screen_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainScreenController>(
      MainScreenController(),
    );

    ClockInOutBinding().dependencies();
    ConversationsBinding().dependencies();
    MenuPageBinding().dependencies();
    ShipmentsBinding().dependencies();
    TaskManagementBinding().dependencies();
    MessageNotificationsBinding().dependencies();
  }
}
