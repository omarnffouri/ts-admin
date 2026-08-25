import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_date_field.dart';
import '../../../components/create_vehicle/vehicle_dropdown_field.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_truck_controller.dart';

/// Step 2 of the truck creation flow — licence plate details. Same fields,
/// same required rules and same "Next" gate as before; only the presentation
/// and the shared navigation bar are new.
class PlateTap extends StatefulWidget {
  const PlateTap({super.key});

  @override
  State<PlateTap> createState() => _PlateTapState();
}

class _PlateTapState extends State<PlateTap> {
  final CreateTruckController controller = Get.find<CreateTruckController>();

  final GlobalKey<FormFieldState<String>> _plateNumberKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _ownedByKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey _stateKey = GlobalKey();
  final GlobalKey _tagsExpireKey = GlobalKey();

  final FocusNode _plateNumberFocus = FocusNode();
  final FocusNode _ownedByFocus = FocusNode();

  @override
  void dispose() {
    _plateNumberFocus.dispose();
    _ownedByFocus.dispose();
    super.dispose();
  }

  void _revealFirstInvalidField() {
    final List<MapEntry<GlobalKey<FormFieldState<String>>, FocusNode>> fields =
        [
      MapEntry(_plateNumberKey, _plateNumberFocus),
      MapEntry(_ownedByKey, _ownedByFocus),
    ];

    for (final field in fields) {
      if (field.key.currentState?.hasError ?? false) {
        CreateVehicleStepScaffold.revealField(field.key);
        field.value.requestFocus();
        return;
      }
    }
  }

  void _onNext() {
    final FormState? form = controller.plateFormKey.currentState;

    if (form != null && form.validate()) {
      if (controller.tagsExpireOn.text.isEmpty ||
          controller.selectedState.value == null) {
        Get.snackbar(
          "Error",
          "Please fill all required fields",
        );
        CreateVehicleStepScaffold.revealField(
          controller.selectedState.value == null ? _stateKey : _tagsExpireKey,
        );
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      controller.vehicleCreationState.value++;
    } else {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
      );
      _revealFirstInvalidField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreateVehicleStepScaffold(
      formKey: controller.plateFormKey,
      navigationBar: StepNavigationBar(
        nextLabel: "Next",
        onNext: _onNext,
        onBack: () => controller.onBackPressed(false),
      ),
      sections: [
        //
        // plate details
        VehicleFormSection(
          icon: Icons.confirmation_number_rounded,
          title: "Plate details",
          children: [
            VehicleTextField(
              fieldKey: _plateNumberKey,
              focusNode: _plateNumberFocus,
              label: "License Plate Number",
              hintText: "License Plate Number",
              controller: controller.licensePlateNumber,
              isRequired: true,
              keyboardType: TextInputType.name,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "License Plate Number is required";
                }
                return null;
              },
            ),
            KeyedSubtree(
              key: _stateKey,
              child: Obx(
                () => VehicleDropdownField(
                  items: controller.createDropdown.value?.states,
                  selectedItem: controller.selectedState,
                  isLoading: controller.isLoading,
                  errorWhileLoading: controller.errorWhileLoadingDropdown,
                  onRetry: controller.getCreateDropdown,
                  bottomSheetLabel: "Select License Plate State",
                  searchHint: "Search by State",
                  fieldLabel: "License Plate State",
                  emptyMessage: "No states available.",
                  isRequired: true,
                ),
              ),
            ),
          ],
        ),

        //
        // tags and ownership
        VehicleFormSection(
          icon: Icons.event_available_rounded,
          title: "Tags and ownership",
          children: [
            VehicleDateField(
              fieldKey: _tagsExpireKey,
              controller: controller.tagsExpireOn,
              label: 'Tags Expire On',
              hint: 'Tags Expire On',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              isRequired: true,
            ),
            VehicleTextField(
              fieldKey: _ownedByKey,
              focusNode: _ownedByFocus,
              label: "Plates Owned By",
              hintText: "Enter Owner",
              controller: controller.platesOwnedBy,
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Plates Owned By is required";
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
