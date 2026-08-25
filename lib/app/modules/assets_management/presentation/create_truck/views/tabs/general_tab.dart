import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_truck_controller.dart';
import '../components/truck_choice_field.dart';
import '../components/truck_type_field.dart';

/// Step 1 of the truck creation flow. The fields, their validation and what
/// they submit are unchanged — they are only grouped into themed sections and
/// share the flow's step scaffold and navigation bar.
class GeneralTap extends StatefulWidget {
  const GeneralTap({super.key});

  @override
  State<GeneralTap> createState() => _GeneralTapState();
}

class _GeneralTapState extends State<GeneralTap> {
  final CreateTruckController controller = Get.find<CreateTruckController>();

  final GlobalKey<FormFieldState<String>> _makerKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _identifierKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey _typeKey = GlobalKey();

  final FocusNode _makerFocus = FocusNode();
  final FocusNode _identifierFocus = FocusNode();

  @override
  void dispose() {
    _makerFocus.dispose();
    _identifierFocus.dispose();
    super.dispose();
  }

  /// Puts the first field that failed validation back on screen (and in
  /// focus) instead of leaving the user with only a snackbar.
  void _revealFirstInvalidField() {
    final List<MapEntry<GlobalKey<FormFieldState<String>>, FocusNode>> fields =
        [
      MapEntry(_makerKey, _makerFocus),
      MapEntry(_identifierKey, _identifierFocus),
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
    final FormState? form = controller.generalFormKey.currentState;

    if (form != null && form.validate()) {
      if (controller.selectedType.value == null) {
        Get.snackbar(
          "Error",
          "Please select a type",
        );
        CreateVehicleStepScaffold.revealField(_typeKey);
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
      formKey: controller.generalFormKey,
      navigationBar: StepNavigationBar(
        nextLabel: "Next",
        onNext: _onNext,
      ),
      sections: [
        //
        // truck identity
        VehicleFormSection(
          icon: Icons.local_shipping_rounded,
          title: "Truck identity",
          children: [
            VehicleTextField(
              fieldKey: _makerKey,
              focusNode: _makerFocus,
              label: "Maker",
              hintText: "Maker",
              controller: controller.maker,
              isRequired: true,
              keyboardType: TextInputType.name,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "Maker is required";
                }
                return null;
              },
            ),
            VehicleTextField(
              fieldKey: _identifierKey,
              focusNode: _identifierFocus,
              label: "Identifier",
              hintText: "Identifier",
              controller: controller.identifier,
              isRequired: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Identifier is required";
                }
                return null;
              },
            ),
            VehicleFieldPair(
              first: VehicleTextField(
                label: "Model",
                hintText: "Model",
                controller: controller.model,
              ),
              second: VehicleTextField(
                label: "Year",
                hintText: "Year",
                keyboardType: TextInputType.number,
                controller: controller.year,
              ),
            ),
            KeyedSubtree(
              key: _typeKey,
              child: const TruckTypeField(),
            ),
          ],
        ),

        //
        // engine details
        VehicleFormSection(
          icon: Icons.precision_manufacturing_rounded,
          title: "Engine details",
          children: [
            VehicleTextField(
              label: "Engine Maker",
              hintText: "Engine Maker",
              controller: controller.engineMaker,
            ),
            VehicleFieldPair(
              first: VehicleTextField(
                label: "Engine Model",
                hintText: "Engine Model",
                controller: controller.engineModel,
              ),
              second: VehicleTextField(
                label: "Engine Year",
                hintText: "Engine Year",
                controller: controller.engineYear,
              ),
            ),
          ],
        ),

        //
        // registration and specifications
        VehicleFormSection(
          icon: Icons.assignment_rounded,
          title: "Registration and specifications",
          children: [
            VehicleTextField(
              label: "VIN",
              hintText: "VIN",
              controller: controller.vin,
            ),
            VehicleTextField(
              label: "Title Number",
              hintText: "Title Number",
              controller: controller.titleNumber,
            ),
            VehicleTextField(
              label: "Truck Color",
              hintText: "Truck Color",
              controller: controller.truckColor,
            ),
            const TruckGliderField(),
          ],
        ),
      ],
    );
  }
}
