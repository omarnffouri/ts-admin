import 'package:equatable/equatable.dart';

class ChatInfoTagsEntity extends Equatable {
  final List<DriverInfoTagEntity> driver;
  final List<ShipmentInfoTagEntity> shipment;
  final List<TruckInfoTagEntity> truck;

  const ChatInfoTagsEntity({
    required this.driver,
    required this.shipment,
    required this.truck,
  });

  factory ChatInfoTagsEntity.fromJson(Map<String, dynamic> json) =>
      ChatInfoTagsEntity(
        driver: json["driver"] == null
            ? []
            : List<DriverInfoTagEntity>.from(
                json["driver"]!.map((x) => DriverInfoTagEntity.fromJson(x))),
        shipment: json["shipment"] == null
            ? []
            : List<ShipmentInfoTagEntity>.from(json["shipment"]!
                .map((x) => ShipmentInfoTagEntity.fromJson(x))),
        truck: json["truck"] == null
            ? []
            : List<TruckInfoTagEntity>.from(
                json["truck"]!.map((x) => TruckInfoTagEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "driver": List<dynamic>.from(driver.map((x) => x.toJson())),
        "shipment": List<dynamic>.from(shipment.map((x) => x.toJson())),
        "truck": List<dynamic>.from(truck.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        driver,
        shipment,
        truck,
      ];
}

class DriverInfoTagEntity extends Equatable {
  final int? id;
  final String? name;
  final int? userId;
  final String? phone;
  final String? ssn;
  final String? image;
  final String? designation;

  const DriverInfoTagEntity({
    this.id,
    this.name,
    this.userId,
    this.phone,
    this.ssn,
    this.image,
    this.designation,
  });

  factory DriverInfoTagEntity.fromJson(Map<String, dynamic> json) =>
      DriverInfoTagEntity(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        phone: json["phone"],
        ssn: json["ss_no"],
        image: json["image"],
        designation: json["designation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "phone": phone,
        "ss_no": ssn,
        "image": image,
        "designation": designation,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        userId,
        phone,
        ssn,
        image,
        designation,
      ];
}

class ShipmentInfoTagEntity extends Equatable {
  final int? id;
  final String? shipmentNumber;
  final String? trailerId;
  final List<LocationInfoTagEntity>? locations;
  final List<TruckInfoTagEntity>? trucks;
  final List<DriverInfoTagEntity>? drivers;

  const ShipmentInfoTagEntity({
    this.id,
    this.shipmentNumber,
    this.trailerId,
    this.locations,
    this.trucks,
    this.drivers,
  });

  factory ShipmentInfoTagEntity.fromJson(Map<String, dynamic> json) =>
      ShipmentInfoTagEntity(
        id: json["id"],
        shipmentNumber: json["shipment_number"],
        trailerId: json["trailer_id"],
        locations: json["locations"] == null
            ? []
            : List<LocationInfoTagEntity>.from(json["locations"]!
                .map((x) => LocationInfoTagEntity.fromJson(x))),
        trucks: json["trucks"] == null
            ? []
            : List<TruckInfoTagEntity>.from(
                json["trucks"]!.map((x) => TruckInfoTagEntity.fromJson(x))),
        drivers: json["drivers"] == null
            ? []
            : List<DriverInfoTagEntity>.from(
                json["drivers"]!.map((x) => DriverInfoTagEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shipment_number": shipmentNumber,
        "trailer_id": trailerId,
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "trucks": trucks == null
            ? []
            : List<dynamic>.from(trucks!.map((x) => x.toJson())),
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        id,
        shipmentNumber,
        trailerId,
        locations,
        trucks,
        drivers,
      ];
}

class LocationInfoTagEntity extends Equatable {
  final int? id;
  final int? shipmentId;
  final String? city;
  final String? state;
  final String? country;
  final String? address;
  final String? companyName;
  final String? type;

  const LocationInfoTagEntity({
    this.id,
    this.shipmentId,
    this.city,
    this.state,
    this.country,
    this.address,
    this.companyName,
    this.type,
  });

  factory LocationInfoTagEntity.fromJson(Map<String, dynamic> json) =>
      LocationInfoTagEntity(
        id: json["id"],
        shipmentId: json["shipment_id"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        address: json["address"],
        companyName: json["company_name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shipment_id": shipmentId,
        "city": city,
        "state": state,
        "country": country,
        "address": address,
        "company_name": companyName,
        "type": type,
      };

  @override
  List<Object?> get props => [
        id,
        shipmentId,
        city,
        state,
        country,
        address,
        companyName,
        type,
      ];
}

class TruckInfoTagEntity extends Equatable {
  final int? id;
  final int? identifier;
  final String? name;
  final String? type;
  final String? makingYear;
  final String? vin;
  final String? maker;
  final String? licencePlateNumber;
  final List<DriverInfoTagEntity>? drivers;

  const TruckInfoTagEntity({
    this.id,
    this.identifier,
    this.name,
    this.type,
    this.makingYear,
    this.vin,
    this.maker,
    this.licencePlateNumber,
    this.drivers,
  });

  factory TruckInfoTagEntity.fromJson(Map<String, dynamic> json) =>
      TruckInfoTagEntity(
        id: json["id"],
        identifier: json["identifier"],
        name: json["name"],
        type: json["type"],
        makingYear: json["making_year"],
        vin: json["vin"],
        maker: json["maker"],
        licencePlateNumber: json["licence_plate_number"],
        drivers: json["drivers"] == null
            ? []
            : List<DriverInfoTagEntity>.from(
                json["drivers"]!.map((x) => DriverInfoTagEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "name": name,
        "type": type,
        "making_year": makingYear,
        "vin": vin,
        "maker": maker,
        "licence_plate_number": licencePlateNumber,
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        id,
        identifier,
        name,
        type,
        makingYear,
        vin,
        maker,
        licencePlateNumber,
        drivers,
      ];
}
