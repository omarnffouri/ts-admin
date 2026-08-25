import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/create_truck_controller.dart';
import '../../../components/create_vehicle/vehicle_dropdown_field.dart';

/// The required "Type" selection of the General step. It reads the same
/// `createDropdown.types` list, writes to the same `selectedType` observable
/// and reuses the same loading/error/retry flow as before — only the
/// presentation changed.
class TruckTypeField extends GetView<CreateTruckController> {
  const TruckTypeField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VehicleDropdownField(
        items: controller.createDropdown.value?.types,
        selectedItem: controller.selectedType,
        isLoading: controller.isLoading,
        errorWhileLoading: controller.errorWhileLoadingDropdown,
        onRetry: controller.getCreateDropdown,
        bottomSheetLabel: 'Select Type',
        searchHint: 'Search by Type',
        fieldLabel: 'Type',
        emptyMessage: 'No truck types available.',
        isRequired: true,
      ),
    );
  }
}
