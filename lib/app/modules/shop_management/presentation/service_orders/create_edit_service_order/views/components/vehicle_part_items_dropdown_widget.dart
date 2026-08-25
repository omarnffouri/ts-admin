import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../../../../domain/entities/service_details.dart';
import '../../../../../domain/entities/shop_inventory_entity.dart';
import '../../../../components/dropdown_loading.dart';
import '../../controllers/create_edit_service_order_controller.dart';

class VehiclePartItemsDropdownWidget
    extends GetView<CreateEditServiceOrderController> {
  const VehiclePartItemsDropdownWidget({
    super.key,
    required this.part,
    required this.isEnabled,
  });
  final VehiclePart part;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => controller.isLoading.value
              ? const DropdownLoadingWidget()
              : SearchableDropDown<ShopInventoryEntity>(
                  list: controller.dropdownInventory,
                  bottomSheetLabel: 'Select Item Part',
                  searchHint: 'search by name',
                  fieldLabel: 'Item name',
                  fieldHint: 'Select Item Part',
                  isRequired: true,
                  showOnlyLetters: true,
                  getName: (p0) => p0.itemName ?? "",
                  getImage: (p0) => p0.itemName ?? "",
                  isEnable: isEnabled,
                  selectedItem: part.selectedInventory.value.id == null
                      ? null
                      : part.selectedInventory.value,
                  dropdownSearchDecoration:
                      SearchableDropdownDecoration.bordered,
                  dropdownDecoration: SearchableDropdownDecoration.bordered,
                  onItemSelected: (ShopInventoryEntity? item) {
                    if (item != null) {
                      debugPrint("Selected Item: ${item.itemName}");
                      part.selectedInventory.value = item;
                      part.updatePartsToBePurchased();
                    }
                  },
                  itemAsString: (item) {
                    return "${item.itemName}";
                  },
                  compareFunction: (item_1, item_2) {
                    return item_1 == item_2;
                  },
                ),
        ),
      ],
    );
  }
}
