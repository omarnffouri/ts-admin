import 'package:ts_admin/app/modules/hr/domain/entities/statuses_history_entity.dart';

class StatusesHistoryModel extends StatusesHistoryEntity {
  const StatusesHistoryModel({
    super.id,
    super.name,
    super.reason,
    super.modelType,
    super.modelId,
    super.createdAt,
    super.updatedAt,
  });

  factory StatusesHistoryModel.fromJson(Map<String, dynamic> json) =>
      StatusesHistoryModel(
        id: json["id"],
        name: json["name"],
        reason: json["reason"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
