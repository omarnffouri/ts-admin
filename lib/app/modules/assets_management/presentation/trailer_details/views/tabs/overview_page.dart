import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/vehicle_details/expandable_vehicle_section.dart';
import '../../../components/vehicle_details/vehicle_note_card.dart';
import '../../../components/vehicle_details/vehicle_requested_documents.dart';
import '../../../components/vehicle_details/vehicle_section.dart';
import '../../../components/vehicle_details/vehicle_status_history.dart';
import '../../controllers/trailer_details_controller.dart';

class OverViewPage extends GetView<TrailerDetailsController> {
  const OverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isLoading = controller.isLoading.value;

        // first load — skeleton; later refreshes keep content + top bar
        if (isLoading && controller.trailerDetails.value == null) {
          return const _OverviewLoadingView();
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing trailer overview',
          refreshController: controller.overviewRefreshCtrl,
          onRefresh: controller.init,
          sliver: const _OverViewDetails(),
        );
      },
    );
  }
}

class _OverViewDetails extends GetView<TrailerDetailsController> {
  const _OverViewDetails();

  @override
  Widget build(BuildContext context) {
    final details = controller.trailerDetails.value;
    final requestedDocuments = details?.overview?.requestedDocuments ?? [];
    final statuses = details?.overview?.statuses ?? [];
    final notes = details?.overview?.notes ?? [];

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14,
          children: [
            VehicleRequestedDocuments(
              documents: requestedDocuments,
              emptyMessage:
                  'Documents requested for this trailer will show up here.',
            ),
            ExpandableVehicleSection(
              icon: Icons.history_rounded,
              title: 'Status History',
              count: statuses.isEmpty ? null : statuses.length,
              collapsed: statuses.isEmpty
                  ? const SizedBox.shrink()
                  : VehicleStatusHistoryItem(status: statuses.first),
              expanded: VehicleStatusHistory(
                statuses: statuses,
                emptyMessage:
                    'Status changes for this trailer will be listed here.',
              ),
            ),
            ExpandableVehicleSection(
              icon: Icons.sticky_note_2_outlined,
              title: 'Notes',
              count: notes.isEmpty ? null : notes.length,
              action: VehicleSectionIconAction(
                icon: Icons.add_comment_outlined,
                tooltip: 'Add note',
                onPressed: () => controller.showAddNewNoteBottomSheet(
                  trailerId: controller.trailerId.value,
                ),
              ),
              collapsed: notes.isEmpty
                  ? const SizedBox.shrink()
                  : VehicleNoteCard(note: notes.first, index: 0),
              expanded: VehicleNotesList(
                notes: notes,
                emptyMessage:
                    'Use the add button above to leave the first note.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewLoadingView extends StatelessWidget {
  const _OverviewLoadingView();

  @override
  Widget build(BuildContext context) {
    return const VehicleDetailsLoadingView(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 30),
          child: Column(
            spacing: 14,
            children: [
              VehicleSection(
                icon: Icons.folder_copy_outlined,
                title: 'Requested Documents',
                child: Column(
                  spacing: 8,
                  children: [
                    VehicleRequestedDocumentRowSkeleton(),
                    VehicleRequestedDocumentRowSkeleton(),
                    VehicleRequestedDocumentRowSkeleton(),
                  ],
                ),
              ),
              VehicleSectionSkeleton(
                icon: Icons.history_rounded,
                title: 'Status History',
                itemHeight: 64,
                itemCount: 1,
              ),
              VehicleSectionSkeleton(
                icon: Icons.sticky_note_2_outlined,
                title: 'Notes',
                itemHeight: 64,
                itemCount: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
