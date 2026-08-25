import '../../domain/enitities/shipment_details_entity.dart';

/// This endpoint mixes quoted and bare numerics — `amount: "30127.00"` sits
/// beside `truck: 5457` — so every `String?` field is coerced instead of cast.
String? _str(dynamic value) => value?.toString();

/// As [_str], but treats the API's empty-string placeholder as absent.
String? _strOrNull(dynamic value) {
  final String? text = value?.toString();
  return (text == null || text.isEmpty) ? null : text;
}

class ShipmentDetailsModel extends ShipmentDetails {
  const ShipmentDetailsModel({
    super.shipment,
    super.shipmentNumber,
    super.customer,
    super.customerReference,
    super.bolNumber,
    super.files,
    super.shipmentStops,
    super.billingCharges,
    super.additionalCharges,
    super.drivers,
  });

  factory ShipmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailsModel(
        shipment: json["shipment"],
        shipmentNumber: _str(json["shipment_number"]),
        customer: _str(json["customer"]),
        customerReference: _str(json["customer_reference"]),
        bolNumber: _str(json["bol_number"]),
        files: json["files"] == null ||
                (json["files"] is List && json["files"].isEmpty)
            ? null
            : FilesModel.fromJson(json["files"]),
        shipmentStops: json["shipment_stops"] == null ||
                (json["shipment_stops"] is List &&
                    json["shipment_stops"].isEmpty)
            ? []
            : List<ShipmentStopModel>.from(json["shipment_stops"]!
                .map((x) => ShipmentStopModel.fromJson(x))),
        billingCharges: json["shipment_charges"] == null ||
                (json["shipment_charges"] is List &&
                    json["shipment_charges"].isEmpty)
            ? []
            : List<ShipmentChargeModel>.from(json["shipment_charges"]!
                .map((x) => ShipmentChargeModel.fromJson(x))),
        additionalCharges: json["additional_charges"] == null ||
                (json["additional_charges"] is List &&
                    json["additional_charges"].isEmpty)
            ? []
            : List<AdditionalChargeModel>.from(json["additional_charges"]!
                .map((x) => AdditionalChargeModel.fromJson(x))),
        drivers: json["drivers"] == null ||
                (json["drivers"] is List && json["drivers"].isEmpty)
            ? []
            : List<DriverModel>.from(
                json["drivers"]!.map((x) => DriverModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shipment": shipment,
        "shipment_number": shipmentNumber,
        "customer": customer,
        "customer_reference": customerReference,
        "bol_number": bolNumber,
        "files": files?.toEntity(),
        "shipment_stops": shipmentStops == null
            ? []
            : List<dynamic>.from(shipmentStops!.map((x) => x.toEntity())),
        "shipment_charges": billingCharges == null
            ? []
            : List<dynamic>.from(billingCharges!.map((x) => x.toEntity())),
        "additional_charges": additionalCharges == null
            ? []
            : List<dynamic>.from(additionalCharges!.map((x) => x.toEntity())),
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toEntity())),
      };
}

class AdditionalChargeModel extends AdditionalCharge {
  const AdditionalChargeModel({
    super.driverId,
    super.driverName,
    super.reason,
    super.amount,
    super.driverPay,
    super.note,
  });

  factory AdditionalChargeModel.fromJson(Map<String, dynamic> json) =>
      AdditionalChargeModel(
        driverId: json["driver_id"],
        driverName: _str(json["driver_name"]),
        reason: json["reason"] == null
            ? null
            : ReasonModel.fromJson(json["reason"]),
        amount: _str(json["amount"]),
        driverPay: _str(json["driver_pay"]),
        note: _strOrNull(json["note"]),
      );

  Map<String, dynamic> toJson() => {
        "driver_id": driverId,
        "driver_name": driverName,
        "reason": reason?.toEntity(),
        "amount": amount,
        "driver_pay": driverPay,
        "note": note,
      };
}

