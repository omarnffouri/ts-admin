import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class LeaveStatusBadge extends StatelessWidget {
  final String? status;

  const LeaveStatusBadge({super.key, required this.status});

  Color _getBackgroundColor(BuildContext context) {
    final isDark = context.isDark;
    final statusLower = status?.toLowerCase() ?? 'pending';

    switch (statusLower) {
      case 'approved':
        return isDark
            ? Colors.green.applyOpacity(0.15)
            : Colors.green.applyOpacity(0.1);
      case 'rejected':
        return isDark
            ? Colors.red.applyOpacity(0.15)
            : Colors.red.applyOpacity(0.1);
      case 'pending':
      default:
        return isDark
            ? Colors.amber.applyOpacity(0.15)
            : Colors.amber.applyOpacity(0.1);
    }
  }

  Color _getTextColor(BuildContext context) {
    final isDark = context.isDark;
    final statusLower = status?.toLowerCase() ?? 'pending';

    switch (statusLower) {
      case 'approved':
        return isDark ? Colors.green.shade300 : Colors.green.shade700;
      case 'rejected':
        return isDark ? Colors.red.shade300 : Colors.red.shade700;
      case 'pending':
      default:
        return isDark ? Colors.amber.shade300 : Colors.amber.shade700;
    }
  }

  Color _getIconColor(BuildContext context) {
    final isDark = context.isDark;
    final statusLower = status?.toLowerCase() ?? 'pending';

    switch (statusLower) {
      case 'approved':
        return isDark ? Colors.green.shade400 : Colors.green.shade600;
      case 'rejected':
        return isDark ? Colors.red.shade400 : Colors.red.shade600;
      case 'pending':
      default:
        return isDark ? Colors.amber.shade400 : Colors.amber.shade600;
    }
  }

  IconData _getStatusIcon(String statusLower) {
    switch (statusLower) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'pending':
      default:
        return Icons.schedule_rounded;
    }
  }

  String _getStatusLabel(String? statusLabel) {
    if (statusLabel == null) return 'Pending';
    return statusLabel[0].toUpperCase() +
        statusLabel.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final statusLower = status?.toLowerCase() ?? 'pending';
    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);
    final iconColor = _getIconColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.applyOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(statusLower),
            size: 14,
            color: iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusLabel(status),
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
