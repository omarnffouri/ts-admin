import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/inline_error_retry.dart';
import 'package:ts_admin/app/core/widgets/multi_select_search_dropdown.dart';

import '../../../../domain/entities/alternative_user_entity.dart';
import '../../controllers/new_leave_request_controller.dart';

class SelectAlternativesWidget extends GetView<NewLeaveRequestController> {
  const SelectAlternativesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingUsers.value) {
        return Shimmer.fromColors(
          baseColor: Get.isDarkMode
              ? AppColorsLight.shimmerBaseColor
              : AppColorsLight.mainColorDark,
          highlightColor: AppColorsLight.shimmerHilightColor,
          child: const LinearProgressIndicator(
            color: AppColorsLight.mainColor,
          ).marginSymmetric(vertical: 20),
        );
      }

      if (controller.errorWhileLoadingUsers.value) {
        return InlineErrorRetry(
          message: "Couldn't load replacements.",
          onRetry: controller.getUsersDropdowns,
        ).marginSymmetric(vertical: 10);
      }

      return MultiSelectSearchDropdown<AlternativeUserEntity>(
        items: controller.users,
        labelOf: (e) => e.name ?? "",
        hintText: 'Search replacements',
        onPickedChanged: (picked) {
          controller.selectedUsers.value = picked;
        },
      );
    });
  }
}