class ReasonModel extends Reason {
  const ReasonModel({
    super.id,
    super.code,
    super.type,
    super.value,
  });

  factory ReasonModel.fromJson(Map<String, dynamic> json) => ReasonModel(
        id: json["id"],
        code: _str(json["code"]),
        type: _str(json["type"]),
        value: _str(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "type": type,
        "value": value,
      };
}

class DriverModel extends Driver {
  const DriverModel({
    super.id,
    super.name,
    super.truck,
    super.type,
    super.settlementStatus,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json["id"],
        name: _str(json["name"]),
        truck: json["truck"],
        type: _str(json["trip_type"]),
        settlementStatus: _str(json["settlement_status"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "truck": truck,
        "trip_type": type,
        "settlement_status": settlementStatus,
      };
}

class FilesModel extends Files {
  const FilesModel({
    super.confirmation,
    super.proofOfDelivery,
    super.fuel,
    super.lumper,
    super.invoiced,
    super.others,
  });

  factory FilesModel.fromJson(Map<String, dynamic> json) => FilesModel(
        confirmation: _parseList(json["confirmation"]),
        proofOfDelivery: _parseList(json["proof_of_delivery"]),
        fuel: _parseList(json["fuel"]),
        lumper: _parseList(json["lumper"]),
        invoiced: _parseList(json["invoiced"]), //todo: check if this is correct
        others: _parseList(json["others"]),
      );

  Map<String, dynamic> toJson() => {
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
}

List<Confirmationmodel> _parseList(dynamic jsonList) {
  return jsonList == null
      ? []
      : List<Confirmationmodel>.from(
          jsonList.map((x) => Confirmationmodel.fromJson(x)),
        );
}

class Confirmationmodel extends Confirmation {
  const Confirmationmodel({
    super.fileType,
    super.name,
    super.url,
    super.uploadedBy,
    super.createdAt,
    super.approvedBy,
    super.updatedAt,
    super.deletedBy,
    super.deletedAt,
  });

  factory Confirmationmodel.fromJson(Map<String, dynamic> json) =>
      Confirmationmodel(
        fileType: _str(json["file_type"]),
        name: _str(json["name"]),
        url: _str(json["url"]),
        uploadedBy: _str(json["uploadedBy"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
        approvedBy: json["approvedBy"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"].toString()),
        deletedBy: json["deletedBy"],
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
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
}

class ShipmentChargeModel extends ShipmentCharge {
  const ShipmentChargeModel({
    super.id,
    super.type,
    super.useForPay,
    super.revenue,
  });

  factory ShipmentChargeModel.fromJson(Map<String, dynamic> json) =>
      ShipmentChargeModel(
        id: json["id"],
        type: _str(json["type"]),
        useForPay: _str(json["use_for_pay"]),
        revenue: _str(json["revenue"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "use_for_pay": useForPay,
        "revenue": revenue,
      };
}

class ShipmentStopModel extends ShipmentStop {
  const ShipmentStopModel({
    super.id,
    super.companyName,
    super.stopType,
    super.weight,
    super.goods,
    super.dateTime,
    super.contactDetails,
    super.info,
    super.address,
  });

  factory ShipmentStopModel.fromJson(Map<String, dynamic> json) =>
      ShipmentStopModel(
        id: json["id"],
        companyName: _str(json["company_name"]),
        stopType: _str(json["stop_type"]),
        weight: _strOrNull(json["weight"]),
        goods: _strOrNull(json["goods"]),
        dateTime: json["transit_date_time"] == null
            ? null
            : DateTime.tryParse(json["transit_date_time"].toString()),
        contactDetails: _str(json["contact_details"]),
        info: _str(json["info"]),
        address: _str(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "stop_type": stopType,
        "weight": weight,
        "goods": goods,
        "transit_date_time": dateTime?.toIso8601String(),
        "contact_details": contactDetails,
        "info": info,
        "address": address,
      };
}
