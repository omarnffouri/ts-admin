import 'package:ts_admin/app/modules/hr/domain/entities/application_file_entity.dart';

class ApplicationFileModel extends ApplicationFileEntity {
  ApplicationFileModel({
    super.id,
    super.fileType,
    super.name,
    super.fileName,
    super.fileNameExt,
    super.url,
    super.mimeType,
    super.fileIcon,
    super.uploadedBy,
    super.createdAt,
    super.approvedBy,
    super.updatedAt,
    super.deletedBy,
    super.deletedAt,
  });

  factory ApplicationFileModel.fromJson(Map<String, dynamic> json) =>
      ApplicationFileModel(
        id: json["id"],
        fileType: json["file_type"],
        name: json["name"],
        fileName: json["file_name"],
        fileNameExt: json["file_name_ext"],
        url: json["url"],
        mimeType: json["mime_type"],
        fileIcon: json["file_icon"],
        uploadedBy: json["uploadedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        approvedBy: json["approvedBy"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedBy: json["deletedBy"],
        deletedAt: json["deletedAt"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "file_type": fileType,
        "name": name,
        "file_name": fileName,
        "file_name_ext": fileNameExt,
        "url": url,
        "mime_type": mimeType,
        "file_icon": fileIcon,
        "uploadedBy": uploadedBy,
        "createdAt": createdAt?.toIso8601String(),
        "approvedBy": approvedBy,
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedBy": deletedBy,
        "deletedAt": deletedAt,
      };
}
