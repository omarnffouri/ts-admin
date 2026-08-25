import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/app_loading_listview.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_driver_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/driver_inspection/controllers/driver_inspection_controller.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/driver_inspection/views/components/driver_inspection_request_card.dart';

class DriverPendingInspectionsTab extends GetView<DriverInspectionController> {
  const DriverPendingInspectionsTab({super.key});

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
          await controller.getAllDriverPendingInspections();
          controller.pendingRefreshController.refreshCompleted();
        },
        child: controller.driverPendingInspectionsList.isEmpty
            ? const EmptyStateView(
                icon: Icons.pending_actions_rounded,
                title: 'No pending requests',
                message:
                    'New driver inspection requests will appear here once they are created.',
              )
            : ListView.separated(
                primary: false,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: controller.driverPendingInspectionsList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final InspectionDriverEntity inspection =
                      controller.driverPendingInspectionsList[index];
                  return DriverInspectionRequestCard(
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
