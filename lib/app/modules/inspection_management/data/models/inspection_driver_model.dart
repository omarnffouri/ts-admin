// To parse this JSON data, do
//
//     final pendingDriverModel = pendingDriverModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/pending_driver_entity.dart';

InspectionDriverModel pendingDriverModelFromJson(String str) =>
    InspectionDriverModel.fromJson(json.decode(str));

String pendingDriverModelToJson(InspectionDriverModel data) =>
    json.encode(data.toJson());

class InspectionDriverModel extends InspectionDriverEntity {
  InspectionDriverModel({
    super.id,
    super.name,
    super.phone,
    super.requestBy,
    super.inspectedBy,
    super.status,
    super.truckIdentifier,
    super.createdAt,
    super.updatedAt,
  });

  factory InspectionDriverModel.fromJson(Map<String, dynamic> json) =>
      InspectionDriverModel(
        id: json["id"].toString(),
        name: json["driver"],
        // remove the space from phone number
        phone: json["phone"].toString().replaceAll(" ", ""),
        requestBy: json["requested_by"],
        inspectedBy: json["inspected_by"],
        status: json["status"],
        truckIdentifier: json["truck_identifier"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver": name,
        "phone": phone,
        "requested_by": requestBy,
        "inspected_by": inspectedBy,
        "status": status,
        "truck_identifier": truckIdentifier,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
