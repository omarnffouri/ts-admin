import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class PurchaseOrderStatusBadge extends StatelessWidget {
  const PurchaseOrderStatusBadge({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final String rawStatus = status?.trim() ?? '';
    final String label =
        rawStatus.isEmpty ? 'N/A' : rawStatus.toTitleCase().trim();
    final Color accent = getOrderStatusColor(rawStatus);

    return Semantics(
      label: 'Status: $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: accent.applyOpacity(context.isDark ? 0.20 : 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: accent.applyOpacity(0.34)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color:
                          context.isDark ? accent.applyOpacity(0.95) : accent,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color getOrderStatusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'approved':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    case 'completed':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}
