import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Green check + approved figure; renders nothing when [amount] is null.
class ApprovedAmountCaption extends StatelessWidget {
  const ApprovedAmountCaption({super.key, required this.amount});

  /// Pre-formatted approved figure ("$5,137.26").
  final String? amount;

  @override
  Widget build(BuildContext context) {
    if (amount == null) return const SizedBox.shrink();

    final Color green = context.successColor;

    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 13.sp, color: green),
          SizedBox(width: 3.w),
          Text(
            amount!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: green,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
