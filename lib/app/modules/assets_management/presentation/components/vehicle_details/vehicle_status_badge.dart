import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

enum VehicleStatusTone { success, pending, danger, neutral }

extension VehicleStatusToneColor on VehicleStatusTone {
  Color color(BuildContext context) {
    final bool dark = context.isDark;
    switch (this) {
      case VehicleStatusTone.success:
        return dark ? Colors.green.shade300 : Colors.green.shade700;
      case VehicleStatusTone.pending:
        return dark ? Colors.orange.shade300 : Colors.orange.shade800;
      case VehicleStatusTone.danger:
        return Theme.of(context).colorScheme.error;
      case VehicleStatusTone.neutral:
        return context.secondaryTextColor;
    }
  }
}

VehicleStatusTone vehicleStatusTone(String? raw) {
  switch (raw?.trim().toLowerCase()) {
    case 'active':
    case 'uploaded':
    case 'approved':
    case 'completed':
    case 'installed':
      return VehicleStatusTone.success;
    case 'pending':
    case 'hold':
    case 'missing':
      return VehicleStatusTone.pending;
    case 'expired':
    case 'inactive':
    case 'rejected':
      return VehicleStatusTone.danger;
    default:
      return VehicleStatusTone.neutral;
  }
}

class VehicleStatusBadge extends StatelessWidget {
  const VehicleStatusBadge({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
    this.semanticsLabel,
  });

  final String label;
  final VehicleStatusTone tone;
  final IconData? icon;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final Color color = tone.color(context);

    return Semantics(
      label: semanticsLabel ?? '${'Status'}: $label',
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: icon == null ? 10 : 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: color.applyOpacity(context.isDark ? 0.20 : 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.applyOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
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
