import 'package:ts_admin/app/core/enum/additional_pay_status.dart';

import '../../domain/enitities/additional_pay_entity.dart';

class AdditionalPayPayloadModel extends AdditionalPayPayloadEntity {
  const AdditionalPayPayloadModel({super.approvals, super.statusCounts});

  factory AdditionalPayPayloadModel.fromJson(Map<String, dynamic> json) =>
      AdditionalPayPayloadModel(
        approvals: (json["approvals"] as List? ?? [])
            .map((e) => AdditionalPayModel.fromJson(e))
            .toList(),
        statusCounts: json["status_counts"] == null
            ? null
            : AdditionalPayStatusCountsModel.fromJson(json["status_counts"]),
      );
}

class AdditionalPayModel extends AdditionalPayEntity {
  AdditionalPayModel({
    super.id,
    super.additionalAmount,
    super.shipment,
    super.driver,
    super.truck,
    super.pay,
    super.requestedBy,
    super.requestedAt,
    super.decidedBy,
    super.decidedAt,
    super.note,
    super.status,
  });

  factory AdditionalPayModel.fromJson(Map<String, dynamic> json) =>
      AdditionalPayModel(
        id: json["id"],
        additionalAmount: (json["additional_amount"] as num?)?.toDouble(),
        shipment: json["shipment"] == null
            ? null
            : AdditionalPayShipmentModel.fromJson(json["shipment"]),
        driver: json["driver"] == null
            ? null
            : AdditionalPayPersonModel.fromJson(json["driver"]),
        truck: json["truck"] == null
            ? null
            : AdditionalPayTruckModel.fromJson(json["truck"]),
        pay: json["pay"] == null
            ? null
            : AdditionalPayDetailsModel.fromJson(json["pay"]),
        requestedBy: json["requested_by"] == null
            ? null
            : AdditionalPayPersonModel.fromJson(json["requested_by"]),
        requestedAt: _dateFromJson(json["requested_at"]),
        decidedBy: json["decided_by"] == null
            ? null
            : AdditionalPayPersonModel.fromJson(json["decided_by"]),
        decidedAt: _dateFromJson(json["decided_at"]),
        note: json["decision_note"],
        status: _statusFromJson(json["status"]),
      );

  static DateTime? _dateFromJson(dynamic value) =>
      value == null ? null : DateTime.tryParse(value)?.toLocal();

  static AdditionalPayStatus _statusFromJson(dynamic value) =>
      AdditionalPayStatus.values.asNameMap()[value] ??
      AdditionalPayStatus.pending;
}

class AdditionalPayPersonModel extends AdditionalPayPerson {
  const AdditionalPayPersonModel({super.id, super.name, super.teamName});

  factory AdditionalPayPersonModel.fromJson(Map<String, dynamic> json) =>
      AdditionalPayPersonModel(
        id: json["id"],
        name: json["name"]?.toString(),
        teamName: json["team"]?.toString(),
      );
}

class AdditionalPayShipmentModel extends AdditionalPayShipment {
  const AdditionalPayShipmentModel({super.id, super.number});

  factory AdditionalPayShipmentModel.fromJson(Map<String, dynamic> json) =>
      AdditionalPayShipmentModel(
        id: json["id"],
        // Refs like "SH-231" are strings, but a purely numeric ref arrives as
        // an int — coerce so it can't blow up on the cast.
        number: json["number"]?.toString(),
      );
}

class AdditionalPayTruckModel extends AdditionalPayTruck {
  const AdditionalPayTruckModel({super.id, super.identifier});

  factory AdditionalPayTruckModel.fromJson(Map<String, dynamic> json) =>
      AdditionalPayTruckModel(
        id: json["id"],
        identifier: json["identifier"]?.toString(),
      );
}

class AdditionalPayStatusCountsModel extends AdditionalPayStatusCounts {
  const AdditionalPayStatusCountsModel({
    super.all,
    super.pending,
    super.approved,
    super.rejected,
    super.cancelled,
  });

  factory AdditionalPayStatusCountsModel.fromJson(Map<String, dynamic> json) =>
      AdditionalPayStatusCountsModel(
        all: json["all"],
        pending: json["pending"],
        approved: json["approved"],
        rejected: json["rejected"],
        cancelled: json["cancelled"],
      );
}

class AdditionalPayDetailsModel extends AdditionalPayDetails {
  const AdditionalPayDetailsModel({
    super.id,
    super.totalAdditionalAmount,
    super.approvedDriverAmount,
    super.requestedDriverAmount,
    super.notes,
  });

  factory AdditionalPayDetailsModel.fromJson(Map<String, dynamic> json) =>
      AdditionalPayDetailsModel(
        id: json["id"],
        totalAdditionalAmount:
            (json["total_additional_amount"] as num?)?.toDouble(),
        approvedDriverAmount:
            (json["approved_driver_amount"] as num?)?.toDouble(),
        requestedDriverAmount:
            (json["requested_driver_amount"] as num?)?.toDouble(),
        notes: json["notes"],
      );
}
