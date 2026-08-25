import '../../domain/entities/create_dropdown_entity.dart';

class CreateDropdownModel extends CreateDropdownEntity {
  const CreateDropdownModel({
    super.types,
    super.states,
    super.lessors,
  });

  factory CreateDropdownModel.fromJson(Map<String, dynamic> json) =>
      CreateDropdownModel(
        types: json["types"] == null
            ? []
            : List<ItemModel>.from(
                json["types"]!.map((x) => ItemModel.fromJson(x))),
        states: json["states"] == null
            ? []
            : List<ItemModel>.from(
                json["states"]!.map((x) => ItemModel.fromJson(x))),
        lessors: json["lessors"] == null
            ? []
            : List<ItemModel>.from(
                json["lessors"]!.map((x) => ItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "types": types == null
            ? []
            : List<dynamic>.from(types!.map((x) => x.toEntity())),
        "states": states == null
            ? []
            : List<dynamic>.from(states!.map((x) => x.toEntity())),
        "lessors": lessors == null
            ? []
            : List<dynamic>.from(lessors!.map((x) => x.toEntity())),
      };
}

class ItemModel extends Item {
  const ItemModel({
    super.id,
    super.name,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"].toString(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
