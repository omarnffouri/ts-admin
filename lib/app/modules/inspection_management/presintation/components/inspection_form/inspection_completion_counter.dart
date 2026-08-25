import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class InspectionCompletionCounter extends StatelessWidget {
  const InspectionCompletionCounter({
    super.key,
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) {
      return const SizedBox.shrink();
    }

    final ThemeData theme = Theme.of(context);
    final double progress = (completed / total).clamp(0.0, 1.0);
    final String summary = '$completed of $total checks completed';

    return Semantics(
      container: true,
      label: 'Checklist progress, $summary',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.secondaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: context.isDark
                  ? Colors.white.applyOpacity(0.08)
                  : Colors.black.applyOpacity(0.06),
              valueColor: AlwaysStoppedAnimation<Color>(context.brandColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact "n / m" progress badge shown on each category card.
class InspectionCountBadge extends StatelessWidget {
  const InspectionCountBadge({
    super.key,
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isComplete = total > 0 && completed >= total;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isComplete
            ? context.brandColor.applyOpacity(0.10)
            : context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isComplete
              ? context.brandColor.applyOpacity(0.35)
              : context.hairlineBorderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The icon — not the color — is what marks a finished category.
          if (isComplete) ...[
            Icon(
              Icons.check_circle_rounded,
              size: 13,
              color: context.brandColor,
            ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              '$completed / $total',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isComplete
                    ? context.brandColor
                    : context.secondaryTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
