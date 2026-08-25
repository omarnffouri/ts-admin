import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/additional_pay_entity.dart';

final DateFormat _thisYear = DateFormat('MMM d');
final DateFormat _otherYear = DateFormat('MMM d, y');

/// Presentation-only helpers for [AdditionalPayEntity].
extension AdditionalPayUiX on AdditionalPayEntity {
  /// "Aug 10", or "Aug 10, 2024" outside the current year.
  String get dateLabel {
    final DateTime? at = requestedAt;
    if (at == null) return '';
    return at.year == DateTime.now().year
        ? _thisYear.format(at)
        : _otherYear.format(at);
  }

  /// "Aug 10 · Super admin", skipping either half when it's missing.
  String get requestedCaption => [
        dateLabel,
        requestedByName ?? '',
      ].where((part) => part.isNotEmpty).join(' · ');

  /// "$14,862.74" — grouped like the billing sections.
  String get amountLabel =>
      '${additionalAmount ?? 0}'.decimalPattern().dollar();

  /// Signed delta ("+$14,862.74"); use [amountLabel] for sentence copy.
  String get deltaLabel => '+$amountLabel';

  /// Approved-so-far figure, null for a first request.
  String? get approvedAmountLabel {
    final double approved = currentlyApproved ?? 0;
    if (approved <= 0) return null;
    return '$approved'.decimalPattern().dollar();
  }
}
