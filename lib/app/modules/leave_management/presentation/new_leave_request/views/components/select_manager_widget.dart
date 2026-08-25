import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';
import 'package:ts_admin/app/core/widgets/inline_error_retry.dart';

import '../../controllers/new_leave_request_controller.dart';

class SelectManagerWidget extends GetView<NewLeaveRequestController> {
  const SelectManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSupervisorsLoading.value) {
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

      if (controller.errorWhileLoadingSupervisors.value) {
        return InlineErrorRetry(
          message: "Couldn't load managers.",
          onRetry: controller.getAllSupervisors,
        ).marginSymmetric(vertical: 10);
      }

      return CustomStringDropdownWidget(
        hintText: 'Select Your Manager',
        items: controller.managers,
        selectedItem: controller.selectedManager.isEmpty
            ? null
            : controller.selectedManager.value,
        itemAsString: (String item) => item,
        onChanged: (value) {
          controller.selectedManager.value = value.toString();
        },
        isDarkMode: Get.isDarkMode,
      );
    });
  }
}
