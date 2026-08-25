import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_date_field.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_truck_controller.dart';

/// Step 5 — the final step. The three service dates stay required and the
/// submit action still calls `createOrEditTruck()` with the same payload; the
/// button now also blocks repeat taps while the request is in flight.
class MaintenanceTap extends StatefulWidget {
  const MaintenanceTap({super.key});

  @override
  State<MaintenanceTap> createState() => _MaintenanceTapState();
}

class _MaintenanceTapState extends State<MaintenanceTap> {
  final CreateTruckController controller = Get.find<CreateTruckController>();

  final GlobalKey _nextInspectionKey = GlobalKey();
  final GlobalKey _inServiceKey = GlobalKey();
  final GlobalKey _nextServiceKey = GlobalKey();

  void _onSubmit() {
    if (controller.nextInspectionOn.text.isEmpty ||
        controller.inServiceOn.text.isEmpty ||
        controller.nextServiceOn.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
      );
      CreateVehicleStepScaffold.revealField(_firstMissingDateKey());
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    controller.createOrEditTruck();
  }

  GlobalKey _firstMissingDateKey() {
    if (controller.nextInspectionOn.text.isEmpty) {
      return _nextInspectionKey;
    }
    if (controller.inServiceOn.text.isEmpty) {
      return _inServiceKey;
    }
    return _nextServiceKey;
  }

  @override
  Widget build(BuildContext context) {
    return CreateVehicleStepScaffold(
      navigationBar: Obx(
        () => StepNavigationBar(
          nextLabel: "${controller.isUpdate ? "Update" : "Create"} Truck",
          nextIcon: Icons.check_rounded,
          isLoading: controller.isCreating.value,
          onNext: _onSubmit,
          onBack: () => controller.onBackPressed(false),
        ),
      ),
      sections: [
        //
        // service schedule
        VehicleFormSection(
          icon: Icons.build_rounded,
          title: "Service schedule",
          children: [
            VehicleDateField(
              fieldKey: _nextInspectionKey,
              controller: controller.nextInspectionOn,
              label: 'Next Inspection On',
              hint: 'Next Inspection On',
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              isRequired: true,
            ),
            VehicleDateField(
              fieldKey: _inServiceKey,
              controller: controller.inServiceOn,
              label: 'In Service On',
              hint: 'In Service On',
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              isRequired: true,
            ),
            VehicleDateField(
              fieldKey: _nextServiceKey,
              controller: controller.nextServiceOn,
              label: 'Next Service On',
              hint: 'Next Service On',
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              isRequired: true,
            ),
          ],
        ),

        //
        // weights
        VehicleFormSection(
          icon: Icons.scale_rounded,
          title: "Weights",
          children: [
            VehicleFieldPair(
              first: VehicleTextField(
                label: "Empty Weight",
                hintText: "Empty Weight",
                controller: controller.emptyWeight,
              ),
              second: VehicleTextField(
                label: "Gross Weight",
                hintText: "Gross Weight",
                controller: controller.grossWeight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
