import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';

/// Compact accessible capsule for a shipment status, reusing the existing
/// [getShipmentStatusColor] palette so the color mapping stays identical to
/// the rest of the app.
class ShipmentStatusBadge extends StatelessWidget {
  const ShipmentStatusBadge({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final Color color = getShipmentStatusColor(status);
    final String label = (status == null || status!.isEmpty)
        ? 'Unknown'
        : status!.formatStatus();

    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.applyOpacity(0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.applyOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
