import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import 'vehicle_section.dart';

class SectionEmptyState extends StatelessWidget {
  const SectionEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.dense = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent =
        context.isDark ? Colors.white.applyOpacity(0.85) : context.brandColor;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: dense ? 14 : 26,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: dense ? 52 : 64,
              height: dense ? 52 : 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.isDark
                    ? Colors.white.applyOpacity(0.06)
                    : context.brandColor.applyOpacity(0.08),
                border: Border.all(
                  color: context.isDark
                      ? Colors.white.applyOpacity(0.08)
                      : context.brandColor.applyOpacity(0.10),
                ),
              ),
              child: Icon(icon, size: dense ? 24 : 30, color: accent),
            ),
            SizedBox(height: dense ? 12 : 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.tertiaryTextColor,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class VehicleDetailsErrorState extends StatelessWidget {
  const VehicleDetailsErrorState({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;

  /// Per-tab clause only — the recovery hint is appended here.
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 30),
      sliver: SliverToBoxAdapter(
        child: VehicleSectionCard(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              children: [
                SectionEmptyState(
                  icon: Icons.info_outline_rounded,
                  title: title,
                  message: '$message Pull down to refresh, or try again.',
                ),
                SizedBox(
                  width: double.infinity,
                  child: MainAppButton(
                    label: 'Retry',
                    onPressed: onRetry,
                    borderRadius: 14,
                    leadingIcon: const Icon(
                      Icons.refresh_rounded,
                      size: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
