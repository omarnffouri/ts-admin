import 'package:ts_admin/app/modules/chat_detail/domain/entities/chat_info_tags_entity.dart';

class ChatInfoTagsModel extends ChatInfoTagsEntity {
  const ChatInfoTagsModel({
    required super.driver,
    required super.shipment,
    required super.truck,
  });

  factory ChatInfoTagsModel.fromJson(Map<String, dynamic> json) =>
      ChatInfoTagsModel(
        driver: json["driver"] == null
            ? []
            : List<DriverInfoTagModel>.from(
                json["driver"]!.map((x) => DriverInfoTagModel.fromJson(x))),
        shipment: json["shipment"] == null
            ? []
            : List<ShipmentInfoTagModel>.from(
                json["shipment"]!.map((x) => ShipmentInfoTagModel.fromJson(x))),
        truck: json["truck"] == null
            ? []
            : List<TruckInfoTagModel>.from(
                json["truck"]!.map((x) => TruckInfoTagModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "driver": List<dynamic>.from(driver.map((x) => x.toJson())),
        "shipment": List<dynamic>.from(shipment.map((x) => x.toJson())),
        "truck": List<dynamic>.from(truck.map((x) => x.toJson())),
      };
}

class DriverInfoTagModel extends DriverInfoTagEntity {
  const DriverInfoTagModel({
    super.id,
    super.name,
    super.userId,
    super.phone,
    super.ssn,
    super.image,
    super.designation,
  });

  factory DriverInfoTagModel.fromJson(Map<String, dynamic> json) =>
      DriverInfoTagModel(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        phone: json["phone"],
        ssn: json["ss_no"],
        image: json["image"],
        designation: json["designation"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "phone": phone,
        "ss_no": ssn,
        "image": image,
        "designation": designation,
      };
}

class ShipmentInfoTagModel extends ShipmentInfoTagEntity {
  const ShipmentInfoTagModel({
    super.id,
    super.shipmentNumber,
    super.trailerId,
    super.locations,
    super.trucks,
    super.drivers,
  });

  factory ShipmentInfoTagModel.fromJson(Map<String, dynamic> json) =>
      ShipmentInfoTagModel(
        id: json["id"],
        shipmentNumber: json["shipment_number"],
        trailerId: json["trailer_id"],
        locations: json["locations"] == null
            ? []
            : List<LocationInfoTagModel>.from(json["locations"]!
                .map((x) => LocationInfoTagModel.fromJson(x))),
        trucks: json["trucks"] == null
            ? []
            : List<TruckInfoTagModel>.from(
                json["trucks"]!.map((x) => TruckInfoTagModel.fromJson(x))),
        drivers: json["drivers"] == null
            ? []
            : List<DriverInfoTagModel>.from(
                json["drivers"]!.map((x) => DriverInfoTagModel.fromJson(x))),
      );

  @override
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
}

class LocationInfoTagModel extends LocationInfoTagEntity {
  const LocationInfoTagModel({
    super.id,
    super.shipmentId,
    super.city,
    super.state,
    super.country,
    super.address,
    super.companyName,
    super.type,
  });

  factory LocationInfoTagModel.fromJson(Map<String, dynamic> json) =>
      LocationInfoTagModel(
        id: json["id"],
        shipmentId: json["shipment_id"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        address: json["address"],
        companyName: json["company_name"],
        type: json["type"],
      );

  @override
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
}

class TruckInfoTagModel extends TruckInfoTagEntity {
  const TruckInfoTagModel({
    super.id,
    super.identifier,
    super.name,
    super.type,
    super.makingYear,
    super.vin,
    super.maker,
    super.licencePlateNumber,
    super.drivers,
  });

  factory TruckInfoTagModel.fromJson(Map<String, dynamic> json) =>
      TruckInfoTagModel(
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
            : List<DriverInfoTagModel>.from(
                json["drivers"]!.map((x) => DriverInfoTagModel.fromJson(x))),
      );

  @override
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
}
