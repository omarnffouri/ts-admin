import 'package:ts_admin/app/modules/hr/data/models/application_file_model.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/document_request_entity.dart';

class DocumentRequestModel extends DocumentRequestEntity {
  const DocumentRequestModel({
    super.id,
    super.modelId,
    super.modelType,
    super.message,
    super.collectionName,
    super.collectionType,
    super.createdAt,
    super.updatedAt,
    super.expirationDate,
    super.isUploaded,
    super.hasExpiration,
    super.file,
  });

  factory DocumentRequestModel.fromJson(Map<String, dynamic> json) =>
      DocumentRequestModel(
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
            : ApplicationFileModel.fromJson(json["file"]),
      );

  @override
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
}
