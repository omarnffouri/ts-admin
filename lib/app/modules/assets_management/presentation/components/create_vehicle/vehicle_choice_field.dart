import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import 'vehicle_text_field.dart';

class VehicleChoiceField<T> extends StatelessWidget {
  const VehicleChoiceField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.selectedItem,
    required this.itemAsString,
    required this.onChanged,
    this.isRequired = false,
    this.fieldKey,
  });

  final GlobalKey? fieldKey;
  final String label;
  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemAsString;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String selectedLabel = selectedItem == null
        ? 'Nothing selected'
        : itemAsString(selectedItem as T);

    return Semantics(
      button: true,
      label: isRequired
          ? '$label, required. $selectedLabel'
          : '$label. $selectedLabel',
      child: Column(
        key: fieldKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VehicleFieldLabel(label: label, isRequired: isRequired),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 14,
                ),
                border: vehicleIdleInputBorder(context),
                enabledBorder: vehicleIdleInputBorder(context),
                focusedBorder: vehicleFocusedInputBorder(context),
              ),
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
              selectedItemBuilder: (context) => items
                  .map(
                    (item) => Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        itemAsString(item),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsetsDirectional.only(start: 10, end: 12),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.hintTextColor,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                elevation: 0,
                offset: const Offset(0, -6),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.hairlineBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .applyOpacity(context.isDark ? 0.45 : 0.10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
