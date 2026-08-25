import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class PurchaseOrderDetailsEmptyState extends StatelessWidget {
  const PurchaseOrderDetailsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.compact = true,
  });

  final IconData icon;
  final String title;
  final String message;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double iconSize = compact ? 28 : 40;
    final double medallionSize = compact ? 64 : 96;

    return Semantics(
      label: '$title. $message',
      excludeSemantics: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 40,
          vertical: compact ? 14 : 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: medallionSize,
              height: medallionSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.surfaceVariantColor,
                border: Border.all(color: context.hairlineBorderColor),
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: context.secondaryTextColor,
              ),
            ),
            SizedBox(height: compact ? 12 : 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.tertiaryTextColor,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
