import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../domain/entities/device_type_entity.dart';

class DevicesDropdownWidet extends StatelessWidget {
  const DevicesDropdownWidet({
    super.key,
    required this.isDeviceTypesLoading,
    required this.deviceTypes,
    required this.selectedDeviceType,
    required this.onDeviecSelected,
  });
  final RxBool isDeviceTypesLoading;
  final RxList<DeviceTypeEntity> deviceTypes;
  final Rxn<DeviceTypeEntity> selectedDeviceType;
  final void Function(DeviceTypeEntity?) onDeviecSelected;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: isDeviceTypesLoading.value
                ? const DropdownLoadingWidget()
                : SearchableDropDown<DeviceTypeEntity>(
                    list: deviceTypes,
                    bottomSheetLabel: 'Select Device Type',
                    searchHint: 'search by type',
                    fieldLabel: 'Device Type',
                    fieldHint: 'Select Device Type',
                    isRequired: true,
                    showOnlyLetters: true,
                    getName: (p0) => p0.title ?? "",
                    getImage: (p0) => p0.title ?? "",
                    selectedItem: selectedDeviceType.value,
                    dropdownSearchDecoration:
                        SearchableDropdownDecoration.bordered,
                    dropdownDecoration: SearchableDropdownDecoration.bordered,
                    onItemSelected: onDeviecSelected,
                    itemAsString: (item) {
                      return "${item.title}";
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
