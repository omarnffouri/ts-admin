import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_date_field.dart';
import '../../../components/create_vehicle/vehicle_dropdown_field.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_trailer_controller.dart';

class OwnershipTap extends GetView<CreateTrailerController> {
  const OwnershipTap({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateVehicleStepScaffold(
      formKey: controller.ownerShipFormKey,
      navigationBar: StepNavigationBar(
        nextLabel: 'Next',
        onNext: controller.submitOwnershipStep,
        onBack: () => controller.onBackPressed(false),
      ),
      sections: [
        VehicleFormSection(
          icon: Icons.confirmation_number_rounded,
          title: 'Plate details',
          children: [
            VehicleTextField(
              label: 'License Plate Number',
              hintText: 'License Plate Number',
              controller: controller.licensePlateNumber,
              isRequired: true,
              keyboardType: TextInputType.name,
              validator: (value) => value == null || value.isEmpty
                  ? 'License Plate Number is required'
                  : null,
            ),
            Obx(
              () => VehicleDropdownField(
                items: controller.createDropdown.value?.states,
                selectedItem: controller.selectedState,
                isLoading: controller.isLoading,
                errorWhileLoading: controller.errorWhileLoadingDropdown,
                onRetry: controller.getCreateDropdown,
                bottomSheetLabel: 'Select License Plate State',
                searchHint: 'Search by State',
                fieldLabel: 'License Plate State',
                emptyMessage: 'No states available.',
                isRequired: true,
              ),
            ),
          ],
        ),
        VehicleFormSection(
          icon: Icons.assured_workload_rounded,
          title: 'Ownership',
          children: [
            VehicleTextField(
              label: 'Financed By',
              hintText: 'Enter Financed By',
              controller: controller.financedBy,
              keyboardType: TextInputType.name,
            ),
            VehicleTextField(
              label: 'Owned By',
              hintText: 'Enter Owned By',
              controller: controller.ownedBy,
              isRequired: true,
              keyboardType: TextInputType.name,
            ),
          ],
        ),
        VehicleFormSection(
          icon: Icons.payments_rounded,
          title: 'Purchase and sale',
          children: [
            VehicleFieldPair(
              first: VehicleDateField(
                controller: controller.purchaseDate,
                label: 'Purchase Date',
                hint: 'Purchase Date',
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                isRequired: true,
              ),
              second: VehicleTextField(
                label: 'Purchase Price',
                hintText: 'Enter purchase price',
                controller: controller.purchasePrice,
                isRequired: true,
                keyboardType: TextInputType.number,
              ),
            ),
            VehicleFieldPair(
              first: VehicleDateField(
                controller: controller.saleDate,
                label: 'Sale Date',
                hint: 'Sale Date',
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ),
              second: VehicleTextField(
                label: 'Sale Price',
                hintText: 'Enter sale price',
                controller: controller.salePrice,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
