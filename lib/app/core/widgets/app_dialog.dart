import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required Widget title,
  String? description,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Center(child: title),
      insetPadding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0.r),
        ),
      ),
      content: description != null ? Text(description) : null,
      elevation: 2,
      actions: <Widget>[
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addHorizontalSpace(20.w),
                Expanded(
                  child: SizedBox(
                    height: 80.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E5E5E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "I'm",
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: AppColorsLight.white,
                            ),
                          ),
                          Text(
                            "Admin",
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColorsLight.white,
                            ),
                          ).paddingOnly(top: 5.h),
                        ],
                      ),
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed(Routes.SIGNUP);
                      },
                    ),
                  ),
                ),
                addHorizontalSpace(20.w),
                Expanded(
                  child: SizedBox(
                    height: 80.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE21F26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "I'm",
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: AppColorsLight.white,
                            ),
                          ),
                          Text(
                            "Customer",
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColorsLight.white,
                            ),
                          ).paddingOnly(top: 5.h),
                        ],
                      ),
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.REQUEST_LOADS);
                      },
                    ),
                  ),
                ),
                addHorizontalSpace(20.w)
              ],
            ),
            addVerticalSpace(30.h)
          ],
        ),
      ],
    ),
  );
}
