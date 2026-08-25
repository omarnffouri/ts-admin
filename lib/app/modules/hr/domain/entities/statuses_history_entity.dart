import 'package:equatable/equatable.dart';

class StatusesHistoryEntity extends Equatable {
  final int? id;
  final String? name;
  final String? reason;
  final String? modelType;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StatusesHistoryEntity({
    this.id,
    this.name,
    this.reason,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  factory StatusesHistoryEntity.fromJson(Map<String, dynamic> json) =>
      StatusesHistoryEntity(
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        reason,
        modelType,
        modelId,
        createdAt,
        updatedAt,
      ];
}
