import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_botton.dart';
import 'package:ts_admin/app/core/widgets/app_botton_outline.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';
import 'package:ts_admin/app/modules/task_management/presentation/view_all_task/controllers/view_all_task_controller.dart';

import '../../../../domain/entities/task_dropdown_entity.dart';
import '../../../task_management/controllers/task_management_controller.dart';

class TasksFiltersBottomSheet extends GetView<ViewAllTaskController> {
  const TasksFiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      constraints: BoxConstraints(
        minHeight: Get.height * 0.4,
        maxHeight: Get.height * 0.4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          //
          // top header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 50,
            decoration: const BoxDecoration(
              color: AppColorsLight.mainColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),

                const Spacer(),

                //
                //
                // close button
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),

          //
          //
          // filters body

          //
          // report to
          Visibility(
            visible: controller.tab.value == TasksTabs.todo ||
                controller.tab.value == TasksTabs.completed ||
                controller.tab.value == TasksTabs.inProgress,
            child: SearchableDropDown<TaskDropdownsEntity>(
              list: controller.users,
              bottomSheetLabel: 'Select user',
              searchHint: 'search by name',
              fieldLabel: 'Report to',
              fieldHint: 'report to',
              isRequired: false,
              getName: (p0) => p0.name ?? '',
              getImage: (p0) => p0.name ?? '',
              selectedItem: controller.selectedReportTo.value,
              dropdownSearchDecoration: SearchableDropdownDecoration.bordered,
              dropdownDecoration: SearchableDropdownDecoration.line,
              onItemSelected: (TaskDropdownsEntity? item) {
                if (item != null) {
                  controller.selectedReportTo(item);
                }
              },
              itemAsString: (item) {
                return item.name ?? '';
              },
              compareFunction: (item_1, item_2) {
                return item_1 == item_2;
              },
            ).marginSymmetric(horizontal: 14, vertical: 10),
          ),

          //
          // assigned to
          Visibility(
            visible: controller.tab.value == TasksTabs.requested,
            child: SearchableDropDown<TaskDropdownsEntity>(
              list: controller.users,
              bottomSheetLabel: 'Select user',
              searchHint: 'search by name',
              fieldLabel: 'Requested to',
              fieldHint: 'requested to',
              isRequired: false,
              getName: (p0) => p0.name ?? '',
              getImage: (p0) => p0.name ?? '',
              selectedItem: controller.selectedRequestedTo.value,
              dropdownSearchDecoration: SearchableDropdownDecoration.bordered,
              dropdownDecoration: SearchableDropdownDecoration.line,
              onItemSelected: (TaskDropdownsEntity? item) {
                if (item != null) {
                  controller.selectedRequestedTo(item);
                }
              },
              itemAsString: (item) {
                return item.name ?? '';
              },
              compareFunction: (item_1, item_2) {
                return item_1 == item_2;
              },
            ).marginSymmetric(horizontal: 14, vertical: 10),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: AppButtonOutline(
                  text: 'Clear',
                  onTap: () {
                    controller.selectedReportTo.value = null;
                    controller.selectedRequestedTo.value = null;
                    Get.back();
                    controller.getAllTasks();
                  },
                ).marginSymmetric(horizontal: 14, vertical: 10),
              ),
              Expanded(
                child: AppButton(
                  text: 'Apply',
                  onTap: () {
                    Get.back();
                    controller.getAllTasks();
                  },
                ).marginSymmetric(horizontal: 14, vertical: 10),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
