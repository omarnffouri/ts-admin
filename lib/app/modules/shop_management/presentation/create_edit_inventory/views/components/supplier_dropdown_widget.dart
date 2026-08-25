import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../../../domain/entities/supplier_entity.dart';
import '../../../components/dropdown_loading.dart';
import '../../controllers/create_edit_inventory_controller.dart';

class SupplierDropdownWidet extends GetView<CreateEditInventoryController> {
  const SupplierDropdownWidet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingDropdownValues
          ? const DropdownLoadingWidget()
          : SearchableDropDown<SupplierEntity>(
              list: controller.supplierList,
              bottomSheetLabel: 'Select Supplier',
              searchHint: 'search by name',
              fieldLabel: 'Supplier',
              fieldHint: 'Select Supplier',
              isRequired: true,
              showOnlyLetters: true,
              getName: (p0) => p0.name ?? "",
              getImage: (p0) => p0.name ?? "",
              selectedItem: controller.selectedSupplier.value,
              dropdownSearchDecoration: SearchableDropdownDecoration.bordered,
              dropdownDecoration: SearchableDropdownDecoration.bordered,
              onItemSelected: (SupplierEntity? item) {
                if (item != null) {
                  controller.selectedSupplier.value = item;
                }
              },
              itemAsString: (item) {
                return item.name ?? "";
              },
              compareFunction: (item_1, item_2) {
                return item_1 == item_2;
              },
            ),
    );
  }
}
