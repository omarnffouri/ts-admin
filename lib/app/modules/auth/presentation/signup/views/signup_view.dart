import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/auth/presentation/signup/controllers/signup_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    // Retrieve specific theme colors
    // Color primaryColor = theme.primaryColor;
    // Color primaryColorDark = theme.primaryColorDark;
    // Color primaryColorLight = theme.primaryColorLight;
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    Color cardColor = theme.cardColor;

    return Container(
      color: scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: scaffoldBackgroundColor,
            resizeToAvoidBottomInset: true,
            body: Container(
              height: Get.height,
              decoration: Get.isDarkMode
                  ? null
                  : BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          Assets.images.background.path,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    addVerticalSpace(100.h),
                    FractionallySizedBox(
                      widthFactor: .6,
                      child: Image.asset(
                        Assets.images.tsflogo.path,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.applyOpacity(0.5),
                            spreadRadius: 1.r,
                            blurRadius: 5.5.r,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'SIGNUP',
                            style: theme.textTheme.headlineSmall,
                          ),
                          addVerticalSpace(20.h),

                          // name input
                          RoundedInputField(
                            hintText: "Name",
                            controller: controller.nameController,
                          ),
                          addVerticalSpace(15.h),

                          // email input
                          RoundedInputField(
                            hintText: "Email",
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          addVerticalSpace(15.h),

                          // password input
                          RoundedInputField(
                            hintText: "Phone",
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          addVerticalSpace(30.h),

                          //login button
                          Obx(
                            () => controller.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColorsLight.mainColor,
                                  )
                                : MainAppButton(
                                    label: "Signup",
                                    onPressed: () {
                                      controller.signUp();
                                    },
                                  ),
                          ),
                          addVerticalSpace(15.h),

                          // create account or signup button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: theme.textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAllNamed(Routes.LOGIN);
                                },
                                child: Text(
                                  "Login",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColorsLight.mainColor),
                                ),
                              ).paddingOnly(left: 10)
                            ],
                          ),

                          addVerticalSpace(15.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
