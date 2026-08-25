import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/trucks_controller.dart';

/// Search field + status filter control area. Keeps the same two-field
/// side-by-side arrangement the page already used, restyled with the
/// app's card-surface field tokens, and stacks vertically on narrow
/// screens or with large text so nothing gets squeezed or clipped.
class TrucksSearchAndFilter extends GetView<TrucksController> {
  const TrucksSearchAndFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double textScale =
                  MediaQuery.textScalerOf(context).scale(14) / 14;
              final bool stack = constraints.maxWidth < 340 || textScale > 1.3;

              final Widget search = _SearchField(controller: controller);
              final Widget filter = _StatusFilterField(controller: controller);

              if (stack) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    search,
                    const SizedBox(height: 10),
                    filter,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: search),
                  const SizedBox(width: 10),
                  Expanded(child: filter),
                ],
              );
            },
          ),
          Obx(() {
            final String status = controller.selectedStatus.value;
            if (status.toLowerCase() == 'all') return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    size: 15,
                    color: context.brandColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${'Filtering by'.tr}: ${status.toTitleCase()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.secondaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Clear filter'.tr,
                    child: InkWell(
                      onTap: () => controller.handleStatusChange('all'),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: Text(
                          'Clear'.tr,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.brandColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TrucksController controller;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.hairlineBorderColor),
    );
    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.focusedBorderColor, width: 1.4),
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: context.isDark ? Colors.white10 : Colors.black12,
          highlightColor: context.isDark ? Colors.white24 : Colors.white30,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }

      return TextFormField(
        controller: controller.txtSearchController,
        maxLines: 1,
        textInputAction: TextInputAction.search,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: (_) => controller.onSearch(),
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: context.fieldFillColor,
          hintText: 'Search trucks'.tr,
          hintStyle: TextStyle(color: context.hintTextColor, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: idleBorder,
          enabledBorder: idleBorder,
          focusedBorder: focusedBorder,
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: context.secondaryTextColor,
          ),
          suffixIcon: Obx(
            () => controller.txtSearch.value.isEmpty
                ? const SizedBox.shrink()
                : Semantics(
                    button: true,
                    label: 'Clear search'.tr,
                    child: IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: context.secondaryTextColor,
                      ),
                      onPressed: () {
                        controller.txtSearchController.clear();
                        controller.txtSearch.value = '';
                        controller.onSearch();
                      },
                    ),
                  ),
          ),
        ),
      );
    });
  }
}

class _StatusFilterField extends StatelessWidget {
  const _StatusFilterField({required this.controller});

  final TrucksController controller;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.hairlineBorderColor),
    );
    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.focusedBorderColor, width: 1.4),
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: context.isDark ? Colors.white10 : Colors.black12,
          highlightColor: context.isDark ? Colors.white24 : Colors.white30,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }

      return DropdownButtonFormField2<String>(
        isExpanded: true,
        value: controller.selectedStatus.value,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: context.fieldFillColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: idleBorder,
          enabledBorder: idleBorder,
          focusedBorder: focusedBorder,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        items: controller.statusOptions
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item.toTitleCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
            .toList(),
        onChanged: controller.handleStatusChange,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 4),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.secondaryTextColor,
          ),
          iconSize: 22,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      );
    });
  }
}
