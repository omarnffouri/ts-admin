import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

import '../../controllers/new_leave_request_controller.dart';

class DateRangePickerWidget extends GetView<NewLeaveRequestController> {
  const DateRangePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final borderColor =
        Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: TextFormField(
              controller: controller.dateRangeController,
              readOnly: true,
              style: theme.textTheme.titleMedium,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select the Date';
                }
                return null;
              },
              onTap: () async {
                controller.selectedDateRange = await showDateRangePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  firstDate: controller.isSickLeave
                      ? DateTime.now().subtract(const Duration(days: 365))
                      : DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: theme.colorScheme.copyWith(
                          primary: Colors.redAccent,
                          onSurface:
                              Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (controller.selectedDateRange != null) {
                  final formattedStartDate = DateFormat('yyyy-MM-dd')
                      .format(controller.selectedDateRange!.start);

                  final formattedEndDate = DateFormat('yyyy-MM-dd')
                      .format(controller.selectedDateRange!.end);

                  controller.fromDateController.text = formattedStartDate;
                  controller.toDateController.text = formattedEndDate;
                  controller.dateRangeController.text =
                      '$formattedStartDate - $formattedEndDate';
                  controller.checkEligibility();
                }
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                suffixIcon: Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color:
                      Get.isDarkMode ? Colors.white : AppColorsLight.mainColor,
                ),
                labelStyle: theme.textTheme.titleSmall,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1.4,
                    color: AppColorsLight.mainColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: const TextStyle(fontSize: 15),
                labelText: 'Date Range *',
                hintText: 'Select date range',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
