import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';

import '../../controllers/new_leave_request_controller.dart';

class SignatureWidget extends GetView<NewLeaveRequestController> {
  const SignatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          text: 'Signature',
          style: Get.theme.textTheme.titleMedium,
        ),
        addVerticalSpace(10),
        Container(
          height: Get.height * 0.14,
          // add border
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[600]!,
              width: .5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Signature(
              controller: controller.signatureController,
              backgroundColor:
                  Get.isDarkMode ? AppColorsDark.mainColor : Colors.grey[400]!,
            ),
          ),
        ),
        addVerticalSpace(4),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: AppColorsLight.mainColor,
            hoverColor: AppColorsLight.mainColor,
            onTap: () {
              controller.signatureController.clear();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              width: double.infinity,
              child: Center(
                child: AppText(
                  text: 'UNDO',
                  style: Get.theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
