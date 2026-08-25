import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_group_params.dart';
import 'package:ts_admin/app/modules/chat/presentation/create_group/controllers/create_group_controller.dart';

class GroupNameInputTab extends GetView<CreateGroupController> {
  const GroupNameInputTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        width:
            controller.groupCreationState.value == GroupCreationStates.nameInput
                ? Get.width
                : 0,
        duration: const Duration(milliseconds: 300),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Group Name",
                  style: TextStyle(
                      color: AppColorsLight.mainColor,
                      fontWeight: FontWeight.w700),
                ).paddingOnly(left: 14).marginOnly(top: 18),

                //
                //
                RoundedInputField(
                  hintText: "Enter group name",
                  controller: controller.groupNameController,
                ).paddingAll(10),

                //
                //
                // auto add drivers option
                Visibility(
                  visible: controller.selectedDrivers.isNotEmpty,
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

                //
                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: RoundedBorderButton(
                        label: "Back",
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          controller.groupCreationState(
                              GroupCreationStates.selectDrivers);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Obx(
                        () => Container(
                          child: controller.isCreatingGroup
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColorsLight.mainColor,
                                  ),
                                )
                              : RoundedFillButton(
                                  label: "Create",
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

                                    // creating params for the api
                                    final params = CreateGroupParams(
                                      groupName: controller
                                          .groupNameController.text
                                          .trim(),
                                      autoAddDrivers:
                                          controller.autoAddDrivers.value,
                                      adminParticipants: controller
                                          .selectedAdmins
                                          .map((element) =>
                                              CreateGroupParticipantParams(
                                                  modelId: element.id ?? 0,
                                                  modelType: modelTypeValues
                                                              .reverse[
                                                          element.modelType] ??
                                                      "users"))
                                          .toList(),
                                      applicantParticipants: controller
                                          .selectedDrivers
                                          .map((element) =>
                                              CreateGroupParticipantParams(
                                                  modelId: element.id ?? 0,
                                                  modelType: modelTypeValues
                                                              .reverse[
                                                          element.modelType] ??
                                                      "applicants"))
                                          .toList(),
                                    );

                                    // calling api
                                    controller.createGroup(params);
                                  },
                                ),
                        ).paddingAll(10),
                      ),
                    )
                  ],
                ).paddingAll(10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
