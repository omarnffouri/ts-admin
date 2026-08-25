// To parse this JSON data, do
//
//     final shipmentDetails = shipmentDetailsFromJson(jsonString);

import 'package:equatable/equatable.dart';

class ShipmentDetails extends Equatable {
  final int? shipment;
  final String? shipmentNumber;
  final String? customer;
  final String? customerReference;
  final String? bolNumber;
  final Files? files;
  final List<ShipmentStop>? shipmentStops;
  final List<ShipmentCharge>? billingCharges;
  final List<AdditionalCharge>? additionalCharges;
  final List<Driver>? drivers;

  const ShipmentDetails({
    this.shipment,
    this.shipmentNumber,
    this.customer,
    this.customerReference,
    this.bolNumber,
    this.files,
    this.shipmentStops,
    this.billingCharges,
    this.additionalCharges,
    this.drivers,
  });

  @override
  List<Object?> get props => [
        shipment,
        shipmentNumber,
        customer,
        customerReference,
        bolNumber,
        files,
        shipmentStops,
        billingCharges,
        additionalCharges,
        drivers,
      ];
}

class AdditionalCharge extends Equatable {
  final int? driverId;
  final String? driverName;
  final Reason? reason;

  /// Total charge on the shipment.
  final String? amount;

  /// The driver's share of [amount] — what this screen shows.
  final String? driverPay;
  final String? note;

  const AdditionalCharge({
    this.driverId,
    this.driverName,
    this.reason,
    this.amount,
    this.driverPay,
    this.note,
  });

  Map<String, dynamic> toEntity() => {
        "driver_id": driverId,
        "driver_name": driverName,
        "reason": reason?.toEntity(),
        "amount": amount,
        "driver_pay": driverPay,
        "note": note,
      };

  @override
  List<Object?> get props => [
        driverId,
        driverName,
        reason,
        amount,
        driverPay,
        note,
      ];
}

class Reason extends Equatable {
  final int? id;
  final String? code;
  final String? type;
  final String? value;

  const Reason({
    this.id,
    this.code,
    this.type,
    this.value,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "code": code,
        "type": type,
        "value": value,
      };

  @override
  List<Object?> get props => [
        id,
        code,
        type,
        value,
      ];
}

class Driver extends Equatable {
  final int? id;
  final String? name;
  final int? truck;
  final String? type;
  final String? settlementStatus;

  const Driver({
    this.id,
    this.name,
    this.truck,
    this.type,
    this.settlementStatus,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "truck": truck,
        "trip_type": type,
        "settlement_status": settlementStatus,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        truck,
        type,
        settlementStatus,
      ];
}

class Files extends Equatable {
  final List<Confirmation>? confirmation;
  final List<Confirmation>? proofOfDelivery;
  final List<Confirmation>? fuel;
  final List<Confirmation>? lumper;
  final List<Confirmation>? invoiced;
  final List<Confirmation>? others;

  const Files({
    this.confirmation,
    this.proofOfDelivery,
    this.fuel,
    this.lumper,
    this.invoiced,
    this.others,
  });

  Map<String, dynamic> toEntity() => {
        "confirmation": confirmation == null
            ? []
            : List<dynamic>.from(confirmation!.map((x) => x.toEntity())),
        "proof_of_delivery": proofOfDelivery == null
            ? []
            : List<dynamic>.from(proofOfDelivery!.map((x) => x.toEntity())),
        "fuel": fuel == null
            ? []
            : List<dynamic>.from(fuel!.map((x) => x.toEntity())),
        "lumper": lumper == null
            ? []
            : List<dynamic>.from(lumper!.map((x) => x.toEntity())),
        "invoiced": invoiced == null
            ? []
            : List<dynamic>.from(invoiced!.map((x) => x.toEntity())),
        "others": others == null
            ? []
            : List<dynamic>.from(others!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [
        confirmation,
        proofOfDelivery,
        fuel,
        lumper,
        invoiced,
        others,
      ];
}

class Confirmation extends Equatable {
  final String? fileType;
  final String? name;
  final String? url;
  final String? uploadedBy;
  final DateTime? createdAt;
  final dynamic approvedBy;
  final DateTime? updatedAt;
  final dynamic deletedBy;
  final dynamic deletedAt;

  const Confirmation({
    this.fileType,
    this.name,
    this.url,
    this.uploadedBy,
    this.createdAt,
    this.approvedBy,
    this.updatedAt,
    this.deletedBy,
    this.deletedAt,
  });

  Map<String, dynamic> toEntity() => {
        "file_type": fileType,
        "name": name,
        "url": url,
        "uploadedBy": uploadedBy,
        "createdAt": createdAt?.toIso8601String(),
        "approvedBy": approvedBy,
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedBy": deletedBy,
        "deletedAt": deletedAt,
      };

  @override
  List<Object?> get props => [
        fileType,
        name,
        url,
        uploadedBy,
        createdAt,
        approvedBy,
        updatedAt,
        deletedBy,
        deletedAt,
      ];
}

class ShipmentCharge extends Equatable {
  final int? id;
  final String? type;
  final String? useForPay;
  final String? revenue;

  const ShipmentCharge({
    this.id,
    this.type,
    this.useForPay,
    this.revenue,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "type": type,
        "use_for_pay": useForPay,
        "revenue": revenue,
      };

  @override
  List<Object?> get props => [
        id,
        type,
        useForPay,
        revenue,
      ];
}

class ShipmentStop extends Equatable {
  final int? id;
  final String? stopType;
  final String? companyName;
  final String? weight;
  final String? goods;
  final DateTime? dateTime;
  final String? contactDetails;
  final String? info;
  final String? address;

  const ShipmentStop({
    this.id,
    this.stopType,
    this.companyName,
    this.weight,
    this.goods,
    this.dateTime,
    this.contactDetails,
    this.info,
    this.address,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "stop_type": stopType,
        "company_name": companyName,
        "weight": weight,
        "goods": goods,
        "transit_date_time": dateTime?.toIso8601String(),
        "contact_details": contactDetails,
        "info": info,
        "address": address,
      };

  @override
  List<Object?> get props => [
        id,
        stopType,
        companyName,
        weight,
        goods,
        dateTime,
        contactDetails,
        info,
        address,
      ];
}
