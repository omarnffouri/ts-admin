import '../../domain/entities/inspection_dropdown_entity.dart';

class InspectionDropdownModel extends InspectionDropdownEntity {
  const InspectionDropdownModel({
    super.drivers,
    super.trailers,
    super.trucks,
  });

  factory InspectionDropdownModel.fromJson(Map<String, dynamic> json) =>
      InspectionDropdownModel(
        drivers: json["drivers"] == null
            ? []
            : List<ItemModel>.from(
                json["drivers"]!.map((x) => ItemModel.fromJson(x))),
        trailers: json["trailers"] == null
            ? []
            : List<ItemModel>.from(
                json["trailers"]!.map((x) => ItemModel.fromJson(x))),
        trucks: json["trucks"] == null
            ? []
            : List<ItemModel>.from(
                json["trucks"]!.map((x) => ItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toEntity())),
        "trailers": trailers == null
            ? []
            : List<dynamic>.from(trailers!.map((x) => x.toEntity())),
        "trucks": trucks == null
            ? []
            : List<dynamic>.from(trucks!.map((x) => x.toEntity())),
      };
}

class ItemModel extends ItemEntity {
  const ItemModel({
    super.id,
    super.identifier,
    super.driverName,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"],
        identifier: json["identifier"],
        driverName: json["driver_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "driver_name": driverName,
      };
}
