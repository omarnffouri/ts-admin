import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';

import '../../controllers/create_announcement_controller.dart';

class CategoryDropdownWidget extends GetView<CreateAnnouncementController> {
  const CategoryDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const DropdownLoadingWidget()
          : AnnouncementDropdown<String>(
              hintText: 'Select User Type',
              items: const ['Admins', 'Drivers'],
              selectedItem:
                  controller.selectedCategoryType.value?.isEmpty ?? true
                      ? null
                      : controller.selectedCategoryType.value,
              itemAsString: (String item) => item,
              onChanged: controller.onCategoryTypeChanged,
            ),
    );
  }
}

/// Dropdown styled like the page's other card-surface fields: filled
/// background, hairline idle border, brand focus ring, and a rounded,
/// softly-shadowed menu.
class AnnouncementDropdown<T> extends StatelessWidget {
  const AnnouncementDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedItem,
    required this.itemAsString,
    required this.onChanged,
  });

  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemAsString;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color hairline = context.hairlineBorderColor;

    final idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: hairline),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: context.focusedBorderColor,
        width: 1.4,
      ),
    );

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        value: selectedItem,
        onChanged: onChanged,
        hint: Text(
          hintText,
          style: TextStyle(fontSize: 14, color: context.hintTextColor),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: context.fieldFillColor,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
          border: idleBorder,
          enabledBorder: idleBorder,
          focusedBorder: focusedBorder,
        ),

        // Items
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemAsString(item),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),

        // Button styles
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(left: 10, right: 12),
        ),

        // Icon styles
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.hintTextColor,
          ),
          iconSize: 24,
        ),

        // Menu styles (menu stays opaque so page content can't bleed through)
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          offset: const Offset(0, -6),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: hairline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.applyOpacity(context.isDark ? 0.45 : 0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }
}
