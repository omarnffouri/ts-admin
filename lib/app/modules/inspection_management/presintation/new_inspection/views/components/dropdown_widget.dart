import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';

import '../../controllers/new_inspection_controller.dart';

/// The single yes/no question that closes the inspection. The wording, the
/// options and the value written back to the controller are unchanged — only
/// the presentation moved to the app's shared dropdown, with the question
/// wrapping above the control.
class DropDownWidget extends GetView<NewInspectionController> {
  const DropDownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Obx(
      () {
        final bool isDriver = controller.type.value == "driver";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // question (wraps over as many lines as it needs)
            Text(
              isDriver
                  ? 'Based on this examination, is driver qualified to operate commercial motor vehicle for this company?'
                  : 'CONDITION OF THE ABOVE VEHICLE IS SATISFACTORY ?',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
                height: 1.35,
              ),
            ),

            const SizedBox(height: 10),

            //
            // answer
            CustomStringDropdownWidget<String>(
              hintText: 'Select an Option',
              labelText: isDriver ? 'Qualified' : 'Satisfactory',
              items: controller.dropdownOption,
              selectedItem: controller.selectedOption.value,
              itemAsString: (String item) => item,
              isDarkMode: context.isDark,
              bottomSpacing: 0,
              onChanged: (value) {
                controller.selectedOption.value = value.toString();
              },
            ),
          ],
        );
      },
    );
  }
}
