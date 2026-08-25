import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';

/// Contextual empty state for the truck directory: distinguishes "no
/// trucks at all" from "no results for the current search/filter" so the
/// offered action always makes sense.
class TrucksEmptyState extends StatelessWidget {
  const TrucksEmptyState({
    super.key,
    required this.isSearching,
    required this.isFiltering,
    required this.onAddTruck,
    required this.onClearSearch,
    required this.onClearFilter,
  });

  final bool isSearching;
  final bool isFiltering;
  final VoidCallback onAddTruck;
  final VoidCallback onClearSearch;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    final bool hasActiveRefinement = isSearching || isFiltering;

    final IconData icon = isSearching
        ? Icons.search_off_rounded
        : isFiltering
            ? Icons.filter_alt_off_rounded
            : Icons.local_shipping_outlined;

    final String title = isSearching
        ? 'No matching trucks'
        : isFiltering
            ? 'No trucks in this status'
            : 'No trucks yet';

    final String message = isSearching && isFiltering
        ? 'Nothing matches your search and status filter. Try adjusting them.'
        : isSearching
            ? 'Nothing matches your search. Try a different name, plate, or VIN.'
            : isFiltering
                ? 'Try selecting a different status filter.'
                : 'Trucks you add will appear here.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyStateView(icon: icon, title: title, message: message),
            const SizedBox(height: 4),
            if (hasActiveRefinement)
              _EmptyStateAction(
                icon: Icons.close_rounded,
                label: isSearching && isFiltering
                    ? 'Clear search & filter'.tr
                    : isSearching
                        ? 'Clear search'.tr
                        : 'Clear filter'.tr,
                filled: false,
                onTap: () {
                  if (isSearching) onClearSearch();
                  if (isFiltering) onClearFilter();
                },
              )
            else
              _EmptyStateAction(
                icon: Icons.add_rounded,
                label: 'Add Truck'.tr,
                filled: true,
                onTap: onAddTruck,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateAction extends StatelessWidget {
  const _EmptyStateAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.filled,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final Color fg = filled ? Colors.white : context.brandColor;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: filled ? context.brandColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: filled
                    ? Colors.transparent
                    : context.brandColor.applyOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
