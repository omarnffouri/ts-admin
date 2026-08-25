import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/app_loading_listview.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_driver_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/driver_inspection/controllers/driver_inspection_controller.dart';
import 'package:ts_admin/app/modules/inspection_management/presintation/driver_inspection/views/components/driver_inspection_request_card.dart';

class DriverRequestedInspectionsTab
    extends GetView<DriverInspectionController> {
  const DriverRequestedInspectionsTab({super.key});

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
          await controller.getAllDriverRequestedInspections();
          controller.requestedRefreshController.refreshCompleted();
        },
        child: controller.driverRequestedInspectionsList.isEmpty
            ? const EmptyStateView(
                icon: Icons.fact_check_outlined,
                title: 'No inspected requests',
                message: 'Completed driver inspections will be listed here.',
              )
            : ListView.separated(
                primary: false,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: controller.driverRequestedInspectionsList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final InspectionDriverEntity inspection =
                      controller.driverRequestedInspectionsList[index];
                  return DriverInspectionRequestCard(
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
