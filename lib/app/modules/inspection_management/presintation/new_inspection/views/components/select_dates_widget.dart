import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../components/inspection_form/inspection_text_field.dart';
import '../../controllers/new_inspection_controller.dart';

/// Inspection date. Read-only by design — the value can only be produced by
/// the picker, whose initial date, allowed range, format and follow-up
/// (revealing the time field) are unchanged.
class SelectDateWidget extends GetView<NewInspectionController> {
  const SelectDateWidget({super.key, this.fieldKey});

  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return InspectionTextField(
      fieldKey: fieldKey,
      controller: controller.dateController,
      label: 'Date',
      hint: 'Select Date',
      isRequired: true,
      readOnly: true,
      semanticsLabel: 'Inspection date, required, opens a date picker',
      suffixIcon: Icon(
        Icons.calendar_month_rounded,
        size: 20,
        color: context.secondaryTextColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a Date';
        }
        return null;
      },
      onTap: () => _pickDate(context),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final Color accent = context.brandColor;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: accent,
              onPrimary: Colors.white,
              onSurface: context.primaryTextColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: accent),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.dateController.text = formattedDate;
      controller.showTimeWidget.value = true;
    }
  }
}
