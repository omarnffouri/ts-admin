import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/create_edit_service_order_controller.dart';

class DatePickerWidget extends GetView<CreateEditServiceOrderController> {
  const DatePickerWidget({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: GestureDetector(
          child: TextFormField(
            controller: controller.dateController,
            readOnly: true,
            style: theme.textTheme.titleMedium,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a Date';
              }
              return null;
            },
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: controller.dateController.text.isEmpty
                    ? DateTime.now()
                    : DateTime.parse(controller.dateController.text),
                firstDate: controller.dateController.text.isEmpty
                    ? DateTime.now()
                    : DateTime.parse(controller.dateController.text)
                            .isAfter(DateTime.now())
                        ? DateTime.now()
                        : DateTime.parse(controller.dateController.text),
                lastDate: DateTime(2040),
                builder: (context, child) {
                  return Theme(
                    data: theme.copyWith(
                      colorScheme: theme.colorScheme.copyWith(
                        primary: context.brandColor,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: context.brandColor,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                controller.dateController.text = formattedDate;

                final completionDate = controller
                        .completionDateController.text.isEmpty
                    ? DateTime.now()
                    : DateTime.parse(controller.completionDateController.text);

                //
                //
                // clearing completion date if order date is
                // after the previously selected completion date
                if (completionDate.isBefore(pickedDate)) {
                  controller.completionDateController.text = "";
                }
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: context.fieldFillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              suffixIcon: Icon(
                Icons.calendar_month,
                size: 20,
                color: context.secondaryTextColor,
              ),
              label: Text.rich(
                TextSpan(
                  text: 'Service Date',
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: context.brandColor),
                    ),
                  ],
                ),
              ),
              labelStyle: theme.textTheme.titleSmall,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: context.hairlineBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: context.hairlineBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.4,
                  color: context.focusedBorderColor,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: context.hintTextColor,
              ),
              hintText: 'Select a date',
            ),
          ),
        ),
      ),
    );
  }
}
