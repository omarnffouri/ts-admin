import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ts_admin/app/modules/chat/presentation/create_group/views/tabs/admin_selection_tab.dart';
import 'package:ts_admin/app/modules/chat/presentation/create_group/views/tabs/driver_selection_tab.dart';
import 'package:ts_admin/app/modules/chat/presentation/create_group/views/tabs/group_name_input_tab.dart';

import '../controllers/create_group_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class CreateGroupView extends GetView<CreateGroupController> {
  const CreateGroupView({super.key});
  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);

    return Obx(() => PopScope(
          canPop: (controller.groupCreationState.value ==
                  GroupCreationStates.selectAdmins) &&
              (!controller.isCreatingGroup),
          onPopInvokedWithResult: (didPop, result) {
            controller.onBackPressed(didPop);
          },
          child: Scaffold(
            backgroundColor: theme.primaryColor,
            body: SafeArea(
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: const Column(
                  children: [
                    //
                    //
                    // header
                    _Header(),

                    //
                    //
                    // body
                    Expanded(
                      child: Row(
                        children: [
                          AdminSelectionTab(),
                          DriverSelectionTab(),
                          GroupNameInputTab()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _Header extends GetView<CreateGroupController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.applyOpacity(Get.isDarkMode ? 0.3 : 1),
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              //
              // back button
              GestureDetector(
                onTap: () {
                  controller.onBackPressed(false);
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ).paddingOnly(right: 10),

              //
              //
              //
              Expanded(
                child: Text(
                  'Create Group',
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),

          //
          //
          //
          const _GroupCreationStepper(),
        ],
      ),
    );
  }
}

class _GroupCreationStepper extends GetView<CreateGroupController> {
  const _GroupCreationStepper();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          //
          Obx(
            () => Text(
              "${controller.groupCreationState.value}/${GroupCreationStates.values.length}",
              style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ).marginOnly(right: 8),

          SizedBox(
            width: 200,
            height: 5,
            child: Obx(
              () => TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0.0,
                    end: (controller.groupCreationState.value /
                        GroupCreationStates.values.length)),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    color: Colors.white,
                    backgroundColor: Colors.white30,
                    borderRadius: BorderRadius.circular(999),
                    // strokeCap: StrokeCap.round,
                    // strokeWidth: 8,
                  );

                  // return CircularProgressIndicator(
                  // value: value,
                  // color: Colors.white,
                  // strokeCap: StrokeCap.round,
                  // strokeWidth: 8,
                  // );
                },
              ),
            ),
          ),

          //
          const Spacer(),

          Obx(
            () => Text(
              getStepName(controller.groupCreationState.value),
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: Colors.white, fontSize: 20),
            ).marginOnly(right: 20),
          ),
        ],
      ),
    );
  }

  String getStepName(int step) {
    if (step <= GroupCreationStates.values.length) {
      return step == GroupCreationStates.selectAdmins
          ? "Admins"
          : step == GroupCreationStates.selectDrivers
              ? "Drivers"
              : "Group Name";
    }
    return "";
  }
}
