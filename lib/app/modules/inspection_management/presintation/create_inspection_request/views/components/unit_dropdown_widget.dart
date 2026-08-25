import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../../../domain/entities/inspection_dropdown_entity.dart';
import '../../controllers/create_inspection_request_controller.dart';

class UnitDropdownWidet extends GetView<CreateInspectionRequestController> {
  const UnitDropdownWidet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: controller.isLoading.value
                  ? const DropdownLoadingWidget()
                  : SearchableDropDown<ItemEntity>(
                      list: controller.getUnitlist(),
                      getName: (p0) =>
                          controller.selectedCategory.value == "driver"
                              ? p0.driverName ?? ""
                              : p0.identifier.toString(),
                      getImage: controller.selectedCategory.value == "driver"
                          ? (p0) => p0.driverName ?? ""
                          : null,
                      bottomSheetLabel:
                          controller.selectedCategory.value == "driver"
                              ? "Select Driver"
                              : 'Select Unit',
                      searchHint:
                          'search by ${getSearchHint(controller.selectedCategory.value!)}',
                      fieldLabel: controller.selectedCategory.value == "driver"
                          ? "Driver"
                          : 'Unit',
                      fieldHint: controller.selectedCategory.value == "driver"
                          ? "Select Driver"
                          : 'Select Unit',
                      isRequired: true,
                      selectedItem: controller.selectedUnit.value,
                      dropdownSearchDecoration:
                          SearchableDropdownDecoration.bordered,
                      dropdownDecoration: SearchableDropdownDecoration.bordered,
                      onItemSelected: (ItemEntity? item) {
                        if (item != null) {
                          controller.selectedUnit.value = item;
                        }
                      },
                      itemAsString: (item) {
                        return controller.selectedCategory.value == "driver"
                            ? "${item.driverName}"
                            : "${item.identifier}";
                      },
                      compareFunction: (item_1, item_2) {
                        return item_1 == item_2;
                      },
                    ),
            ),
          ],
        ));
  }
}

String getSearchHint(String fieldHint) {
  switch (fieldHint) {
    case "driver":
      return 'driver name';
  }
  return 'identifier';
}
