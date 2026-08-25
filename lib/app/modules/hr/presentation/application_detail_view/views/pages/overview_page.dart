import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/entities/requested_document_entity.dart';
import '../../../../domain/entities/statuses_history_entity.dart';
import '../../controllers/application_detail_view_controller.dart';
import '../components/requested_document_widget.dart';
import '../components/status_history_widget.dart';

class OverViewPage extends GetView<ApplicationDetailViewController> {
  const OverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLaodingApplicationDetails
          ? _buildLoadingView()
          : SmartRefresher(
              controller: controller.overViewRefreshController,
              header: const WaterDropMaterialHeader(),
              onRefresh: () {
                controller.handleRefresh();
                controller.overViewRefreshController.refreshCompleted();
              },
              child: const _OverViewDetails(),
            ),
    );
  }
}

class _OverViewDetails extends GetView<ApplicationDetailViewController> {
  const _OverViewDetails();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RequestedDocumentWidget(),
          StatusHistoryWidget(),
        ],
      ),
    );
  }
}

Widget _buildLoadingView() {
  return IgnorePointer(
    child: Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text(
                    'Requested Documents',
                    style: Get.theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).marginOnly(left: 5),
                ),
                ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return RequestedDocumentItem(
                      index: index,
                      document: RequestedDocumentEntity(
                        id: index,
                        fileName: 'Document ${index + 1}',
                        isUploaded: false,
                      ),
                    );
                  },
                ),
                const Divider(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text(
                    'Status History',
                    style: Get.theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).marginOnly(left: 5),
                ),
                ListView.builder(
                  itemCount: 4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return StatusHistoryItem(
                      index: index,
                      dateTime: DateTime.now(),
                      status: StatusesHistoryEntity(
                        id: index,
                        name: 'Status ${index + 1}',
                        createdAt: DateTime.now(),
                        reason: 'updated by',
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
