import 'package:equatable/equatable.dart';

class RequestedDocumentEntity extends Equatable {
  final int? id;
  final int? folderId;
  final String? modelType;
  final String? fileType;
  final String? fileName;
  final bool? hasExpiration;
  final bool? optional;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int? title;
  final int? value;
  final bool? isUploaded;
  final String? size;
  final String? icon;
  final bool? hollow;
  final String? color;

  const RequestedDocumentEntity({
    this.id,
    this.folderId,
    this.modelType,
    this.fileType,
    this.fileName,
    this.hasExpiration,
    this.optional,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.title,
    this.value,
    this.isUploaded,
    this.size,
    this.icon,
    this.hollow,
    this.color,
  });

  factory RequestedDocumentEntity.fromJson(Map<String, dynamic> json) =>
      RequestedDocumentEntity(
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

  @override
  List<Object?> get props => [
        id,
        folderId,
        modelType,
        fileType,
        fileName,
        hasExpiration,
        optional,
        createdAt,
        updatedAt,
        deletedAt,
        title,
        value,
        isUploaded,
        size,
        icon,
        hollow,
        color,
      ];
}
