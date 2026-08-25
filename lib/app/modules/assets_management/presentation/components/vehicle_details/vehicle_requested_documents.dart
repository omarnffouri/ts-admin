import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../domain/entities/vehicle_details_entity.dart';
import 'section_empty_state.dart';
import 'vehicle_section.dart';
import 'vehicle_status_badge.dart';

class VehicleRequestedDocuments extends StatelessWidget {
  const VehicleRequestedDocuments({
    super.key,
    required this.documents,
    required this.emptyMessage,
  });

  final List<OverviewRequestedDocument> documents;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return VehicleSection(
      icon: Icons.folder_copy_outlined,
      title: 'Requested Documents',
      count: documents.isEmpty ? null : documents.length,
      child: documents.isEmpty
          ? SectionEmptyState(
              icon: Icons.description_outlined,
              title: 'No requested documents',
              message: emptyMessage,
              dense: true,
            )
          : Column(
              spacing: 8,
              children: documents
                  .map(
                    (document) => VehicleRequestedDocumentRow(
                      document: document,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class VehicleRequestedDocumentRow extends StatelessWidget {
  const VehicleRequestedDocumentRow({
    super.key,
    required this.document,
  });

  final OverviewRequestedDocument document;

  @override
  Widget build(BuildContext context) {
    final bool isUploaded = document.isUploaded == true;
    final String status = isUploaded ? 'Uploaded' : 'Pending';
    final VehicleStatusTone tone =
        isUploaded ? VehicleStatusTone.success : VehicleStatusTone.pending;
    final IconData statusIcon =
        isUploaded ? Icons.check_circle_rounded : Icons.pending_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Row(
        children: [
          Icon(statusIcon, size: 18, color: tone.color(context)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              document.fileName ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          VehicleStatusBadge(
            label: status,
            tone: tone,
            icon: statusIcon,
            semanticsLabel: '${document.fileName ?? ''}, status: $status',
          ),
        ],
      ),
    );
  }
}

class VehicleRequestedDocumentRowSkeleton extends StatelessWidget {
  const VehicleRequestedDocumentRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
