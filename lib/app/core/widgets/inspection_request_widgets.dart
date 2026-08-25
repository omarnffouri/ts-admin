import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Neutral, text-first status chip. Never encodes pass/fail through color —
/// the status wording itself carries the meaning. Shared by the inspection
/// request cards (driver, truck, trailer).
class InspectionStatusBadge extends StatelessWidget {
  const InspectionStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: 'Status, $status',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.hairlineBorderColor),
        ),
        child: Text(
          status,
          style: theme.textTheme.labelSmall?.copyWith(
            color: context.secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// A labeled detail line inside an expanded inspection card: icon + label on
/// the leading edge, wrapping value on the trailing edge. Shared by the
/// inspection request cards (driver, truck, trailer).
class InspectionMetadataRow extends StatelessWidget {
  const InspectionMetadataRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.secondaryTextColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
