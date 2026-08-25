// To parse this JSON data, do
//
//     final shipmentDropDownsEntity = shipmentDropDownsEntityFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_dropdowns_entity.dart';

ShipmentDropdownsPlayloadModel shipmentDropdownsPlayloadModelFromJson(
        String str) =>
    ShipmentDropdownsPlayloadModel.fromJson(json.decode(str));

String shipmentDropdownsPlayloadModelToJson(
        ShipmentDropdownsPlayloadModel data) =>
    json.encode(data.toJson());

class ShipmentDropdownsPlayloadModel extends ShipmentDropdownsPlayloadEntity {
  const ShipmentDropdownsPlayloadModel({
    super.types,
    super.customers,
    super.locations,
    super.drivers,
    super.trailers,
    super.trucks,
  });

  factory ShipmentDropdownsPlayloadModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDropdownsPlayloadModel(
        types: json["types"] == null
            ? []
            : List<CSTypeDropDownModel>.from(
                json["types"]!.map((x) => CSTypeDropDownModel.fromJson(x))),
        customers: json["customers"] == null
            ? []
            : List<CSCustomerDropdownModel>.from(json["customers"]!
                .map((x) => CSCustomerDropdownModel.fromJson(x))),
        locations: json["locations"] == null
            ? []
            : List<CSLocationDropdownModel>.from(json["locations"]!
                .map((x) => CSLocationDropdownModel.fromJson(x))),
        drivers: json["drivers"] == null
            ? []
            : List<CSCustomerDropdownModel>.from(json["drivers"]!
                .map((x) => CSCustomerDropdownModel.fromJson(x))),
        trailers: json["trailers"] == null
            ? []
            : List<CSTrailerDropdownModel>.from(json["trailers"]!
                .map((x) => CSTrailerDropdownModel.fromJson(x))),
        trucks: json["trucks"] == null
            ? []
            : List<CSTruckDropdownModel>.from(
                json["trucks"]!.map((x) => CSTruckDropdownModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "types": types == null
            ? []
            : List<dynamic>.from(types!.map((x) => x.toJson())),
        "customers": customers == null
            ? []
            : List<dynamic>.from(customers!.map((x) => x.toJson())),
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toJson())),
        "trailers": trailers == null
            ? []
            : List<dynamic>.from(trailers!.map((x) => x.toJson())),
        "trucks": trucks == null
            ? []
            : List<dynamic>.from(trucks!.map((x) => x.toJson())),
      };
}

class CSCustomerDropdownModel extends CSCustomerDropdownEntity {
  const CSCustomerDropdownModel({
    super.id,
    super.name,
    super.truckId,
  });

  factory CSCustomerDropdownModel.fromJson(Map<String, dynamic> json) =>
      CSCustomerDropdownModel(
        id: json["id"],
        name: json["name"],
        truckId: json["truck_id"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "truck_id": truckId,
      };
}

class CSLocationDropdownModel extends CSLocationDropdownEntity {
  const CSLocationDropdownModel({
    super.address,
    super.companyName,
    super.longitude,
    super.latitude,
    super.id,
    super.city,
    super.stateId,
    super.stateName,
    super.state,
  });

  factory CSLocationDropdownModel.fromJson(Map<String, dynamic> json) =>
      CSLocationDropdownModel(
        address: json["address"],
        companyName: json["company_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        id: json["id"],
        city: json["city"],
        stateId: json["state_id"],
        stateName: json["state_name"],
        state: json["state"] == null
            ? null
            : CSStateDropdownModel.fromJson(json["state"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "address": address,
        "company_name": companyName,
        "longitude": longitude,
        "latitude": latitude,
        "id": id,
        "city": city,
        "state_id": stateId,
        "state_name": stateName,
        "state": state?.toJson(),
      };
}

class CSStateDropdownModel extends CSStateDropdownEntity {
  const CSStateDropdownModel({
    super.id,
    super.name,
    super.title,
    super.value,
  });

  factory CSStateDropdownModel.fromJson(Map<String, dynamic> json) =>
      CSStateDropdownModel(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        value: json["value"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "value": value,
      };
}

class CSTrailerDropdownModel extends CSTrailerDropdownEntity {
  const CSTrailerDropdownModel({
    super.id,
    super.identifier,
  });

  factory CSTrailerDropdownModel.fromJson(Map<String, dynamic> json) =>
      CSTrailerDropdownModel(
        id: json["id"],
        identifier: json["identifier"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
      };
}

class CSTruckDropdownModel extends CSTruckDropdownEntity {
  const CSTruckDropdownModel({
    super.id,
    super.identifier,
    super.name,
  });

  factory CSTruckDropdownModel.fromJson(Map<String, dynamic> json) =>
      CSTruckDropdownModel(
        id: json["id"],
        name: json["name"],
        identifier: json["identifier"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "identifier": identifier,
      };
}

class CSTypeDropDownModel extends CSTypeDropDownEntity {
  const CSTypeDropDownModel({
    super.text,
    super.code,
    super.title,
    super.value,
  });

  factory CSTypeDropDownModel.fromJson(Map<String, dynamic> json) =>
      CSTypeDropDownModel(
        text: json["text"] == null
            ? null
            : CSTextDropdownModel.fromJson(json["text"]),
        code: json["code"],
        title: json["title"],
        value: json["value"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "text": text?.toJson(),
        "code": code,
        "title": title,
        "value": value,
      };
}

class CSTextDropdownModel extends CSTextDropdownEntity {
  const CSTextDropdownModel({
    super.en,
  });

  factory CSTextDropdownModel.fromJson(Map<String, dynamic> json) =>
      CSTextDropdownModel(
        en: json["en"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "en": en,
      };
}
