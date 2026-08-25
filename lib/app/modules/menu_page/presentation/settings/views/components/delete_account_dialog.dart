import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';

import '../../controllers/settings_controller.dart';

void showDeleteAccountDialog(
  BuildContext context,
  SettingsController controller,
) {
  final ThemeData theme = Theme.of(context);

  Get.defaultDialog(
    title: 'Delete Account',
    titleStyle: theme.textTheme.bodyLarge,
    titlePadding: EdgeInsets.only(top: 10.h),
    content: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Are you sure?",
              style: theme.textTheme.labelLarge,
            ),
            addVerticalSpace(10),
            Text(
              "Please be aware that initiating this process will result in your account being scheduled for deletion, which will take effect after a 15-day grace period. This action is irreversible once completed.",
              style: theme.textTheme.bodyMedium,
            ),
            addVerticalSpace(10),
            Text(
              "During these 15 days, you have the option to reactivate your account simply by logging in. However, if you choose not to do so within this timeframe, your account will be permanently deleted.",
              style: theme.textTheme.bodyMedium,
            ),
            addVerticalSpace(10),
            Text(
              "As a result, all data associated with your account will be lost and cannot be recovered — you will no longer be able to access this account or its associated services.",
              style: theme.textTheme.bodyMedium,
            ),
            addVerticalSpace(20.h),
            Obx(
              () => InkWell(
                onTap: () {
                  controller.isChecked.value = !controller.isChecked.value;
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.isChecked.value
                        ? SizedBox(
                            height: 25.h,
                            width: 25.w,
                            child: SvgPicture.asset(
                              Assets.icons.checkMark,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 25.h,
                            width: 25.w,
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                          ),
                    addHorizontalSpace(10.w),
                    SizedBox(
                      width: Get.width * .55,
                      child: Wrap(
                        children: [
                          Text(
                            'I understand, and I want to proceed with the account deletion.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColorsLight.mainColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            addVerticalSpace(20),
          ],
        ).paddingSymmetric(horizontal: 20.w),
        Row(
          children: [
            addHorizontalSpace(10),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (controller.isChecked.value) {
                    controller.logout();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.grey,
                  ),
                  child: const Center(
                    child: AppText(
                      text: 'Yes, Delete',
                      color: Colors.white,
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
                  controller.isChecked.value = false;
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: theme.primaryColor,
                  ),
                  child: const Center(
                    child: AppText(
                      text: 'No',
                      color: Colors.white,
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
    ),
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
  );
}
