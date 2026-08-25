import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class CustomStringDropdownWidget<T> extends StatelessWidget {
  const CustomStringDropdownWidget({
    super.key,
    required this.hintText,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    required this.itemAsString,
    required this.isDarkMode,
    this.isEnabled = true,
    this.labelText,
    this.isRequired = false,
    this.bottomSpacing = 20,
  });

  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemAsString;
  final bool isDarkMode;
  final bool isEnabled;
  final String? labelText;
  final bool isRequired;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<T>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.hintTextColor,
                  ),
            ),
            decoration: InputDecoration(
              label: RichText(
                text: TextSpan(
                  text: labelText ?? hintText,
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [
                    if (isRequired)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: context.brandColor),
                      ),
                  ],
                ),
              ),
              filled: true,
              fillColor: context.fieldFillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.hairlineBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: context.focusedBorderColor,
                  width: 1.4,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.hairlineBorderColor),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),

            // Items with dividers
            items: _addDividersAfterItems(items, itemAsString),
            onChanged: onChanged,
            value: selectedItem,

            // Button styles
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 10),
            ),

            // Icon styles
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: isDarkMode ? Colors.white : Colors.black45,
              ),
              iconSize: 24,
            ),

            // Dropdown styles
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isDarkMode ? Colors.white24 : Colors.black26,
                  width: 1.5,
                ),
                boxShadow: isDarkMode
                    ? null
                    : [
                        const BoxShadow(
                          color: Colors.white70,
                          blurRadius: 2,
                          spreadRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
            ),

            // Menu item styles
            menuItemStyleData: MenuItemStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              customHeights: _getCustomItemsHeights(items.length),
            ),
          ),
        ).marginOnly(bottom: bottomSpacing),
      ),
    );
  }

  // Add dividers after items
  // ignore: avoid_shadowing_type_parameters
  List<DropdownMenuItem<T>> _addDividersAfterItems<T>(
      List<T> items, String Function(T) itemAsString) {
    final List<DropdownMenuItem<T>> menuItems = [];
    for (int i = 0; i < items.length; i++) {
      menuItems.add(
        DropdownMenuItem<T>(
          value: items[i],
          child: Text(itemAsString(items[i])),
        ),
      );
      if (i < items.length - 1) {
        menuItems.add(
          DropdownMenuItem<T>(
            enabled: false,
            child: const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        );
      }
    }
    return menuItems;
  }

  // Custom heights for items and dividers
  List<double> _getCustomItemsHeights(int length) {
    List<double> heights = [];
    for (int i = 0; i < length; i++) {
      heights.add(40); // Item height
      if (i < length - 1) {
        heights.add(5); // Divider height
      }
    }
    return heights;
  }
}
