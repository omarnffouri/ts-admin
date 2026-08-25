import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../domain/entities/vehicle_details_entity.dart';
import 'section_empty_state.dart';
import 'vehicle_status_badge.dart';

class VehicleStatusHistory extends StatelessWidget {
  const VehicleStatusHistory({
    super.key,
    required this.statuses,
    required this.emptyMessage,
  });

  final List<Status> statuses;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (statuses.isEmpty) {
      return SectionEmptyState(
        icon: Icons.history_rounded,
        title: 'No status history',
        message: emptyMessage,
        dense: true,
      );
    }

    return ListView.separated(
      itemCount: statuses.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => VehicleStatusHistoryItem(
        status: statuses[index],
      ),
    );
  }
}

class VehicleStatusHistoryItem extends StatelessWidget {
  const VehicleStatusHistoryItem({super.key, required this.status});

  final Status status;

  IconData _icon(VehicleStatusTone tone) {
    return switch (tone) {
      VehicleStatusTone.success => Icons.check_circle_rounded,
      VehicleStatusTone.pending => Icons.schedule_rounded,
      VehicleStatusTone.danger => Icons.error_outline_rounded,
      VehicleStatusTone.neutral => Icons.info_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final VehicleStatusTone tone = vehicleStatusTone(status.name);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: VehicleStatusBadge(
                    label: status.name?.formatStatus() ?? '',
                    tone: tone,
                    icon: _icon(tone),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status.createdAt.getDDMMMYYYY(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.tertiaryTextColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.notes_rounded,
                size: 15,
                color: context.tertiaryTextColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  status.reason ?? 'N/A',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.secondaryTextColor,
                        height: 1.35,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
