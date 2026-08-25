import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';

class DateHelper {
  static Future<DateTime?> pickDate(
      DateTime firstDate, DateTime lastDate, DateTime initialDate) async {
    return await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Get.theme.copyWith(
            colorScheme: Get.theme.colorScheme.copyWith(
              primary: Colors.redAccent,
              onSurface: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor:
                  Get.isDarkMode ? AppColorsDark.mainColorDark : null,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          // child: child!,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: child!,
          ),
        );
      },
    );
  }
}
