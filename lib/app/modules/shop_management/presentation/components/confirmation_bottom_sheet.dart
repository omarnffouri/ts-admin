import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';

class ConfirmationBottomSheet extends StatefulWidget {
  final String name;
  final String title;
  final String confirmText;
  final String confirmTextBtn;
  final RxBool isLoading;
  final void Function() onConfirm;

  const ConfirmationBottomSheet({
    super.key,
    required this.name,
    required this.title,
    required this.isLoading,
    required this.confirmText,
    required this.confirmTextBtn,
    required this.onConfirm,
  });

  @override
  State<ConfirmationBottomSheet> createState() =>
      _ConfirmationBottomSheetState();
}

class _ConfirmationBottomSheetState extends State<ConfirmationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      Get.back();
                    }
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: Get.isDarkMode ? Colors.white : theme.primaryColor,
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
                          text: "${widget.confirmText} ",
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColorsLight.mainColor,
                          ),
                        ),
                        TextSpan(
                            text:
                                "${widget.name} ?\nThis action cannot be undone."),
                      ],
                    ),
                  ),
                ),
              ],
            ).marginOnly(top: 20),

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
                        // Confirm button
                        Expanded(
                          child: RoundedBorderButton(
                            label: widget.confirmTextBtn,
                            onPressed: widget.onConfirm,
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Cancel button
                        Expanded(
                          child: RoundedFillButton(
                            label: "Back",
                            onPressed: () {
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
    );
  }
}
