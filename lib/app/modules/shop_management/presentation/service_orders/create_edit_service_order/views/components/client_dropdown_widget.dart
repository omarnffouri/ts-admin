import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../../../../domain/entities/service_dropdown_entity.dart';
import '../../../../components/dropdown_loading.dart';
import '../../controllers/create_edit_service_order_controller.dart';

class ClientDropdownWidet extends GetView<CreateEditServiceOrderController> {
  const ClientDropdownWidet({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: controller.isLoading.value
                ? const DropdownLoadingWidget()
                : SearchableDropDown<ClientsItemEntity>(
                    list: controller.getClientlist(),
                    isEnable: isEnabled,
                    bottomSheetLabel: 'Select Client',
                    searchHint: 'search by name',
                    fieldLabel: 'Client',
                    fieldHint: 'Select Client',
                    isRequired: true,
                    showOnlyLetters: true,
                    getName: (p0) => p0.companyName ?? "",
                    getImage: (p0) => p0.companyName ?? "",
                    selectedItem: controller.selectedClient.value,
                    dropdownSearchDecoration:
                        SearchableDropdownDecoration.bordered,
                    dropdownDecoration: SearchableDropdownDecoration.bordered,
                    onItemSelected: (ClientsItemEntity? item) {
                      if (item != null) {
                        controller.selectedClient.value = item;
                        controller.selectedModelType.value = null;
                        controller.getUnitlist();
                      }
                    },
                    itemAsString: (item) {
                      return "${item.companyName}";
                    },
                    compareFunction: (item_1, item_2) {
                      return item_1 == item_2;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
