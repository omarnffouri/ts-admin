// To parse this JSON data, do
//
//     final shipmentModel = shipmentModelFromJson(jsonString);

import '../../domain/enitities/shipment_entity.dart';

class ShipmentModel extends ShipmentEntity {
  ShipmentModel({
    super.id,
    super.shipmentNumber,
    super.customerReference,
    super.bolNumber,
    super.trailerId,
    super.truckId,
    super.status,
    super.customer,
    super.type,
    super.revenue,
    super.drivers,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) => ShipmentModel(
        id: json["id"],
        shipmentNumber: json["shipment_number"],
        customerReference: json["customer_reference"],
        bolNumber: json["bol_number"],
        trailerId: json["trailer_id"],
        truckId: json["truck_id"],
        status: json["status"],
        customer: json["customer"],
        type: json["type"],
        revenue: json["revenue"],
        drivers: json["drivers"] == null ||
                (json["drivers"] is List && json["drivers"].isEmpty)
            ? []
            : List<DriverModel>.from(
                json["drivers"]!.map((x) => DriverModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shipment_number": shipmentNumber,
        "customer_reference": customerReference,
        "bol_number": bolNumber,
        "trailer_id": trailerId,
        "truck_id": truckId,
        "status": status,
        "customer": customer,
        "type": type,
        "revenue": revenue,
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toEntity())),
      };
}

class DriverModel extends Driver {
  const DriverModel({
    super.id,
    super.name,
    super.type,
    super.settlementStatus,
    super.category,
    super.truck,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json["id"],
        name: json["name"],
        type: json["trip_type"],
        settlementStatus: json["settlement_status"],
        category: json["category"],
        truck: json["truck"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "trip_type": type,
        "settlement_status": settlementStatus,
        "category": category,
        "truck": truck,
      };
}
