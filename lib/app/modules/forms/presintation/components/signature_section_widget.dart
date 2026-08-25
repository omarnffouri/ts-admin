import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';

class SignatureSectionWidget extends StatelessWidget {
  final SignatureController controller;

  const SignatureSectionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addVerticalSpace(5),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.14,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Signature(
              controller: controller,
              backgroundColor: Colors.grey[100]!,
            ),
          ),
        ),
        addVerticalSpace(5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Get.theme.scaffoldBackgroundColor
                  : AppColorsLight.white, //todo review for dark mode
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColorsLight.mainColor, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor:
                    AppColorsLight.mainColor, //todo review for dark mode
                onTap: () => controller.clear(),
                child: Center(
                  child: Text(
                    'UNDO',
                    style: Get.textTheme.bodyMedium,
                  ),
                ).paddingSymmetric(vertical: 3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
