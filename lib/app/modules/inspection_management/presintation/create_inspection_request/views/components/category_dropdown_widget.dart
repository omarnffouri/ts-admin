import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';

import '../../controllers/create_inspection_request_controller.dart';

class CategoryDropdownWidget
    extends GetView<CreateInspectionRequestController> {
  const CategoryDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Matches the shared SearchableDropDown "bordered" field: rounded hairline
    // idle border and a brand-colored focus ring.
    final OutlineInputBorder idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: context.hairlineBorderColor),
    );
    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: context.focusedBorderColor, width: 1.4),
    );

    return Obx(
      () => controller.isLoading.value
          ? const DropdownLoadingWidget()
          : DropdownButtonFormField<String>(
              hint: Text(
                "Select Category",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.hintTextColor,
                ),
              ),
              dropdownColor: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: context.secondaryTextColor,
              ),
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                label: const Text("Category"),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: context.secondaryTextColor,
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                border: idleBorder,
                enabledBorder: idleBorder,
                focusedBorder: focusedBorder,
              ),
              initialValue: controller.selectedCategory.value?.isEmpty ?? true
                  ? null
                  : controller.selectedCategory.value,
              onChanged: (String? newValue) {
                controller.selectedCategory.value = newValue;
                controller.selectedUnit.value = null;
              },
              items: controller.dropdownCategory
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.capitalizeFirst ?? ''),
                );
              }).toList(),
            ),
    );
  }
}
