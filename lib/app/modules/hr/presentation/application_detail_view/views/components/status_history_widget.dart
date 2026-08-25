import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';

import '../../../../domain/entities/statuses_history_entity.dart';
import '../../controllers/application_detail_view_controller.dart';

class StatusHistoryWidget extends GetView<ApplicationDetailViewController> {
  const StatusHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final statusesHistory = controller.statusesHistory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          child: Text(
            'Status History',
            style: Get.theme.textTheme.titleLarge,
          ),
        ),
        Divider(
          height: 0,
          color: Get.isDarkMode ? Colors.grey : null,
        ).marginSymmetric(horizontal: 14),
        if (statusesHistory.isEmpty)
          const SizedBox(
            height: 145,
            child: NoDataView(),
          ),
        if (statusesHistory.isNotEmpty)
          ListView.builder(
            itemCount: statusesHistory.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = statusesHistory[index];
              return StatusHistoryItem(
                index: index,
                status: item,
                isFirst: index == 0,
                isLast: index == statusesHistory.length - 1,
                dateTime: item.updatedAt,
              );
            },
          ),
      ],
    );
  }
}

class StatusHistoryItem extends StatelessWidget {
  final int index;
  final StatusesHistoryEntity status;
  final bool isFirst;
  final bool isLast;
  final DateTime? dateTime;

  const StatusHistoryItem({
    super.key,
    required this.index,
    required this.status,
    this.isFirst = false,
    this.isLast = false,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildRowTop(context),
        buildRowBottom(context),
        const SizedBox(height: 2)
      ],
    );
  }

  Widget buildRowTop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.check_circle,
          size: 20,
          color: getStatusColor(),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: getStatusColor(),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            status.name?.formatStatus() ?? '',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '${status.reason}',
          style: Get.textTheme.bodyMedium,
        )
      ],
    );
  }

  Color getStatusColor() {
    switch (status.name) {
      // case 'approved':
      //   return Colors.lightGreen.shade600;
      case 'hired':
        return Colors.lightGreen.shade600;
      // case 'in_process' || 'under_review':
      //   return Colors.orange;
      // case 'on_hold' || 'phone_screening':
      //   return Colors.blue;
      case 'terminated' || 'pending_delete':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  IntrinsicHeight buildRowBottom(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildVerticalLine(context),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Text(
                      status.createdAt.getDDMMMYYYY(),
                      style: Get.textTheme.bodySmall,
                    )
                  ],
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Opacity buildVerticalLine(BuildContext context) {
    return Opacity(
      opacity: isLast ? 0.0 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
        width: 2.0,
        color: Get.isDarkMode ? Colors.white54 : Colors.black12,
      ),
    );
  }

  Widget buildBadge({Widget? icon, String? val}) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white54 : Colors.black12,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon?.marginOnly(right: 5) ?? const SizedBox.shrink(),
          Text(
            val ?? '',
            style: Get.theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
