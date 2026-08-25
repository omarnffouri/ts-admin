import 'package:get/get.dart';

import '../controllers/annoucments_controller.dart';

class AnnoucmentsBinding extends Bindings {
  @override
  void dependencies() {
    // The home (clock-in-out) screen owns the announcements controller under
    // the "home" tag; FCM refresh and the dashboard unread badge resolve that
    // same tag. Reuse it so the listing screen shares one source of truth,
    // creating it only when home hasn't (e.g. deep entry into this route).
    if (Get.isRegistered<AnnoucmentsController>()) {
      // Reused instance fetched back when home created it — onInit won't run
      // again, so refetch on every entry. The in-flight guard absorbs overlap.
      Get.find<AnnoucmentsController>().getAllAnnoucements();
    } else {
      Get.put<AnnoucmentsController>(AnnoucmentsController());
    }
  }
}
