import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/controllers/form_detail_view_controller.dart';

class FormRejectionBottomSheet extends GetView<FormDetailViewController> {
  const FormRejectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // group name
            const Text(
              "Rejection Reason",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),

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

        //
        // reason name input
        RoundedInputField(
          hintText: "Enter reason",
          controller: controller.rejectionReasonController,
          keyboardType: TextInputType.text,
          maxLength: 500,
          maxLines: 7,
          minLines: 7,
          showCounting: true,
        ).paddingAll(10),

        const SizedBox(
          height: 200,
        ),

        MainAppButton(
          label: "Confirm",
          onPressed: () {
            // calling api
            controller.rejectForm();
          },
        ).paddingAll(10).marginOnly(bottom: 20)
      ],
    );
  }
}
