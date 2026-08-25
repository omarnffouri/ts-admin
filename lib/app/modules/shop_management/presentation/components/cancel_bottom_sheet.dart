import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';

class CancelBottomSheet extends StatefulWidget {
  final String name;
  final String title;
  final RxBool isLoading;
  final TextEditingController reasonController;
  final void Function() onCancel;

  const CancelBottomSheet({
    super.key,
    required this.name,
    required this.title,
    required this.isLoading,
    required this.reasonController,
    required this.onCancel,
  });

  @override
  State<CancelBottomSheet> createState() => _CancelBottomSheetState();
}

class _CancelBottomSheetState extends State<CancelBottomSheet> {
  final RxBool _hasError = false.obs;
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return SingleChildScrollView(
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: key,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Heading
                    Text(
                      widget.title,
                      style: textTheme.titleLarge,
                    ),
                    // Close icon
                    GestureDetector(
                      onTap: () {
                        if (!widget.isLoading.value) {
                          widget.reasonController.clear();
                          Get.back();
                        }
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color:
                            Get.isDarkMode ? Colors.white : theme.primaryColor,
                      ),
                    ),
                  ],
                ),

                // Body
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "Are you sure you want to ",
                          style: textTheme.labelLarge,
                          children: [
                            TextSpan(
                              text: "Cancel ",
                              style: textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColorsLight.mainColor,
                              ),
                            ),
                            TextSpan(
                                text:
                                    "the ${widget.name}?\nThis action cannot be undone."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).marginOnly(top: 20),

                const SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    controller: widget.reasonController,
                    maxLines: 3,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    validator: (value) =>
                        value!.isEmpty ? "Please provide a reason" : null,
                    decoration: InputDecoration(
                      labelText: "Reason (Required)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColorsLight.mainColor,
                        ),
                      ),
                      errorText:
                          _hasError.value ? "Please provide a reason" : null,
                    ),
                    onChanged: (_) => _hasError.value = false,
                  ),
                ),

                // delete resource button and loading view
                Obx(
                  () => widget.isLoading.value
                      ? CircularProgressIndicator(
                          color: Get.isDarkMode
                              ? Colors.white
                              : AppColorsLight.mainColor,
                          strokeCap: StrokeCap.round,
                          strokeWidth: 5,
                        )
                      : Row(
                          children: [
                            // Confirm button (Disable/Delete)
                            Expanded(
                              child: RoundedBorderButton(
                                label: "Cancel",
                                onPressed: () {
                                  if (key.currentState!.validate()) {
                                    widget.onCancel();
                                  } else {
                                    _hasError.value = true;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Cancel button
                            Expanded(
                              child: RoundedFillButton(
                                label: "Close",
                                onPressed: () {
                                  widget.reasonController.clear();
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                ).marginSymmetric(vertical: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
