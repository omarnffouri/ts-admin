import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_red_header.dart';

/// Shared compact header for read/detail pages.
///
/// The subtitle is intentionally allowed to wrap so localized form names do
/// not force the header into a fixed-height layout.
class AppReadHeader extends StatelessWidget {
  const AppReadHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.trailing,
    this.subtitleSemanticsLabel,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  /// Optional action rendered at the end of the header row (e.g. a filter
  /// button). Foreground colors should come from `colorScheme.onPrimary`.
  final Widget? trailing;

  /// Screen-reader label for the subtitle. Defaults to the form-type wording
  /// used by the detail pages.
  final String? subtitleSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foregroundColor = theme.colorScheme.onPrimary;
    final EdgeInsets viewPadding = MediaQuery.paddingOf(context);

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        viewPadding.left + 16.w,
        viewPadding.top + 10.h,
        viewPadding.right + 16.w,
        16.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Semantics(
            button: true,
            label: MaterialLocalizations.of(context).backButtonTooltip,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: foregroundColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: foregroundColor.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 21,
                    color: foregroundColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Semantics(
                  label: subtitleSemanticsLabel ?? 'Form type: $subtitle',
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: foregroundColor.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 8.w),
            trailing!,
          ],
        ],
      ),
    );
  }
}
