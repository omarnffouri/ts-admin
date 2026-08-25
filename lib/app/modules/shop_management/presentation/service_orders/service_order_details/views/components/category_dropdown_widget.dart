import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';

import '../../controllers/service_order_details_controller.dart';

class CategoryDropdownWidget extends StatefulWidget {
  const CategoryDropdownWidget({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  State<CategoryDropdownWidget> createState() => _CategoryDropdownWidgetState();
}

class _CategoryDropdownWidgetState extends State<CategoryDropdownWidget> {
  final controller = Get.find<ServiceOrderDetailsController>();

  @override
  Widget build(BuildContext context) {
    final paymentMethod =
        widget.isEnabled ? ['Bank Transfer', 'Payroll'] : ['Bank Transfer'];
    return Obx(
      () => CustomStringDropdownWidget(
        hintText: 'Select Your Payment Method',
        items: paymentMethod,
        selectedItem: controller.selectedCategory.value?.isEmpty ?? true
            ? null
            : controller.selectedCategory.value,
        itemAsString: (String item) => item,
        onChanged: (value) {
          controller.selectedCategory.value = value;
        },
        isDarkMode: Get.isDarkMode,
      ),
    );
  }
}
