import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';

import '../../controllers/create_edit_service_order_controller.dart';

class CategoryDropdownWidget extends GetView<CreateEditServiceOrderController> {
  const CategoryDropdownWidget({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const DropdownLoadingWidget().paddingOnly(bottom: 10)
          : CustomStringDropdownWidget(
              labelText: 'Category',
              hintText: 'Select Category',
              isRequired: true,
              bottomSpacing: 0,
              items: const ['company', 'client'],
              selectedItem: controller.selectedCategory.value?.isEmpty ?? true
                  ? null
                  : controller.selectedCategory.value,
              itemAsString: (String item) => item,
              isEnabled: isEnabled,
              onChanged: (value) {
                controller.selectedCategory.value = value;
                controller.selectedClient.value = null;
                controller.selectedModelType.value = null;
                controller.selectedUnit.value = null;
              },
              isDarkMode: Get.isDarkMode,
            ),
    );
  }
}
