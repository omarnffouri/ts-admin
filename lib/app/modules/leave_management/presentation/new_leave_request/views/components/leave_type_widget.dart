import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';
import 'package:ts_admin/app/core/widgets/inline_error_retry.dart';

import '../../controllers/new_leave_request_controller.dart';

class LeaveTypeWidget extends GetView<NewLeaveRequestController> {
  const LeaveTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLeaveTypesLoading.value) {
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

      if (controller.errorWhileLoadingLeaveTypes.value) {
        return InlineErrorRetry(
          message: "Couldn't load leave types.",
          onRetry: controller.getAllLeaveTypes,
        ).marginSymmetric(vertical: 10);
      }

      return CustomStringDropdownWidget(
        hintText: 'Select Your Leave Type',
        items: controller.leaveTypes,
        selectedItem: controller.selectedLeaveType.isEmpty
            ? null
            : controller.selectedLeaveType.value,
        itemAsString: (String item) => item,
        onChanged: (value) {
          controller.selectedLeaveType.value = value.toString();
          controller.dateRangeController.clear();
          controller.fromDateController.clear();
          controller.toDateController.clear();
          controller.isEligible.value = false;
          controller.elegibilityText.value = "";
        },
        isDarkMode: Get.isDarkMode,
      );
    });
  }
}
