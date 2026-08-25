import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/truck_details_controller.dart';
import '../components/check_list_widget.dart';
import '../../../components/vehicle_details/expandable_vehicle_section.dart';
import '../../../components/vehicle_details/vehicle_note_card.dart';
import '../../../components/vehicle_details/vehicle_requested_documents.dart';
import '../../../components/vehicle_details/vehicle_section.dart';
import '../../../components/vehicle_details/vehicle_status_history.dart';

class OverViewPage extends GetView<TruckDetailsController> {
  const OverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isLoading = controller.isLoading.value;

        // first load — skeleton; later refreshes keep content + top bar
        if (isLoading && controller.truckDetails.value == null) {
          return const _OverviewLoadingView();
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing truck overview',
          refreshController: controller.overviewRefreshCtrl,
          onRefresh: controller.init,
          sliver: const _OverViewDetails(),
        );
      },
    );
  }
}

class _OverViewDetails extends GetView<TruckDetailsController> {
  const _OverViewDetails();

  @override
  Widget build(BuildContext context) {
    final details = controller.truckDetails.value;
    final statusesHistory = details?.overview?.statuses ?? [];
    final checkList = details?.overview?.checklists ?? [];
    final notes = details?.overview?.notes ?? [];
    final requestedDocuments = details?.overview?.requestedDocuments ?? [];
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
      sliver: SliverToBoxAdapter(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 14,
            children: [
              //
              // requested documents
              VehicleRequestedDocuments(
                documents: requestedDocuments,
                emptyMessage:
                    'Documents requested for this truck will show up here.',
              ),

              //status
              ExpandableVehicleSection(
                icon: Icons.history_rounded,
                title: "Status History",
                count: statusesHistory.isEmpty ? null : statusesHistory.length,
                collapsed: statusesHistory.isEmpty
                    ? const SizedBox.shrink()
                    : VehicleStatusHistoryItem(
                        status: statusesHistory.first,
                      ),
                expanded: VehicleStatusHistory(
                  statuses: statusesHistory,
                  emptyMessage:
                      'Status changes for this truck will be listed here.',
                ),
              ),

              //check list
              ExpandableVehicleSection(
                icon: Icons.checklist_rounded,
                title: "Check List",
                count: checkList.isEmpty ? null : checkList.length,
                collapsed: checkList.isEmpty
                    ? const SizedBox.shrink()
                    : AddRemoveDateWidget(checklist: checkList.first),
                expanded: const CheckListWidget(),
              ),

              //notes
              ExpandableVehicleSection(
                icon: Icons.sticky_note_2_outlined,
                title: "Notes",
                count: notes.isEmpty ? null : notes.length,
                action: VehicleSectionIconAction(
                  icon: Icons.add_comment_outlined,
                  tooltip: 'Add note',
                  onPressed: () {
                    controller.showAddNewNoteBottomSheet(
                      truckId: controller.truckId.value,
                    );
                  },
                ),
                collapsed: notes.isEmpty
                    ? const SizedBox.shrink()
                    : VehicleNoteCard(
                        note: notes.first,
                        index: 0,
                      ),
                expanded: VehicleNotesList(
                  notes: notes,
                  emptyMessage:
                      'Use the add button above to leave the first note.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmering skeleton mirroring the overview layout while the truck details
/// request is in flight.
class _OverviewLoadingView extends StatelessWidget {
  const _OverviewLoadingView();

  @override
  Widget build(BuildContext context) {
    return VehicleDetailsLoadingView(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 14,
            children: [
              //
              // requested documents skeleton
              VehicleSection(
                icon: Icons.folder_copy_outlined,
                title: 'Requested Documents',
                child: Column(
                  children: [
                    for (int index = 0; index < 5; index++)
                      Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 0 : 8),
                        child: const VehicleRequestedDocumentRowSkeleton(),
                      ),
                  ],
                ),
              ),

              //
              // collapsed sections skeleton
              const VehicleSectionSkeleton(
                icon: Icons.history_rounded,
                title: 'Status History',
                itemHeight: 64,
                itemCount: 1,
              ),
              const VehicleSectionSkeleton(
                icon: Icons.checklist_rounded,
                title: 'Check List',
                itemHeight: 64,
                itemCount: 1,
              ),
              const VehicleSectionSkeleton(
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
