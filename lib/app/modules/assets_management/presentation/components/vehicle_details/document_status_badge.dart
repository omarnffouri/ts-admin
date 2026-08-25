import 'package:flutter/material.dart';

import 'vehicle_status_badge.dart';

class DocumentStatusBadge extends StatelessWidget {
  const DocumentStatusBadge({
    super.key,
    required this.label,
    required this.tone,
    required this.icon,
    this.semanticsLabel,
  });

  final String label;
  final VehicleStatusTone tone;
  final IconData icon;
  final String? semanticsLabel;

  factory DocumentStatusBadge.availability({required bool isUploaded}) {
    final String label = isUploaded ? 'Uploaded' : 'Pending';

    return DocumentStatusBadge(
      label: label,
      tone: isUploaded ? VehicleStatusTone.success : VehicleStatusTone.pending,
      icon: isUploaded ? Icons.check_circle_rounded : Icons.pending_outlined,
      semanticsLabel: 'Document status: $label',
    );
  }

  factory DocumentStatusBadge.expiration({
    required String label,
    required bool hasExpiration,
    required bool isUploaded,
  }) {
    return DocumentStatusBadge(
      label: label,
      tone: isUploaded ? VehicleStatusTone.success : VehicleStatusTone.neutral,
      icon: hasExpiration ? Icons.event_outlined : Icons.all_inclusive_rounded,
      semanticsLabel:
          hasExpiration ? 'Expiration: $label' : 'Expiration: not applicable',
    );
  }

  @override
  Widget build(BuildContext context) {
    return VehicleStatusBadge(
      label: label,
      tone: tone,
      icon: icon,
      semanticsLabel: semanticsLabel,
    );
  }
}
