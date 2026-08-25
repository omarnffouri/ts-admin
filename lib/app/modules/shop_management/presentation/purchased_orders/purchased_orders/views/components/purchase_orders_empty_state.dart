import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';

class PurchaseOrdersEmptyState extends StatelessWidget {
  const PurchaseOrdersEmptyState({
    super.key,
    required this.isFiltered,
    required this.filterLabel,
    required this.onClearFilters,
    required this.onCreate,
  });

  final bool isFiltered;
  final String filterLabel;
  final VoidCallback onClearFilters;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    // MainAxisSize.min keeps the content at its natural height, so scaled-up
    // text makes the sliver scroll instead of overflowing.
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyStateView(
          icon: isFiltered
              ? Icons.filter_list_off_outlined
              : Icons.receipt_long_outlined,
          title:
              isFiltered ? 'No matching purchase orders' : 'No purchase orders',
          message: isFiltered
              ? 'No orders match the "$filterLabel" filter. Clear it to see every order.'
              : 'Purchase orders you create will appear here.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
          child: isFiltered
              ? _EmptyStateAction(
                  icon: Icons.filter_alt_off_outlined,
                  label: 'Clear filters'.tr,
                  onPressed: onClearFilters,
                )
              : _EmptyStateAction(
                  icon: Icons.add_rounded,
                  label: 'Create purchase order'.tr,
                  onPressed: onCreate,
                ),
        ),
      ],
    );
  }
}

class _EmptyStateAction extends StatelessWidget {
  const _EmptyStateAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: context.brandColor,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
