import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../../../../domain/entities/service_dropdown_entity.dart';
import '../../../../components/dropdown_loading.dart';
import '../../controllers/create_edit_service_order_controller.dart';

class UnitDropdownWidet extends GetView<CreateEditServiceOrderController> {
  const UnitDropdownWidet({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: controller.isUnitLoading.value ||
                      controller.isLoading.value
                  ? const DropdownLoadingWidget()
                  : SearchableDropDown<ItemEntity>(
                      list: controller.unitList,
                      bottomSheetLabel: 'Select Unit',
                      searchHint: 'search by identifier',
                      fieldLabel: 'Unit',
                      fieldHint: 'Select Unit',
                      isRequired: true,
                      isEnable: isEnabled,
                      getName: (p0) => p0.identifier ?? "",
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
                        return "${item.identifier}";
                      },
                      compareFunction: (item_1, item_2) {
                        return item_1 == item_2;
                      },
                    ),
            ),
            // todo implement add unit (vehicel info)
            Visibility(
              // visible: controller.selectedCategory.value?.name == "client",
              visible: false,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () {
                    //todo implement add unit
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.add,
                        size: 25,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                      Text(
                        "Add",
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
