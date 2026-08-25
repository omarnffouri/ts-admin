import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_file_entity.dart';

class DocumentRequestEntity extends Equatable {
  final int? id;
  final int? modelId;
  final String? modelType;
  final String? message;
  final String? collectionName;
  final String? collectionType;
  final String? createdAt;
  final String? updatedAt;
  final String? expirationDate;
  final bool? isUploaded;
  final bool? hasExpiration;
  final ApplicationFileEntity? file;

  const DocumentRequestEntity({
    this.id,
    this.modelId,
    this.modelType,
    this.message,
    this.collectionName,
    this.collectionType,
    this.createdAt,
    this.updatedAt,
    this.expirationDate,
    this.isUploaded,
    this.hasExpiration,
    this.file,
  });

  factory DocumentRequestEntity.fromJson(Map<String, dynamic> json) =>
      DocumentRequestEntity(
        id: json["id"],
        modelId: json["model_id"],
        modelType: json["model_type"],
        message: json["message"],
        collectionName: json["collection_name"],
        collectionType: json["collection_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        expirationDate: json["expiration_date"],
        isUploaded: json["is_uploaded"],
        hasExpiration: json["has_expiration"],
        file: json["file"] == null
            ? null
            : ApplicationFileEntity.fromJson(json["file"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "model_id": modelId,
        "model_type": modelType,
        "message": message,
        "collection_name": collectionName,
        "collection_type": collectionType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "expiration_date": expirationDate,
        "is_uploaded": isUploaded,
        "has_expiration": hasExpiration,
        "file": file?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        modelId,
        modelType,
        message,
        collectionName,
        collectionType,
        createdAt,
        updatedAt,
        expirationDate,
        isUploaded,
        hasExpiration,
        file,
      ];
}
