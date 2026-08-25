import 'package:ts_admin/app/modules/hr/domain/entities/requested_document_entity.dart';

class RequestedDocumentModel extends RequestedDocumentEntity {
  const RequestedDocumentModel({
    super.id,
    super.folderId,
    super.modelType,
    super.fileType,
    super.fileName,
    super.hasExpiration,
    super.optional,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.title,
    super.value,
    super.isUploaded,
    super.size,
    super.icon,
    super.hollow,
    super.color,
  });

  factory RequestedDocumentModel.fromJson(Map<String, dynamic> json) =>
      RequestedDocumentModel(
        id: json["id"],
        folderId: json["folder_id"],
        modelType: json["model_type"],
        fileType: json["file_type"],
        fileName: json["file_name"],
        hasExpiration: json["has_expiration"],
        optional: json["optional"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        title: json["title"],
        value: json["value"],
        isUploaded: json["is_uploaded"],
        size: json["size"],
        icon: json["icon"],
        hollow: json["hollow"],
        color: json["color"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "folder_id": folderId,
        "model_type": modelType,
        "file_type": fileType,
        "file_name": fileName,
        "has_expiration": hasExpiration,
        "optional": optional,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "title": title,
        "value": value,
        "is_uploaded": isUploaded,
        "size": size,
        "icon": icon,
        "hollow": hollow,
        "color": color,
      };
}
