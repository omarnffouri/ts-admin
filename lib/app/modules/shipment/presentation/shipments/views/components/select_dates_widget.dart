import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/widget_utils.dart';

import '../../controllers/shipments_controller.dart';

class SelectDateRangeWidget extends StatefulWidget {
  const SelectDateRangeWidget({super.key});

  @override
  State<SelectDateRangeWidget> createState() => _SelectDateRangeWidgetState();
}

class _SelectDateRangeWidgetState extends State<SelectDateRangeWidget> {
  final ShipmentsController controller = Get.find<ShipmentsController>();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: TextFormField(
              controller: controller.pickupDateController,
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
                  initialDate: controller.pickupDateController.text.isEmpty
                      ? DateTime.now()
                      : DateTime.parse(controller.pickupDateController.text),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
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
                if (pickedDate != null) {
                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  // add validation for to date should be greater than from date
                  if (controller.deliveryDateController.text.isNotEmpty &&
                      DateTime.parse(formattedDate).isAfter(
                        DateTime.parse(controller.deliveryDateController.text),
                      )) {
                    controller.deliveryDateController.clear();
                  }
                  setState(() {
                    controller.pickupDateController.text = formattedDate;
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 30, left: 10),
                suffixIcon: const Icon(
                  Icons.calendar_month,
                  size: 20,
                ),
                suffixIconColor: Get.isDarkMode ? Colors.white : Colors.black,
                labelStyle: theme.textTheme.bodyMedium,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: const TextStyle(fontSize: 13),
                labelText: 'Pickup Date',
                hintText: 'Select Pickup Date',
              ),
            ),
          ),
        ),
        addHorizontalSpace(20),
        Expanded(
          child: GestureDetector(
            child: TextFormField(
              controller: controller.deliveryDateController,
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
                  initialDate: controller.deliveryDateController.text.isEmpty
                      ? DateTime.now()
                      : DateTime.parse(
                          controller.deliveryDateController.text,
                        ),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
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
                            foregroundColor: Colors.red, // button text color
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
                  // add validation for to date should be greater than from date
                  if (controller.pickupDateController.text.isNotEmpty &&
                      DateTime.parse(controller.pickupDateController.text)
                          .isAfter(DateTime.parse(formattedDate))) {
                    Get.snackbar(
                      'Error',
                      'delivery date should be greater than pickup date',
                      backgroundColor: AppColorsLight.snakBarErrorColor,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  setState(() {
                    controller.deliveryDateController.text = formattedDate;
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 30, left: 10),
                suffixIcon: const Icon(
                  Icons.calendar_month,
                  size: 20,
                ),
                suffixIconColor: Get.isDarkMode ? Colors.white : Colors.black,
                labelStyle: theme.textTheme.bodyMedium,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: const TextStyle(fontSize: 13),
                labelText: 'Delivery Date',
                hintText: 'Select Delivery Date',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
