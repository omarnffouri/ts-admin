import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_choice_field.dart';
import '../../../components/create_vehicle/vehicle_date_field.dart';
import '../../../components/create_vehicle/vehicle_dropdown_field.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_truck_controller.dart';

/// Step 3 of the truck creation flow — ownership. The "Owned By" codes
/// (`comp` / `cont`) and every other value are stored exactly as before; only
/// the layout changed.
class OwnershipTap extends StatefulWidget {
  const OwnershipTap({super.key});

  @override
  State<OwnershipTap> createState() => _OwnershipTapState();
}

class _OwnershipTapState extends State<OwnershipTap> {
  final CreateTruckController controller = Get.find<CreateTruckController>();

  final GlobalKey _ownedByKey = GlobalKey();

  static const List<String> _ownershipTypes = ["comp", "cont"];

  String getOwnershipType(String value) {
    switch (value) {
      case "comp":
        return "Company";
      case "cont":
        return "Contract";
      default:
        return "";
    }
  }

  void _onNext() {
    if (controller.selectedOwnerShip.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select Owned By",
      );
      CreateVehicleStepScaffold.revealField(_ownedByKey);
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    controller.vehicleCreationState.value++;
  }

  @override
  Widget build(BuildContext context) {
    return CreateVehicleStepScaffold(
      navigationBar: StepNavigationBar(
        nextLabel: "Next",
        onNext: _onNext,
        onBack: () => controller.onBackPressed(false),
      ),
      sections: [
        //
        // ownership
        VehicleFormSection(
          icon: Icons.assured_workload_rounded,
          title: "Ownership",
          children: [
            Obx(
              () => VehicleChoiceField<String>(
                fieldKey: _ownedByKey,
                label: "Owned By",
                hintText: "Select Owned By",
                items: _ownershipTypes,
                selectedItem: controller.selectedOwnerShip.value.isEmpty
                    ? null
                    : controller.selectedOwnerShip.value,
                itemAsString: getOwnershipType,
                isRequired: true,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedOwnerShip.value = value;
                  }
                },
              ),
            ),
            Obx(
              () => VehicleDropdownField(
                items: controller.createDropdown.value?.lessors,
                selectedItem: controller.selectedLessor,
                isLoading: controller.isLoading,
                errorWhileLoading: controller.errorWhileLoadingDropdown,
                onRetry: controller.getCreateDropdown,
                bottomSheetLabel: "Select Lessor",
                searchHint: "Search by name",
                fieldLabel: "Lessor",
                emptyMessage: "No lessors available.",
              ),
            ),
            VehicleTextField(
              label: "Financed By",
              hintText: "Enter Financed By",
              controller: controller.financedBy,
              keyboardType: TextInputType.name,
            ),
          ],
        ),

        //
        // owner contact
        VehicleFormSection(
          icon: Icons.person_rounded,
          title: "Owner contact",
          children: [
            VehicleTextField(
              label: "Owner Name",
              hintText: "Enter Owner Name",
              controller: controller.ownerName,
              keyboardType: TextInputType.datetime,
            ),
            VehicleTextField(
              label: "Owner phone",
              hintText: "Enter Owner phone",
              controller: controller.ownerPhone,
              keyboardType: TextInputType.text,
            ),
          ],
        ),

        //
        // purchase and sale
        VehicleFormSection(
          icon: Icons.payments_rounded,
          title: "Purchase and sale",
          children: [
            VehicleFieldPair(
              first: VehicleDateField(
                controller: controller.purchaseDate,
                label: 'Purchase Date',
                hint: 'Purchase Date',
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ),
              second: VehicleTextField(
                label: "Purchase Price",
                hintText: "Enter purchase price",
                controller: controller.purchasePrice,
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
                label: "Sale Price",
                hintText: "Enter purchase price",
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
