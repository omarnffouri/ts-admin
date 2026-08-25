import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/custom_string_dropdown_widget.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';

import '../../controllers/create_edit_service_order_controller.dart';

class ModelTypeDropdownWidget
    extends GetView<CreateEditServiceOrderController> {
  const ModelTypeDropdownWidget({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const DropdownLoadingWidget().paddingOnly(bottom: 10)
          : CustomStringDropdownWidget(
              labelText: 'Model Type',
              hintText: 'Select Model Type',
              isRequired: true,
              bottomSpacing: 0,
              items: const ['truck', 'trailer'],
              selectedItem: controller.selectedModelType.value?.isEmpty ?? true
                  ? null
                  : controller.selectedModelType.value,
              itemAsString: (String item) => item,
              isEnabled: isEnabled,
              onChanged: (value) {
                controller.selectedModelType.value = value;
                controller.selectedUnit.value = null;
                controller.getUnitlist();
              },
              isDarkMode: Get.isDarkMode,
            ),
    );
  }
}
