import '../../domain/entities/teams_entity.dart';

class TeamsModel extends TeamsEntity {
  const TeamsModel({
    super.id,
    super.name,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.category,
    super.title,
    super.value,
  });

  factory TeamsModel.fromJson(Map<String, dynamic> json) => TeamsModel(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        category: json["category"],
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "category": category,
        "title": title,
        "value": value,
      };
}
