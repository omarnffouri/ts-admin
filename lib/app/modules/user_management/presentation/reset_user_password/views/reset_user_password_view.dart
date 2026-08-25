import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../controllers/reset_user_password_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ResetUserPasswordView extends GetView<ResetUserPasswordController> {
  const ResetUserPasswordView({super.key});
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

                //
                // body
                addVerticalSpace(50.h),

                // new password input
                RoundedInputField(
                  label: "New Password",
                  hintText: "New Password",
                  controller: controller.newPasswordController,
                  passwordView: true,
                  isRequired: true,
                ).marginSymmetric(horizontal: 14),

                addVerticalSpace(10.h),

                // confirm password input
                RoundedInputField(
                  label: "Confirm Password",
                  hintText: "Confirm Password",
                  controller: controller.confirmPasswordController,
                  passwordView: true,
                  isRequired: true,
                ).marginSymmetric(horizontal: 14),

                addVerticalSpace(20.h),

                Obx(
                  () => controller.isUpdatingPassword
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColorsLight.mainColor,
                          ),
                        )
                      : MainAppButton(
                          label: "Reset",
                          onPressed: () {
                            controller.resetPassword();
                          },
                        ),
                ).marginSymmetric(horizontal: 14, vertical: 10)
              ],
            ),
          ),
        ));
  }
}

class _Header extends GetView<ResetUserPasswordController> {
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
                  'Reset ${controller.userDetails.value?.firstName}\'s Password',
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
