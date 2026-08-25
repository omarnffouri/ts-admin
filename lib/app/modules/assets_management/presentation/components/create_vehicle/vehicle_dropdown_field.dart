import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';
import 'package:ts_admin/app/modules/assets_management/domain/entities/create_dropdown_entity.dart';

class VehicleDropdownField extends StatelessWidget {
  const VehicleDropdownField({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.isLoading,
    required this.errorWhileLoading,
    required this.onRetry,
    required this.bottomSheetLabel,
    required this.searchHint,
    required this.fieldLabel,
    required this.emptyMessage,
    this.isRequired = false,
  });

  final List<Item>? items;
  final Rxn<Item> selectedItem;
  final RxBool isLoading;
  final RxBool errorWhileLoading;
  final VoidCallback onRetry;
  final String bottomSheetLabel;
  final String searchHint;
  final String fieldLabel;
  final String emptyMessage;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const VehicleDropdownLoading();
      }

      if (errorWhileLoading.value) {
        return VehicleDropdownMessage(
          icon: Icons.error_outline_rounded,
          message: 'Could not load $fieldLabel options.',
          actionLabel: 'Try again',
          onAction: onRetry,
          isError: true,
        );
      }

      if (items?.isEmpty ?? true) {
        return VehicleDropdownMessage(
          icon: Icons.inbox_rounded,
          message: emptyMessage,
          actionLabel: 'Refresh',
          onAction: onRetry,
        );
      }

      final Item? selected = selectedItem.value;

      return Semantics(
        button: true,
        label: isRequired
            ? '$fieldLabel, required. ${selected?.name ?? 'Nothing selected'}'
            : '$fieldLabel. ${selected?.name ?? 'Nothing selected'}',
        child: SearchableDropDown<Item>(
          list: items ?? [],
          bottomSheetLabel: bottomSheetLabel,
          searchHint: searchHint,
          fieldLabel: fieldLabel,
          fieldHint: fieldLabel,
          isRequired: isRequired,
          showOnlyLetters: true,
          getName: (p0) => p0.name ?? '',
          getImage: (p0) => p0.name ?? '',
          selectedItem: selected,
          dropdownSearchDecoration: SearchableDropdownDecoration.bordered,
          dropdownDecoration: SearchableDropdownDecoration.bordered,
          onItemSelected: (Item? item) {
            if (item != null) {
              selectedItem.value = item;
            }
          },
          itemAsString: (item) => item.name ?? '',
          compareFunction: (a, b) => a == b,
        ),
      );
    });
  }
}

/// Field-level shimmer placeholder shown while the create-dropdown request is
/// in flight — themed for both modes, and roughly the height of the real
/// field so the form does not jump when it resolves.
class VehicleDropdownLoading extends StatelessWidget {
  const VehicleDropdownLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;

    return Shimmer.fromColors(
      baseColor: dark ? Colors.white10 : Colors.black12,
      highlightColor: dark ? Colors.white24 : Colors.white30,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

/// Inline row used for a dropdown's error and empty states: an icon, a
/// message and the existing retry action — the state is never carried by
/// color alone.
class VehicleDropdownMessage extends StatelessWidget {
  const VehicleDropdownMessage({
    super.key,
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.isError = false,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color iconColor =
        isError ? theme.colorScheme.error : context.secondaryTextColor;
    final double textScale = MediaQuery.textScalerOf(context).scale(14) / 14;

    final Widget messageRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ),
      ],
    );

    final Widget action = Semantics(
      button: true,
      label: '$actionLabel loading options',
      child: TextButton(
        onPressed: onAction,
        style: TextButton.styleFrom(
          minimumSize: const Size(64, 48),
          foregroundColor: context.brandColor,
        ),
        child: Text(
          actionLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            color: context.brandColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(start: 12, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      // The retry action drops below the message as soon as the row would be
      // cramped, so a long message or a large text scale can never overflow.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool stacked = textScale > 1.2 || constraints.maxWidth < 300;

          if (!stacked) {
            return Row(
              children: [
                Expanded(child: messageRow),
                action,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 6, end: 12),
                child: messageRow,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: action,
              ),
            ],
          );
        },
      ),
    );
  }
}
