import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReusableDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color primaryColor;
  final IconData icon;

  const ReusableDatePicker({
    super.key,
    required this.controller,
    this.label = 'Select Date',
    this.hint = 'Choose a date',
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.primaryColor = Colors.redAccent,
    this.icon = Icons.calendar_month,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: theme.textTheme.titleMedium,
        onTap: () async {
          final currentInitialDate = controller.text.isEmpty
              ? (initialDate ?? DateTime.now())
              : DateTime.parse(controller.text);

          final pickedDate = await showDatePicker(
            context: context,
            initialDate: currentInitialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            builder: (context, child) {
              return Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    primary: primaryColor,
                    onSurface: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 30, left: 10),
          suffixIcon: Icon(
            icon,
            size: 20,
          ),
          suffixIconColor: Get.isDarkMode ? Colors.white : Colors.black,
          labelStyle: theme.textTheme.titleMedium,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: primaryColor),
            borderRadius: BorderRadius.circular(5),
          ),
          hintStyle: const TextStyle(fontSize: 16),
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}
