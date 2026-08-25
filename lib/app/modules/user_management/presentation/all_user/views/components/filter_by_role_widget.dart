import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../controllers/all_user_controller.dart';

class FilterByRoleWidget extends GetView<AllUserController> {
  const FilterByRoleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color idleBorderColor = isDark
        ? Colors.white.applyOpacity(0.08)
        : Colors.black.applyOpacity(0.06);

    final idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: idleBorderColor),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: isDark ? Colors.white.applyOpacity(0.3) : theme.primaryColor,
        width: 1.4,
      ),
    );

    final decoration = InputDecoration(
      filled: true,
      fillColor: theme.cardColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      border: idleBorder,
      enabledBorder: idleBorder,
      focusedBorder: focusedBorder,
    );

    final hint = Text(
      'Filter By Role',
      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
    );

    final iconStyle = IconStyleData(
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDark ? Colors.white70 : Colors.black45,
      ),
      iconSize: 22,
    );

    final dropdownStyle = DropdownStyleData(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      offset: const Offset(0, -4),
    );

    return Obx(
      () => controller.isLoadingRoles.value
          ? Shimmer.fromColors(
              baseColor: isDark ? Colors.white10 : Colors.black12,
              highlightColor: isDark ? Colors.white24 : Colors.white30,
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: decoration,
                hint: hint,
                items: const [],
                buttonStyleData: const ButtonStyleData(
                  height: 24,
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: iconStyle,
                dropdownStyleData: dropdownStyle,
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            )
          : DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: decoration,
              hint: hint,
              value: controller.selectedRole.value,
              items: controller.roleOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item.formatStatus(),
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select role';
                }
                return null;
              },
              onChanged: controller.handleStatusChange,
              buttonStyleData: const ButtonStyleData(
                height: 32,
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: iconStyle,
              dropdownStyleData: dropdownStyle,
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
    );
  }
}
