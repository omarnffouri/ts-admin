// To parse this JSON data, do
//
//     final shipmentDropDownsEntity = shipmentDropDownsEntityFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:equatable/equatable.dart';

ShipmentDropdownsPlayloadEntity shipmentDropdownsPlayloadEntityFromJson(
        String str) =>
    ShipmentDropdownsPlayloadEntity.fromJson(json.decode(str));

String shipmentDropdownsPlayloadEntityToJson(
        ShipmentDropdownsPlayloadEntity data) =>
    json.encode(data.toJson());

class ShipmentDropdownsPlayloadEntity extends Equatable {
  final List<CSTypeDropDownEntity>? types;
  final List<CSCustomerDropdownEntity>? customers;
  final List<CSLocationDropdownEntity>? locations;
  final List<CSCustomerDropdownEntity>? drivers;
  final List<CSTrailerDropdownEntity>? trailers;
  final List<CSTruckDropdownEntity>? trucks;

  const ShipmentDropdownsPlayloadEntity({
    this.types,
    this.customers,
    this.locations,
    this.drivers,
    this.trailers,
    this.trucks,
  });

  factory ShipmentDropdownsPlayloadEntity.fromJson(Map<String, dynamic> json) =>
      ShipmentDropdownsPlayloadEntity(
        types: json["types"] == null
            ? []
            : List<CSTypeDropDownEntity>.from(
                json["types"]!.map((x) => CSTypeDropDownEntity.fromJson(x))),
        customers: json["customers"] == null
            ? []
            : List<CSCustomerDropdownEntity>.from(json["customers"]!
                .map((x) => CSCustomerDropdownEntity.fromJson(x))),
        locations: json["locations"] == null
            ? []
            : List<CSLocationDropdownEntity>.from(json["locations"]!
                .map((x) => CSLocationDropdownEntity.fromJson(x))),
        drivers: json["drivers"] == null
            ? []
            : List<CSCustomerDropdownEntity>.from(json["drivers"]!
                .map((x) => CSCustomerDropdownEntity.fromJson(x))),
        trailers: json["trailers"] == null
            ? []
            : List<CSTrailerDropdownEntity>.from(json["trailers"]!
                .map((x) => CSTrailerDropdownEntity.fromJson(x))),
        trucks: json["trucks"] == null
            ? []
            : List<CSTruckDropdownEntity>.from(
                json["trucks"]!.map((x) => CSTruckDropdownEntity.fromJson(x))),
      );

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

  @override
  List<Object?> get props => [
        types,
        customers,
        locations,
        drivers,
        trailers,
        trucks,
      ];
}

class CSCustomerDropdownEntity extends Equatable {
  final int? id;
  final int? truckId;
  final String? name;

  const CSCustomerDropdownEntity({
    this.id,
    this.name,
    this.truckId,
  });

  factory CSCustomerDropdownEntity.fromJson(Map<String, dynamic> json) =>
      CSCustomerDropdownEntity(
        id: json["id"],
        name: json["name"],
        truckId: json["truck_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "truck_id": truckId,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        truckId,
      ];
}

class CSLocationDropdownEntity extends Equatable {
  final String? address;
  final String? companyName;
  final String? longitude;
  final String? latitude;
  final int? id;
  final String? city;
  final int? stateId;
  final String? stateName;
  final CSStateDropdownEntity? state;

  const CSLocationDropdownEntity({
    this.address,
    this.companyName,
    this.longitude,
    this.latitude,
    this.id,
    this.city,
    this.stateId,
    this.stateName,
    this.state,
  });

  factory CSLocationDropdownEntity.fromJson(Map<String, dynamic> json) =>
      CSLocationDropdownEntity(
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
            : CSStateDropdownEntity.fromJson(json["state"]),
      );

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

  @override
  List<Object?> get props => [
        address,
        companyName,
        longitude,
        latitude,
        id,
        city,
        stateId,
        stateName,
        state,
      ];
}

class CSStateDropdownEntity extends Equatable {
  final int? id;
  final String? name;
  final String? title;
  final int? value;

  const CSStateDropdownEntity({
    this.id,
    this.name,
    this.title,
    this.value,
  });

  factory CSStateDropdownEntity.fromJson(Map<String, dynamic> json) =>
      CSStateDropdownEntity(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "value": value,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        title,
        value,
      ];
}

class CSTrailerDropdownEntity extends Equatable {
  final int? id;
  final int? identifier;

  const CSTrailerDropdownEntity({
    this.id,
    this.identifier,
  });

  factory CSTrailerDropdownEntity.fromJson(Map<String, dynamic> json) =>
      CSTrailerDropdownEntity(
        id: json["id"],
        identifier: json["identifier"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
      };

  @override
  List<Object?> get props => [
        id,
        identifier,
      ];
}

class CSTruckDropdownEntity extends Equatable {
  final int? id;
  final String? name;
  final int? identifier;

  const CSTruckDropdownEntity({
    this.id,
    this.identifier,
    this.name,
  });

  factory CSTruckDropdownEntity.fromJson(Map<String, dynamic> json) =>
      CSTruckDropdownEntity(
        id: json["id"],
        name: json["name"],
        identifier: json["identifier"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        identifier,
        name,
      ];
}

class CSTypeDropDownEntity extends Equatable {
  final CSTextDropdownEntity? text;
  final String? code;
  final String? title;
  final String? value;

  const CSTypeDropDownEntity({
    this.text,
    this.code,
    this.title,
    this.value,
  });

  factory CSTypeDropDownEntity.fromJson(Map<String, dynamic> json) =>
      CSTypeDropDownEntity(
        text: json["text"] == null
            ? null
            : CSTextDropdownEntity.fromJson(json["text"]),
        code: json["code"],
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text?.toJson(),
        "code": code,
        "title": title,
        "value": value,
      };

  @override
  List<Object?> get props => [
        text,
        code,
        title,
        value,
      ];
}

class CSTextDropdownEntity extends Equatable {
  final String? en;

  const CSTextDropdownEntity({
    this.en,
  });

  factory CSTextDropdownEntity.fromJson(Map<String, dynamic> json) =>
      CSTextDropdownEntity(
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
      };

  @override
  List<Object?> get props => [
        en,
      ];
}
