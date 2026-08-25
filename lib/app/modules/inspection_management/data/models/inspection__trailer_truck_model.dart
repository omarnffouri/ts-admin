// To parse this JSON data, do
//
//     final pendingDriverModel = pendingDriverModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/pending_truck_entity.dart';

InspectionTrailerTruckModel pendingDriverModelFromJson(String str) =>
    InspectionTrailerTruckModel.fromJson(json.decode(str));

String pendingDriverModelToJson(InspectionTrailerTruckModel data) =>
    json.encode(data.toJson());

class InspectionTrailerTruckModel extends InspectionTrailerTruckEntity {
  InspectionTrailerTruckModel({
    super.id,
    super.userId,
    super.requestBy,
    super.inspectedBy,
    super.trailerLocation,
    super.status,
    super.truckIdentifier,
    super.createdAt,
    super.updatedAt,
  });

  factory InspectionTrailerTruckModel.fromJson(Map<String, dynamic> json) =>
      InspectionTrailerTruckModel(
        id: json["id"].toString(),
        userId: json["user_id"].toString(),
        requestBy: json["requested_by"],
        inspectedBy: json["inspected_by"],
        trailerLocation: json["trailer_location"],
        status: json["status"],
        truckIdentifier: json["identifier"].toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "requested_by": requestBy,
        "inspected_by": inspectedBy,
        "trailer_location": trailerLocation,
        "status": status,
        "identifier": truckIdentifier.toString(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
