import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_choice_field.dart';
import '../../../components/create_vehicle/vehicle_dropdown_field.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_trailer_controller.dart';

class GeneralTap extends GetView<CreateTrailerController> {
  const GeneralTap({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateVehicleStepScaffold(
      formKey: controller.generalFormKey,
      navigationBar: StepNavigationBar(
        nextLabel: 'Next',
        onNext: controller.submitGeneralStep,
      ),
      sections: [
        VehicleFormSection(
          icon: Icons.rv_hookup_rounded,
          title: 'Trailer identity',
          children: [
            VehicleTextField(
              label: 'Maker',
              hintText: 'Maker',
              controller: controller.maker,
              isRequired: true,
              keyboardType: TextInputType.name,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Maker is required' : null,
            ),
            VehicleTextField(
              label: 'Identifier',
              hintText: 'Identifier',
              controller: controller.identifier,
              isRequired: true,
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty
                  ? 'Identifier is required'
                  : null,
            ),
            VehicleFieldPair(
              first: VehicleTextField(
                label: 'Model',
                hintText: 'Model',
                controller: controller.model,
              ),
              second: VehicleTextField(
                label: 'Year',
                hintText: 'Year',
                keyboardType: TextInputType.number,
                controller: controller.year,
              ),
            ),
            Obx(
              () => VehicleDropdownField(
                items: controller.createDropdown.value?.types,
                selectedItem: controller.selectedType,
                isLoading: controller.isLoading,
                errorWhileLoading: controller.errorWhileLoadingDropdown,
                onRetry: controller.getCreateDropdown,
                bottomSheetLabel: 'Select Type',
                searchHint: 'Search by Type',
                fieldLabel: 'Type',
                emptyMessage: 'No trailer types available.',
                isRequired: true,
              ),
            ),
          ],
        ),
        VehicleFormSection(
          icon: Icons.assignment_rounded,
          title: 'Registration and ownership',
          children: [
            VehicleTextField(
              label: 'VIN',
              hintText: 'VIN',
              controller: controller.vin,
            ),
            VehicleTextField(
              label: 'Title Number',
              hintText: 'Title Number',
              controller: controller.titleNumber,
              isRequired: true,
              validator: (value) => value == null || value.isEmpty
                  ? 'Title Number is required'
                  : null,
            ),
            Obx(
              () => VehicleChoiceField<String>(
                label: 'Owned By',
                hintText: 'Select Owned By',
                items: const ['company-trailers', 'owner-trailers'],
                selectedItem: controller.selectedOwnerShip.value.isEmpty
                    ? null
                    : controller.selectedOwnerShip.value,
                itemAsString: (item) => item.toTitleCase(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedOwnerShip.value = value;
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
