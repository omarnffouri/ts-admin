import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../components/inspection_form/inspection_text_field.dart';
import '../../controllers/new_inspection_controller.dart';

/// Inspection time. Appears once a date has been picked (existing behaviour)
/// and still submits the same `HH:mm` value.
class SelectTimeWidget extends GetView<NewInspectionController> {
  const SelectTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InspectionTextField(
      controller: controller.timeController,
      label: 'Time',
      hint: 'Select Time',
      isRequired: true,
      readOnly: true,
      semanticsLabel: 'Inspection time, required, opens a time picker',
      suffixIcon: Icon(
        Icons.schedule_rounded,
        size: 20,
        color: context.secondaryTextColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a time';
        }
        return null;
      },
      onTap: () => _pickTime(context),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final Color accent = context.brandColor;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: accent,
              onPrimary: Colors.white,
              onSurface: context.primaryTextColor,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: context.surfaceColor,
              dayPeriodColor: accent,
              hourMinuteTextStyle: const TextStyle(fontSize: 45),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: accent),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: child!,
          ),
        );
      },
    );

    if (time == null) {
      return;
    }

    // Only the hour and minute reach the payload; the day is carried over from
    // the already-picked date, exactly as before.
    final DateTime baseDate =
        DateTime.tryParse(controller.dateController.text) ?? DateTime.now();

    controller.timeController.text = DateFormat('HH:mm').format(
      DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        time.hour,
        time.minute,
      ),
    );
  }
}
