import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../controllers/delete_user_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DeleteUserView extends GetView<DeleteUserController> {
  const DeleteUserView({super.key});
  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              //
              // header
              const _Header(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //
                      // body
                      addVerticalSpace(20.h),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.applyOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 25,
                              color: Colors.black,
                            ).marginOnly(right: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Please type the user's first name followed by the word 'delete'.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "\nExample: \" MARK DELETE \"",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      addVerticalSpace(15.h),

                      // current password input
                      RoundedInputField(
                        label: "Type",
                        hintText:
                            "${controller.userDetails.value?.firstName?.toUpperCase()} DELETE",
                        controller: controller.deleteController,
                        isRequired: true,
                      ).marginSymmetric(horizontal: 14),

                      addVerticalSpace(20.h),

                      Obx(
                        () => controller.isDeletingUser
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColorsLight.mainColor,
                                ),
                              )
                            : MainAppButton(
                                label: "Delete",
                                onPressed: () {
                                  controller.deleteUser();
                                },
                              ),
                      ).marginSymmetric(horizontal: 14, vertical: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<DeleteUserController> {
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
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
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
            child: Row(
              children: [
                Text(
                  'Delete ${controller.userDetails.value?.firstName}',
                  maxLines: 1,
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
