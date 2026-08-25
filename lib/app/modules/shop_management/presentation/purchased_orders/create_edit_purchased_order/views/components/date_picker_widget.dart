import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/create_edit_purchased_order_controller.dart';

class DatePickerWidget extends GetView<CreateEditPurchasedOrderController> {
  const DatePickerWidget({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: Semantics(
          button: true,
          label: 'Service date, required, select a date',
          child: TextFormField(
            controller: controller.dateController,
            readOnly: true,
            style: theme.textTheme.bodyMedium,
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
                        onPrimary: Colors.white,
                        onSurface: context.primaryTextColor,
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
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: context.fieldFillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              suffixIcon: Tooltip(
                message: 'Select a date',
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color: context.secondaryTextColor,
                  semanticLabel: 'Open the date picker',
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
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
              hintText: 'Select a date',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: context.hintTextColor,
              ),
              border: _border(context),
              enabledBorder: _border(context),
              focusedBorder: _border(context, focused: true),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context, {bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: focused
          ? BorderSide(color: context.focusedBorderColor, width: 1.4)
          : BorderSide(color: context.hairlineBorderColor),
    );
  }
}
