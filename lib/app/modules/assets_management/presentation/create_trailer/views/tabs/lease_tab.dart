import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/create_vehicle/create_vehicle_step_scaffold.dart';
import '../../../components/create_vehicle/step_navigation_bar.dart';
import '../../../components/create_vehicle/vehicle_date_field.dart';
import '../../../components/create_vehicle/vehicle_form_section.dart';
import '../../../components/create_vehicle/vehicle_text_field.dart';
import '../../controllers/create_trailer_controller.dart';

class LeaseTap extends GetView<CreateTrailerController> {
  const LeaseTap({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateVehicleStepScaffold(
      navigationBar: Obx(
        () => StepNavigationBar(
          nextLabel: '${controller.isUpdate ? 'Update' : 'Create'} Trailer',
          nextIcon: Icons.check_rounded,
          isLoading: controller.isCreating.value,
          onNext: controller.submitTrailer,
          onBack: () => controller.onBackPressed(false),
        ),
      ),
      sections: [
        VehicleFormSection(
          icon: Icons.description_rounded,
          title: 'Lease agreement',
          children: [
            VehicleTextField(
              label: 'Leasing Company',
              hintText: 'Leasing Company',
              controller: controller.leaseCompany,
            ),
            VehicleTextField(
              label: 'Lease Reference',
              hintText: 'Lease Reference',
              controller: controller.leaseReference,
            ),
          ],
        ),
        VehicleFormSection(
          icon: Icons.build_rounded,
          title: 'Maintenance',
          children: [
            VehicleDateField(
              controller: controller.inServiceOn,
              label: 'In Service On',
              hint: 'In Service On',
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              isRequired: true,
            ),
            VehicleDateField(
              controller: controller.nextInspectionOn,
              label: 'Next Inspection On',
              hint: 'Next Inspection On',
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              isRequired: true,
            ),
          ],
        ),
      ],
    );
  }
}
