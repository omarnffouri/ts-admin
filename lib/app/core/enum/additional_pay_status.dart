import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

enum AdditionalPayStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

const int kMinDecisionNoteLength = 3;

extension AdditionalPayStatusX on AdditionalPayStatus {
  bool get requiresDecisionNote =>
      this == AdditionalPayStatus.rejected ||
      this == AdditionalPayStatus.approved;

  /// The note rule, asked by the field, the confirm button and the controller.
  bool acceptsNote(String note) =>
      !requiresDecisionNote || note.trim().length >= kMinDecisionNoteLength;

  /// Asked by the card and by its skeleton, so the two can't disagree.
  bool get hasActionRow => this == AdditionalPayStatus.pending;

  String get label {
    switch (this) {
      case AdditionalPayStatus.pending:
        return 'Pending';
      case AdditionalPayStatus.approved:
        return 'Approved';
      case AdditionalPayStatus.rejected:
        return 'Rejected';
      case AdditionalPayStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData get icon {
    switch (this) {
      case AdditionalPayStatus.pending:
        return Icons.schedule_rounded;
      case AdditionalPayStatus.approved:
        return Icons.check_circle_rounded;
      case AdditionalPayStatus.rejected:
        return Icons.cancel_rounded;
      case AdditionalPayStatus.cancelled:
        return Icons.do_not_disturb_on_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AdditionalPayStatus.pending:
        return const Color(0xFFB7791F);
      case AdditionalPayStatus.approved:
        return const Color(0xFF2F855A);
      case AdditionalPayStatus.rejected:
        return AppColorsLight.mainColor;
      case AdditionalPayStatus.cancelled:
        return const Color(0xFF718096);
    }
  }
}
