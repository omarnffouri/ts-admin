import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import 'vehicle_text_field.dart';

class VehicleDateField extends StatelessWidget {
  const VehicleDateField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.firstDate,
    required this.lastDate,
    this.fieldKey,
    this.initialDate,
    this.isRequired = false,
    this.icon = Icons.calendar_month_rounded,
  });

  final GlobalKey? fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final bool isRequired;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = context.brandColor;

    return Semantics(
      button: true,
      label: isRequired
          ? '$label, required, select a date'
          : '$label, select a date',
      child: Column(
        key: fieldKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VehicleFieldLabel(label: label, isRequired: isRequired),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: true,
            style: theme.textTheme.bodyMedium,
            onTap: () => _pickDate(context, accent),
            decoration: InputDecoration(
              filled: true,
              fillColor: context.fieldFillColor,
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(color: context.hintTextColor, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: vehicleIdleInputBorder(context),
              enabledBorder: vehicleIdleInputBorder(context),
              focusedBorder: vehicleFocusedInputBorder(context),
              suffixIcon: Icon(
                icon,
                size: 20,
                color: context.secondaryTextColor,
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, Color accent) async {
    final ThemeData theme = Theme.of(context);

    final DateTime currentInitialDate = controller.text.isEmpty
        ? (initialDate ?? DateTime.now())
        : DateTime.parse(controller.text);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
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
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
}
