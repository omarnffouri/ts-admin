import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/controllers/settings_controller.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

class BiometricBottomSheet extends GetView<SettingsController> {
  const BiometricBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    //
    //
    //
    ThemeData theme = Theme.of(context);

    return Column(
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Row(children: [
            const Text(
              "Biometric",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            const Spacer(),
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
          ]),
        ),

        Text(
          "Tap to ${controller.biometricEnabled.value ? "disable" : "enable"} biometric",
          style: theme.textTheme.labelLarge?.copyWith(
            color: Get.isDarkMode ? Colors.white : AppColorsLight.mainColor,
          ),
        ).marginOnly(top: 30),

        //
        //
        // animation view
        Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: GestureDetector(
            onTap: controller.toggleBiometric,
            onDoubleTap: controller.toggleBiometric,
            onLongPress: controller.toggleBiometric,
            child: Center(
              child: Lottie.asset(
                Assets.jsons.biometricAnimation,
              ),
            ),
          ),
        ).marginOnly(bottom: 35),

        //
        //
      ],
    );
  }
}
