import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/dropdown.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/controllers/task_management_controller.dart';
import 'package:ts_admin/app/modules/task_management/presentation/view_all_task/controllers/view_all_task_controller.dart';

class ViewAllTasksHeader extends GetView<ViewAllTaskController> {
  const ViewAllTasksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10, topInset + 10, 10, 10),
      child: Column(
        children: [
          //
          //
          // back button, dropdown title, search icon
          Row(
            children: [
              //
              //
              // back icon
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ).paddingOnly(right: 15),

              //
              //
              // dropdown title
              const Expanded(
                child: Row(
                  children: [
                    _TitleDropDown(),
                  ],
                ),
              ),

              //
              //
              // search icon
              IconButton(
                onPressed: () {
                  if (controller.isSearchEnabled) {
                    controller.txtSearchController.clear();
                  }
                  controller.toggleSearch();
                },
                icon: Obx(
                  () => Icon(
                    controller.isSearchEnabled
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),

              //
              //
              // filter icon
              IconButton(
                onPressed: () {
                  controller.showFiltersBottomSheet();
                },
                icon: const Icon(
                  Icons.filter_alt,
                  size: 25,
                  color: Colors.white,
                ),
              ).marginOnly(left: 5),
            ],
          ),

          //
          //
          // search field
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: controller.isSearchEnabled ? 50 : 0,
              margin: const EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSearchField(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Get.isDarkMode ? Colors.white24 : Colors.white,
      ),
      child: TextField(
        controller: controller.txtSearchController,
        maxLines: 1,
        onChanged: controller.handleSearchChange,
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Search tasks",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none, // Remove the default border
          icon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              controller.txtSearchController.clear();
              //  controller.getAllTasks();
            },
            child: const Icon(
              Icons.close_rounded,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleDropDown extends GetView<ViewAllTaskController> {
  const _TitleDropDown();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 140,
      child: DropDown<TasksTabs>(
        listItems: [
          DropdownMenuItem(
            value: TasksTabs.todo,
            child: Text(
              "Todo's",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          DropdownMenuItem(
            value: TasksTabs.inProgress,
            child: Text(
              "In Progress",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          DropdownMenuItem(
            value: TasksTabs.requested,
            child: Text(
              "Requested",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          DropdownMenuItem(
            value: TasksTabs.completed,
            child: Text(
              "Completed",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
        hint: "",
        selectedValue: controller.tab.value,
        endIcon: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
          ),
        ),
        buttonStyleData: const ButtonStyleData(),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChange: (tab) {
          if (tab != null && (tab is TasksTabs)) {
            controller.tab.value = tab;
            controller.selectedRole.value = tab == TasksTabs.inProgress
                ? "in_progress"
                : tab.name.toLowerCase();
            controller.selectedReportTo.value = null;
            controller.selectedRequestedTo.value = null;
            controller.getAllTasks();
          }
        },
      ),
    );
  }
}
