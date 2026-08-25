import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';

class ConfirmationDialog extends StatelessWidget {
  final Function() onConfirmation;
  final Function() onCancel;
  final String message;
  final String confirmationText;
  final String cancelText;
  const ConfirmationDialog({
    super.key,
    required this.onConfirmation,
    required this.onCancel,
    this.message = 'Are you sure?',
    this.confirmationText = 'Yes',
    this.cancelText = 'No',
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          style: theme.textTheme.bodyMedium,
        ),
        addVerticalSpace(20.h),
        Row(
          children: [
            addHorizontalSpace(20),
            Expanded(
              child: InkWell(
                onTap: onConfirmation,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColorsLight.dialogCancelButtonColor,
                  ),
                  child: Center(
                    child: AppText(
                      text: confirmationText,
                      color: AppColorsLight.white,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: InkWell(
                onTap: onCancel,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColorsLight.mainColor,
                  ),
                  child: Center(
                    child: AppText(
                      text: cancelText,
                      color: AppColorsLight.white,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ),
            addHorizontalSpace(20),
          ],
        ),
      ],
    );
  }
}
