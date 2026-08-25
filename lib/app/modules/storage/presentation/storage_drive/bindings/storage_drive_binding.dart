import 'package:get/get.dart';

import '../controllers/storage_drive_controller.dart';

class StorageDriveBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageDriveController>(
      StorageDriveController(),
    );
  }
}
