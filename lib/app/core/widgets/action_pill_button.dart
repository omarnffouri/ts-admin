import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Filled pill button used by the request card and the action sheet.
/// Pass a null [onTap] to render it disabled.
class ActionPillButton extends StatelessWidget {
  const ActionPillButton({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.icon,
    this.height = 40,
    this.scaleLabel = false,
    this.isLoading = false,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;
  final double height;

  /// Scale the label instead of ellipsizing (money figures must not truncate).
  final bool scaleLabel;

  /// Swaps the content for a spinner. Pair with a null [onTap] to lock it.
  final bool isLoading;

  Text _labelText([TextOverflow? overflow]) => Text(
        label,
        maxLines: 1,
        overflow: overflow,
        style: Get.textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: foreground.applyOpacity(0.12),
        highlightColor: foreground.applyOpacity(0.06),
        onTap: onTap,
        child: Container(
          height: height,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    strokeCap: StrokeCap.round,
                    color: foreground,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 16, color: foreground),
                      SizedBox(width: 6.w),
                    ],
                    Flexible(
                      child: scaleLabel
                          ? FittedBox(
                              fit: BoxFit.scaleDown, child: _labelText())
                          : _labelText(TextOverflow.ellipsis),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
