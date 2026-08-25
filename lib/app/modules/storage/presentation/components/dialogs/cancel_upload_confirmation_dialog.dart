import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';

class CancelUploadConfirmationDialog extends StatelessWidget {
  final Function() onConfirmationCalled;
  final Function() onCancelCalled;
  const CancelUploadConfirmationDialog({
    super.key,
    required this.onConfirmationCalled,
    required this.onCancelCalled,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Are you sure?',
          style: theme.textTheme.bodyMedium,
        ),
        addVerticalSpace(20.h),
        Row(
          children: [
            addHorizontalSpace(20),
            Expanded(
              child: InkWell(
                onTap: onConfirmationCalled,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColorsLight.dialogCancelButtonColor,
                  ),
                  child: const Center(
                    child: AppText(
                      text: 'Yes',
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
                onTap: onCancelCalled,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColorsLight.mainColor,
                  ),
                  child: const Center(
                    child: AppText(
                      text: 'No',
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
