import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Shared layered surface used by every shipment-details section so spacing,
/// borders, and corner radii stay consistent across the page.
class ShipmentSectionCard extends StatelessWidget {
  const ShipmentSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  /// Shared with the page's skeleton so the two silhouettes can't drift.
  static BoxDecoration decoration(BuildContext context) => BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: decoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.brandColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Small inline message used for a section's empty state (e.g. no billing
/// charges, no stops, no documents) without pulling in the full-page
/// [EmptyStateView].
class ShipmentSectionEmptyMessage extends StatelessWidget {
  const ShipmentSectionEmptyMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        message.tr,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.tertiaryTextColor,
            ),
      ),
    );
  }
}
