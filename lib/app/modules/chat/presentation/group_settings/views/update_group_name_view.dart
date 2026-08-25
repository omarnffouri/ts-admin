import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_name_params.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/controllers/group_settings_controller.dart';

class UpdateGroupNameView extends GetView<GroupSettingsController> {
  const UpdateGroupNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: !controller.isUpdatingGroupName,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Group Settings'),
                ),
                body: Column(
                  children: [
                    //
                    //
                    // group name input view
                    RoundedInputField(
                      controller: controller.groupNameController,
                      hintText: controller.groupName.value,
                      label: 'Group Name',
                      showCounting: true,
                      maxLength: 50,
                    ).marginSymmetric(horizontal: 14, vertical: 20),

                    //
                    //
                    // auto add drivers option
                    Visibility(
                      visible: controller.drivers.isNotEmpty,
                      child: Row(
                        children: [
                          //
                          // description text
                          Expanded(
                            child: Text(
                              "Automatically add newly hired drivers.",
                              style: Get.textTheme.titleMedium,
                            ),
                          ),

                          //
                          // switch
                          Switch(
                            value: controller.autoAddDrivers.value,
                            onChanged: (value) {
                              controller.autoAddDrivers.value = value;
                            },
                            activeThumbColor: AppColorsLight.mainColorLight,
                          ),
                        ],
                      ).marginSymmetric(horizontal: 14).marginOnly(top: 10),
                    ),

                    Obx(() => controller.isUpdatingGroupName
                        ? const CircularProgressIndicator(
                            strokeCap: StrokeCap.round,
                            strokeWidth: 6,
                          )
                        : MainAppButton(
                            label: "Update",
                            onPressed: () {
                              if (controller.groupNameController.text
                                  .trim()
                                  .isEmpty) {
                                CommonWidgets.showSnackBar(
                                    title: "Field Required",
                                    message: "Please enter group name.",
                                    isError: false);
                                return;
                              }

                              final id = controller.getGroupId();
                              if (id == null) {
                                return;
                              }

                              // creating params for the api
                              final params = UpdateGroupNameParams(
                                groupId: controller.getGroupId()!,
                                autoAddDrivers: controller.autoAddDrivers.value,
                                fromGroupName: controller.groupName.value,
                                toGroupName:
                                    controller.groupNameController.text,
                              );

                              // calling api
                              controller.updateGroupName(params);
                            },
                          )).marginSymmetric(horizontal: 14, vertical: 25),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
