import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/controllers/form_detail_view_controller.dart';

import '../forms/controllers/forms_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class FormAppbar extends GetView<FormDetailViewController> {
  const FormAppbar({super.key, required this.formName});
  final String formName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
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
          //
          //
          // back buttonm, image, name
          const _Header(),

          //
          //
          // form title
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Text(
              (controller.form!.formName ?? ""),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColorsLight.mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends GetView<FormsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(10),
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
                  "Form Details",
                  maxLines: 1,
                  style: Get.theme.textTheme.titleLarge
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
