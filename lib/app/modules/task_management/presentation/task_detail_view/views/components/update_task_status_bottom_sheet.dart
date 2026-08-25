import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/controllers/task_detail_view_controller.dart';

class UpdateTaskStatusBottomSheet extends GetView<TaskDetailViewController> {
  final String title;
  final String buttonLabel;
  const UpdateTaskStatusBottomSheet({
    super.key,
    required this.title,
    required this.buttonLabel,
  });

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
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),

              const Spacer(),

              //
              //
              // close button
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
            ],
          ),
        ),

        //
        //
        // reason

        RoundedInputField(
          label: "Reason",
          hintText: "reason",
          maxLength: 500,
          maxLines: 5,
          minLines: 5,
          showCounting: true,
          isRequired: true,
          validator: (p0) {
            if (p0 == null || p0.isEmpty) {
              return "Description is required";
            }
            return null;
          },
          controller: controller.reasonController,
          contentPadding: const EdgeInsets.all(10),
        ).marginOnly(left: 14, right: 14, top: 20),

        //
        //
        // update status button
        Obx(
          () => MainAppButton(
            label: buttonLabel,
            isLoading: controller.isUpdatingStatus,
            onPressed: () {
              controller.updateTaskStatus();
            },
          ),
        ).marginOnly(left: 14, right: 14, top: 20, bottom: 50),
      ],
    );
  }
}
