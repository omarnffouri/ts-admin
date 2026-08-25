import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/create_edit_service_order_controller.dart';

class CompletionDatePickerWidget
    extends GetView<CreateEditServiceOrderController> {
  const CompletionDatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      child: TextFormField(
        controller: controller.completionDateController,
        readOnly: true,
        style: theme.textTheme.titleMedium,
        onTap: () async {
          final orderDate = controller.dateController.text.isEmpty
              ? DateTime.now()
              : DateTime.parse(controller.dateController.text);

          final completionDate =
              controller.completionDateController.text.isEmpty
                  ? DateTime.now()
                  : DateTime.parse(controller.completionDateController.text);

          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate:
                completionDate.isBefore(orderDate) ? null : completionDate,
            firstDate: orderDate,
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
            final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.completionDateController.text = formattedDate;
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
          labelText: 'Completion Date',
          hintText: 'Select a date',
        ),
      ),
    );
  }
}
