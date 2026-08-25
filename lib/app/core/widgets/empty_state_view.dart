import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Shared empty state: a soft-tinted icon medallion with a title and
/// supporting message, revealed with a fade + slide-up animation.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;

  /// Optional recovery action (retry, clear filters, …). Rendered only when
  /// both [actionLabel] and [onAction] are supplied.
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // Brand red in light mode, white on the neutral dark surface — the same
    // accent treatment used by list-card status icons.
    final Color accentColor =
        isDark ? Colors.white.applyOpacity(0.85) : AppColorsLight.mainColor;

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, 18 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.white.applyOpacity(0.06)
                      : AppColorsLight.mainColor.applyOpacity(0.08),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.applyOpacity(0.08)
                        : AppColorsLight.mainColor.applyOpacity(0.10),
                  ),
                ),
                child: Icon(icon, size: 40, color: accentColor),
              ),
              const SizedBox(height: 22),
              Text(
                title.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  height: 1.45,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColorsLight.mainColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(actionIcon ?? Icons.refresh_rounded),
                  label: Text(actionLabel!.tr),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
