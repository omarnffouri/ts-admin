import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';

class InspectionPageHeader extends StatelessWidget {
  const InspectionPageHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  final String title;

  /// Defaults to the standard back navigation used before the redesign.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
          //
          // back button
          Semantics(
            button: true,
            label: 'Back',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack ?? () => Get.back(),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: Colors.white.applyOpacity(0.16),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.applyOpacity(0.22),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          //
          // heading — wraps to a second line so long localized titles never
          // overflow the gradient.
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
