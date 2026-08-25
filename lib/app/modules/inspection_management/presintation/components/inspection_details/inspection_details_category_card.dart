import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class InspectionDetailsCategoryCard extends StatelessWidget {
  const InspectionDetailsCategoryCard({
    super.key,
    required this.title,
    required this.passed,
    required this.total,
    required this.tileController,
    required this.onExpansionChanged,
    required this.children,
  });

  final String title;
  final int passed;
  final int total;
  final ExpansibleController tileController;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ExpansionTile(
        controller: tileController,
        initiallyExpanded: false,
        onExpansionChanged: onExpansionChanged,
        maintainState: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: context.secondaryTextColor,
        collapsedIconColor: context.secondaryTextColor,
        expansionAnimationStyle:
            reduceMotion ? AnimationStyle.noAnimation : null,
        title: Semantics(
          label: total > 0 ? '$title, $passed of $total passed' : title,
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.primaryTextColor,
                ),
              ),
              if (total > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '$passed of $total passed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        children: [
          Divider(height: 1, color: context.hairlineBorderColor),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

/// One recorded answer: a status icon, the check name, and the status in
/// words — never color alone. Nothing here is tappable.
class InspectionAnswerRow extends StatelessWidget {
  const InspectionAnswerRow({
    super.key,
    required this.name,
    required this.isPassed,
    required this.statusLabel,
  });

  final String name;
  final bool isPassed;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isPassed ? context.successColor : context.dangerColor;

    return Semantics(
      label: '$name, $statusLabel',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                isPassed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 18,
                color: color,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.primaryTextColor,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                statusLabel,
                textAlign: TextAlign.end,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
