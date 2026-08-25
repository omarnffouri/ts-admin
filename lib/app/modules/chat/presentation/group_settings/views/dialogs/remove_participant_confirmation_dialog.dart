import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/controllers/group_settings_controller.dart';

class RemoveParticipantConfirmationDialog
    extends GetView<GroupSettingsController> {
  final String name;
  final Function() onRemoveCalled;
  const RemoveParticipantConfirmationDialog(
      {super.key, required this.name, required this.onRemoveCalled});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Are you sure you want to remove $name?',
          style: theme.textTheme.bodyMedium,
        ),
        addVerticalSpace(20.h),
        Row(
          children: [
            addHorizontalSpace(20),
            Expanded(
              child: InkWell(
                onTap: onRemoveCalled,
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
                      text: 'Remove',
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
                onTap: () {
                  Get.back();
                },
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
                      text: 'Dismiss',
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
