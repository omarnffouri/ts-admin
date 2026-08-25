import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../../components/inspection_details/inspection_info_card.dart';
import '../../../components/inspection_details/inspection_info_row.dart';
import '../../../components/inspection_details/inspection_summary_card.dart';
import '../../controllers/inspection_details_controller.dart';
import 'inspection_subject_info_card.dart';

/// Everything that describes the inspection itself — number, type, result,
/// subject and recorded information — in a single card.
class InspectionOverviewSection extends GetView<InspectionDetailsController> {
  const InspectionOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final details = controller.inspectionDetails;
    final inspection = details.inspection;

    // Same mapping as before: only `result == 1` counts as satisfactory.
    final bool isSatisfactory = inspection?.result.toString() == '1';
    final bool isDriver = controller.type.value == 'driver';
    final String time = InspectionInfoRow.resolve(inspection?.time);

    return InspectionCardShell(
      children: [
        //
        // number, type, overall result
        InspectionSummaryHeader(
          number: controller.id.value,
          type: controller.type.value,
          isSatisfactory: isSatisfactory,
        ),

        //
        // subject (driver inspections only)
        if (details.driverInfo != null) ...[
          const InspectionCardDivider(),
          const InspectionSubjectInfoCard(),
        ],

        const InspectionCardDivider(),

        //
        // recorded information
        InspectionInfoGroup(
          icon: Icons.assignment_outlined,
          title: 'Inspection Information',
          children: [
            InspectionInfoRow(
              label: 'Inspector Name',
              value: inspection?.inspectorName,
              icon: Icons.person_outline_rounded,
            ),
            InspectionInfoRow(
              label: isDriver
                  ? 'Driver qualified'
                  : 'Vehicle condition satisfactory',
              value: isSatisfactory ? 'Yes' : 'No',
              icon: Icons.rule_rounded,
            ),
            InspectionInfoRow(
              label: 'Date',
              value: inspection?.date.formatDateOrNA(),
              icon: Icons.event_outlined,
            ),
            if (time != InspectionInfoRow.fallback)
              InspectionInfoRow(
                label: 'Time',
                value: time,
                icon: Icons.schedule_outlined,
              ),
            InspectionInfoRow(
              label: 'Remarks',
              value: inspection?.remarks,
              icon: Icons.notes_rounded,
            ),
          ],
        ),
      ],
    );
  }
}
