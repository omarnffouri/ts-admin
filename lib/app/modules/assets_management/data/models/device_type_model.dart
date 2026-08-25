import '../../domain/entities/device_type_entity.dart';

class DeviceTypeModel extends DeviceTypeEntity {
  const DeviceTypeModel({
    super.id,
    super.code,
    super.type,
    super.createdAt,
    super.updatedAt,
    super.title,
    super.value,
  });

  factory DeviceTypeModel.fromJson(Map<String, dynamic> json) =>
      DeviceTypeModel(
        id: json["id"],
        code: json["code"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "title": title,
        "value": value,
      };
}
