import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/multi_select_search_dropdown.dart';

import '../../../../domain/entities/user_type_entity.dart';
import '../../controllers/create_announcement_controller.dart';

class MultipleSearchDropdown extends GetView<CreateAnnouncementController> {
  const MultipleSearchDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MultiSelectSearchDropdown<ItemEntity>(
        // Remount on user-type change so the child's internal picks reset to
        // match the controller clearing selectedUsers (admins vs drivers must
        // not bleed into each other).
        key: ValueKey(controller.selectedCategoryType.value),
        items: controller.getUnitlist,
        labelOf: (e) => e.name ?? "",
        pickedChipRadius: 6,
        hintText:
            controller.selectedCategoryType.value?.toLowerCase() == "admins"
                ? 'Search Admins'
                : 'Search Drivers',
        onPickedChanged: (picked) {
          controller.selectedUsers.value = picked;
        },
      ),
    );
  }
}
