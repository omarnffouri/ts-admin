import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/app_loading_listview.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_truck_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/truck_trailer_inspection/controllers/truck_trailer_inspection_controller.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/truck_trailer_inspection/views/components/truck_trailer_inspection_request_card.dart';

class TruckTrailerPendingInspectionsTab
    extends GetView<TruckTrailerInspectionController> {
  const TruckTrailerPendingInspectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPendingInspection.value) {
        return const LoadingListView();
      }

      return SmartRefresher(
        controller: controller.pendingRefreshController,
        header: const WaterDropMaterialHeader(),
        onRefresh: () async {
          await controller.getAllTruckTrailerPendingInspection();
          controller.pendingRefreshController.refreshCompleted();
        },
        child: controller.pendingInspectionList.isEmpty
            ? const EmptyStateView(
                icon: Icons.pending_actions_rounded,
                title: 'No pending requests',
                message:
                    'New inspection requests will appear here once they are created.',
              )
            : ListView.separated(
                primary: false,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: controller.pendingInspectionList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final InspectionTrailerTruckEntity inspection =
                      controller.pendingInspectionList[index];
                  return TruckTrailerInspectionRequestCard(
                    key: ValueKey('pending_${inspection.id}'),
                    inspection: inspection,
                    index: index,
                    isPendingInspection: true,
                  );
                },
              ),
      );
    });
  }
}
