import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../controllers/otp_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});
  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: scaffoldBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                Assets.icons.otp,
                height: 250.h,
                width: 250.w,
              ),

              //
              //
              // heading
              Text(
                'Verification',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),

              //
              //
              // label
              const Text(
                'Enter your OTP code number',
              ),

              //
              //
              // otp input view
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Pinput(
                    length: 4,
                    onCompleted: (value) {
                      controller.verifyOtp();
                    },
                    onChanged: (value) {
                      controller.pinController.text = value;
                      controller.pinText.value = value;
                    },
                    focusNode: controller.pinPutFocusNode,
                    autofocus: true,
                    controller: controller.pinController,
                    defaultPinTheme: PinTheme(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.applyOpacity(.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColorsLight.mainColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              //
              //
              // verify otp button
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MainAppButton(
                    label: 'Verify',
                    isLoading: controller.isVerifing.value,
                    onPressed: controller.pinText.value.length != 4
                        ? null
                        : controller.verifyOtp,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //
              //
              // label
              const Text(
                "Didn't receive the code?",
              ),

              //
              //
              // resent otp timer text
              Obx(
                () => Visibility(
                  visible: controller.start > 0,
                  child: TextButton(
                    onPressed: () {},
                    child: AppText(
                      text: 'Resend in ${controller.start} seconds',
                      color: Colors.red,
                      size: 14,
                    ),
                  ),
                ),
              ),

              //
              //
              // resend otp button
              Obx(
                () => Visibility(
                  visible: controller.start == 0,
                  child: TextButton(
                    onPressed: () {
                      controller.sendOtp();
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: 'Resent code',
                          color: AppColorsLight.mainColor,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
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
