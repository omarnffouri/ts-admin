import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/inspection_details/inspection_info_card.dart';
import '../../../components/inspection_details/inspection_info_row.dart';
import '../../controllers/inspection_details_controller.dart';

/// Subject of the inspection. Driver inspections are the only type whose
/// details response carries subject data (`driverInfo`), so for truck and
/// trailer inspections this renders nothing rather than inventing fields.
///
/// Values are shown exactly as the model returns them — the page keeps the
/// app's existing (unmasked) treatment of the SSN, the same as the HR screens.
class InspectionSubjectInfoCard extends GetView<InspectionDetailsController> {
  const InspectionSubjectInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final driverInfo = controller.inspectionDetails.driverInfo;
    if (driverInfo == null) {
      return const SizedBox.shrink();
    }

    final String name = InspectionInfoRow.resolve(driverInfo.name);

    return InspectionInfoGroup(
      icon: Icons.badge_outlined,
      title: 'Driver Information',
      subtitle: name == InspectionInfoRow.fallback ? null : name,
      children: [
        InspectionInfoRow(
          label: 'Social Security Number',
          value: driverInfo.ssNo,
          icon: Icons.credit_card_rounded,
        ),
        InspectionInfoRow(
          label: 'State',
          value: driverInfo.cdlIssuingState,
          icon: Icons.map_outlined,
        ),
        InspectionInfoRow(
          label: 'Current License',
          value: driverInfo.currentLicenseNum,
          icon: Icons.badge_rounded,
        ),
      ],
    );
  }
}
