import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/inspection_entity.dart';
import '../../../components/inspection_form/inspection_category_card.dart';
import '../../../components/inspection_form/inspection_checklist_item.dart';
import '../../controllers/new_inspection_controller.dart';

class InspectionCategoriesList extends StatelessWidget {
  const InspectionCategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final NewInspectionController controller =
        Get.find<NewInspectionController>();

    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: controller.inspectionFields.length,
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final InspectionEntity inspection =
              controller.inspectionFields[index];
          final List<CheckEntity> checks =
              inspection.checks ?? const <CheckEntity>[];

          return InspectionCategoryCard(
            key: ValueKey<String>(
              'inspection-category-${inspection.id ?? index}',
            ),
            title: inspection.type ?? '',
            completed: inspection.checks == null
                ? 0
                : controller.getTitlePassStatus(inspection),
            total: checks.length,
            isSelectedAll: inspection.isSelectedAll ?? false,
            tileController: inspection.tileController,
            onExpansionChanged: (bool expanded) {
              controller.onTileExpantionChanged(index, expanded);
            },
            onSelectAllChanged: (bool value) {
              inspection.isSelectedAll = value;
              for (final CheckEntity check in checks) {
                check.isPassed = value;
              }
              controller.inspectionFields.refresh();
            },
            children: <Widget>[
              ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: checks.length,
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, checkIndex) =>
                    const SizedBox(height: 2),
                itemBuilder: (context, checkIndex) {
                  final CheckEntity check = checks[checkIndex];

                  return InspectionChecklistItem(
                    key: ValueKey<String>(
                      'inspection-check-${check.id ?? '$index-$checkIndex'}',
                    ),
                    title: check.title ?? '',
                    isPassed: check.isPassed ?? false,
                    onChanged: (bool value) {
                      check.isPassed = value;
                      controller.handleSwitchSelection(inspection);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
