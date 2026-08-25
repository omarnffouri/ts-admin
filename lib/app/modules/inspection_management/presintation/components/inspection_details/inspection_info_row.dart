import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class InspectionInfoRow extends StatelessWidget {
  const InspectionInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String? value;
  final IconData? icon;

  static const String fallback = 'N/A';

  static const double _minRowWidth = 280;
  static const double _maxRowTextScale = 1.3;

  /// Trims and filters out the literal "null" the API sometimes sends.
  static String resolve(String? value) {
    if (value == null) return fallback;
    final String trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return fallback;
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String resolved = resolve(value);
    final double textScale = MediaQuery.textScalerOf(context).scale(14) / 14;

    final Widget labelView = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 15, color: context.secondaryTextColor),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.secondaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    final Widget valueView = Text(
      resolved,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: context.primaryTextColor,
      ),
    );

    return Semantics(
      label: '$label, $resolved',
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool stacked = constraints.maxWidth < _minRowWidth ||
              textScale > _maxRowTextScale;

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                labelView,
                const SizedBox(height: 2),
                valueView,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: labelView),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  resolved,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.primaryTextColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
