import '../../domain/entities/inspection_entity.dart';

// ignore: must_be_immutable
class InspectionModel extends InspectionEntity {
  InspectionModel({
    super.id,
    super.type,
    super.checks,
    super.isSelectedAll,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) =>
      InspectionModel(
        id: json["id"],
        type: json["type"],
        checks: json["checks"] == null
            ? []
            : List<Check>.from(json["checks"]!.map((x) => Check.fromJson(x))),
        isSelectedAll: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "checks": checks == null
            ? []
            : List<dynamic>.from(checks!.map((x) => x.toEntity())),
      };
}

// ignore: must_be_immutable
class Check extends CheckEntity {
  Check({
    super.id,
    super.categoryId,
    super.name,
    super.createdAt,
    super.updatedAt,
    super.title,
    super.value,
    super.isPassed,
  });

  factory Check.fromJson(Map<String, dynamic> json) => Check(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        title: json["title"],
        value: json["value"],
        isPassed: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "title": title,
        "value": value,
      };
}
