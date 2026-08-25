import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/app_loading_listview.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_truck_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/truck_trailer_inspection/controllers/truck_trailer_inspection_controller.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/truck_trailer_inspection/views/components/truck_trailer_inspection_request_card.dart';

class TruckTrailerRequestedInspectionsTab
    extends GetView<TruckTrailerInspectionController> {
  const TruckTrailerRequestedInspectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRequestedInspection.value) {
        return const LoadingListView();
      }

      return SmartRefresher(
        controller: controller.requestedRefreshController,
        header: const WaterDropMaterialHeader(),
        onRefresh: () async {
          await controller.getAllTruckTrailerRequestedInspection();
          controller.requestedRefreshController.refreshCompleted();
        },
        child: controller.requestedInspectionList.isEmpty
            ? const EmptyStateView(
                icon: Icons.fact_check_outlined,
                title: 'No inspected requests',
                message: 'Completed inspections will be listed here.',
              )
            : ListView.separated(
                primary: false,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: controller.requestedInspectionList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final InspectionTrailerTruckEntity inspection =
                      controller.requestedInspectionList[index];
                  return TruckTrailerInspectionRequestCard(
                    key: ValueKey('inspected_${inspection.id}'),
                    inspection: inspection,
                    index: index,
                    isPendingInspection: false,
                  );
                },
              ),
      );
    });
  }
}
