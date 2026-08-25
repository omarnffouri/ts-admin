import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/entities/inspection_details_entity.dart';
import '../../../components/inspection_details/inspection_details_category_card.dart';
import '../../../components/inspection_form/inspection_details_section.dart';
import '../../controllers/inspection_details_controller.dart';

class InspectionChecksWidget extends GetView<InspectionDetailsController> {
  const InspectionChecksWidget({super.key});

  /// Existing mapping: road-test flag for drivers, repair flag for vehicles.
  static bool _isPassed(CheckEntity check, String type) {
    return type == "driver"
        ? check.isRoadTestPassed ?? false
        : check.needRepair == false;
  }

  static String _statusLabel(bool isPassed, String type) {
    if (type == "driver") {
      return isPassed ? 'Passed' : 'Not passed';
    }
    return isPassed ? 'No repair needed' : 'Needs repair';
  }

  @override
  Widget build(BuildContext context) {
    final List<InspectionDataEntity>? inspectionFields =
        controller.inspectionDetails.inspectionDetail;
    final String type = controller.type.value;

    return InspectionDetailsSection(
      icon: Icons.checklist_rtl_rounded,
      title: 'Inspection Results',
      padded: false,
      spacing: 0,
      children: [
        if (inspectionFields == null || inspectionFields.isEmpty)
          const _NoChecksView()
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: inspectionFields.length,
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final InspectionDataEntity inspection = inspectionFields[index];
              final List<CheckEntity> checks =
                  inspection.checks ?? const <CheckEntity>[];
              final int passed = checks
                  .where((CheckEntity check) => _isPassed(check, type))
                  .length;

              return InspectionDetailsCategoryCard(
                key: ValueKey<String>(
                  'inspection-result-${inspection.type ?? index}',
                ),
                title: inspection.type ?? '',
                passed: passed,
                total: checks.length,
                tileController: inspection.tileController,
                onExpansionChanged: (bool expanded) {
                  controller.onTileExpantionChanged(index, expanded);
                },
                children: [
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: checks.length,
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, checkIndex) {
                      final CheckEntity check = checks[checkIndex];
                      final bool isPassed = _isPassed(check, type);

                      return InspectionAnswerRow(
                        key: ValueKey<String>(
                          'inspection-answer-${check.id ?? '$index-$checkIndex'}',
                        ),
                        name: check.name ?? '',
                        isPassed: isPassed,
                        statusLabel: _statusLabel(isPassed, type),
                      );
                    },
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}

/// Shown when the response carries no categories at all.
class _NoChecksView extends StatelessWidget {
  const _NoChecksView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.inbox_rounded,
              size: 18,
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No inspection Fields found',
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
