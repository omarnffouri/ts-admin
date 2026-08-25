import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/enum/additional_pay_status.dart';

/// The `data` block — approvals page plus per-status totals.
class AdditionalPayPayloadEntity extends Equatable {
  final List<AdditionalPayEntity> approvals;
  final AdditionalPayStatusCounts? statusCounts;

  const AdditionalPayPayloadEntity({
    this.approvals = const [],
    this.statusCounts,
  });

  @override
  List<Object?> get props => [approvals, statusCounts];
}

class AdditionalPayEntity extends Equatable {
  final int? id;

  /// requested_driver_amount − approved_driver_amount.
  final double? additionalAmount;
  final AdditionalPayShipment? shipment;
  final AdditionalPayPerson? driver;
  final AdditionalPayTruck? truck;
  final AdditionalPayDetails? pay;
  final AdditionalPayPerson? requestedBy;
  final DateTime? requestedAt;
  final AdditionalPayPerson? decidedBy;
  final DateTime? decidedAt;
  final Rx<AdditionalPayStatus> status;

  /// Admin note captured on approve/reject (`decision_note`).
  final RxnString note = RxnString();

  AdditionalPayEntity({
    this.id,
    this.additionalAmount,
    this.shipment,
    this.driver,
    this.truck,
    this.pay,
    this.requestedBy,
    this.requestedAt,
    this.decidedBy,
    this.decidedAt,
    String? note,
    AdditionalPayStatus status = AdditionalPayStatus.pending,
  }) : status = status.obs {
    this.note.value = note;
  }

  // Convenience reads so the UI doesn't chain through the nested blocks.
  String? get driverName => driver?.name;
  String? get teamName => driver?.teamName;
  String? get truckNumber => truck?.identifier;
  String? get shipmentRef => shipment?.number;
  String? get requestedByName => requestedBy?.name;
  double? get currentlyApproved => pay?.approvedDriverAmount;

  @override
  List<Object?> get props => [
        id,
        additionalAmount,
        shipment,
        driver,
        truck,
        pay,
        requestedBy,
        requestedAt,
        decidedBy,
        decidedAt,
      ];
}

/// `driver` / `requested_by` / `decided_by` blocks. Only the driver block
/// carries `team`.
class AdditionalPayPerson extends Equatable {
  final int? id;
  final String? name;
  final String? teamName;

  const AdditionalPayPerson({this.id, this.name, this.teamName});

  @override
  List<Object?> get props => [id, name, teamName];
}

class AdditionalPayShipment extends Equatable {
  final int? id;
  final String? number;

  const AdditionalPayShipment({this.id, this.number});

  @override
  List<Object?> get props => [id, number];
}

class AdditionalPayTruck extends Equatable {
  final int? id;
  final String? identifier;

  const AdditionalPayTruck({this.id, this.identifier});

  @override
  List<Object?> get props => [id, identifier];
}

/// The `statusCounts` block — totals per status across all pages.
class AdditionalPayStatusCounts extends Equatable {
  final int? all;
  final int? pending;
  final int? approved;
  final int? rejected;
  final int? cancelled;

  const AdditionalPayStatusCounts({
    this.all,
    this.pending,
    this.approved,
    this.rejected,
    this.cancelled,
  });

  int? countOf(AdditionalPayStatus status) {
    switch (status) {
      case AdditionalPayStatus.pending:
        return pending;
      case AdditionalPayStatus.approved:
        return approved;
      case AdditionalPayStatus.rejected:
        return rejected;
      case AdditionalPayStatus.cancelled:
        return cancelled;
    }
  }

  Map<AdditionalPayStatus, int> get byStatus => {
        for (final s in AdditionalPayStatus.values)
          if (countOf(s) case final int c) s: c,
      };

  @override
  List<Object?> get props => [all, pending, approved, rejected, cancelled];
}

/// The `pay` block — running totals for the driver's pay on this shipment.
class AdditionalPayDetails extends Equatable {
  final int? id;
  final double? totalAdditionalAmount;
  final double? approvedDriverAmount;
  final double? requestedDriverAmount;
  final String? notes;

  const AdditionalPayDetails({
    this.id,
    this.totalAdditionalAmount,
    this.approvedDriverAmount,
    this.requestedDriverAmount,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        totalAdditionalAmount,
        approvedDriverAmount,
        requestedDriverAmount,
        notes,
      ];
}
