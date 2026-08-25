import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_date_field.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_truck_controller.dart';

/// Step 4 of the truck creation flow — lease. Every field here stays optional,
/// exactly as before, so "Next" always advances.
class LeaseTap extends GetView<CreateTruckController> {
  const LeaseTap({super.key});

  void _onNext() {
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
        // lease agreement
        VehicleFormSection(
          icon: Icons.description_rounded,
          title: "Lease agreement",
          children: [
            VehicleTextField(
              label: "Leasing Company",
              hintText: "Leasing Company",
              controller: controller.leaseCompany,
            ),
            VehicleTextField(
              label: "Lease Reference",
              hintText: "Lease Reference",
              controller: controller.leaseReference,
            ),
            VehicleFieldPair(
              first: VehicleDateField(
                controller: controller.leaseEndDate,
                label: 'Lease End Date',
                hint: 'Lease End Date',
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              ),
              second: VehicleDateField(
                controller: controller.leaseEarlyWalkDate,
                label: 'Lease Early Walk Date',
                hint: 'Lease Early Walk Date',
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              ),
            ),
          ],
        ),

        //
        // lease terms
        VehicleFormSection(
          icon: Icons.payments_rounded,
          title: "Lease terms",
          children: [
            VehicleTextField(
              label: "Lease Monthly Payment",
              hintText: "Lease Monthly Payment",
              controller: controller.leaseMonthlyPayment,
            ),
            VehicleTextField(
              label: "Lease Maintenance CPM",
              hintText: "Lease Maintenance CPM",
              controller: controller.leaseMaintenanceCPM,
            ),
            VehicleTextField(
              label: "Lease Mileage Yearly Allowance",
              hintText: "Lease Mileage Yearly Allowance",
              controller: controller.leaseMileageYearlyAllowance,
            ),
          ],
        ),
      ],
    );
  }
}
