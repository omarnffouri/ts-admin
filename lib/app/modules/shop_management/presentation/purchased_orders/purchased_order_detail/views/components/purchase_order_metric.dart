import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class PurchaseOrderMetric extends StatelessWidget {
  const PurchaseOrderMetric({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.alignEnd = false,
    this.emphasize = false,
    this.semanticsLabel,
  });

  final String label;
  final String value;
  final IconData? icon;
  final bool alignEnd;
  final bool emphasize;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: semanticsLabel ?? '$label: $value',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment:
            alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: context.tertiaryTextColor),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: alignEnd ? TextAlign.end : TextAlign.start,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.tertiaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: alignEnd ? TextAlign.end : TextAlign.start,
            style: (emphasize
                    ? theme.textTheme.titleSmall
                    : theme.textTheme.bodyMedium)
                ?.copyWith(
              color: context.primaryTextColor,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
