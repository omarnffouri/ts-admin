import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../domain/entities/selected_device_entity.dart';

class SelectedDeviceDropdownWidet extends StatelessWidget {
  const SelectedDeviceDropdownWidet({
    super.key,
    required this.isSerialNumbersLoading,
    required this.serialNumbers,
    required this.selectedSerialNumber,
    required this.onSerialSelected,
  });
  final RxBool isSerialNumbersLoading;
  final RxList<SelectedDeviceEntity> serialNumbers;
  final Rxn<SelectedDeviceEntity> selectedSerialNumber;
  final void Function(SelectedDeviceEntity?) onSerialSelected;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: isSerialNumbersLoading.value
                ? const DropdownLoadingWidget()
                : SearchableDropDown<SelectedDeviceEntity>(
                    list: serialNumbers,
                    bottomSheetLabel: 'Select Serial Number',
                    searchHint: 'search by serial number',
                    fieldLabel: 'Serial Number',
                    fieldHint: 'Select Serial Number',
                    isRequired: true,
                    showOnlyLetters: true,
                    getName: (p0) => p0.serialNumber ?? "",
                    getImage: (p0) => p0.serialNumber ?? "",
                    selectedItem: selectedSerialNumber.value,
                    dropdownSearchDecoration:
                        SearchableDropdownDecoration.bordered,
                    dropdownDecoration: SearchableDropdownDecoration.bordered,
                    onItemSelected: onSerialSelected,
                    itemAsString: (item) {
                      return "${item.serialNumber}";
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
