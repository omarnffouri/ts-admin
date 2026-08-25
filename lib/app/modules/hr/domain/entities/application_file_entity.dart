import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class ApplicationFileEntity extends Equatable {
  final int? id;
  final String? fileType;
  final String? name;
  final String? fileName;
  final String? fileNameExt;
  final String? url;
  final String? mimeType;
  final String? fileIcon;
  final String? uploadedBy;
  final DateTime? createdAt;
  final dynamic approvedBy;
  final DateTime? updatedAt;
  final dynamic deletedBy;
  final String? deletedAt;

  final isDownloading = false.obs;
  final downloadProgress = (0.0).obs;
  final filePath = "".obs;

  ApplicationFileEntity({
    this.id,
    this.fileType,
    this.name,
    this.fileName,
    this.fileNameExt,
    this.url,
    this.mimeType,
    this.fileIcon,
    this.uploadedBy,
    this.createdAt,
    this.approvedBy,
    this.updatedAt,
    this.deletedBy,
    this.deletedAt,
  });

  factory ApplicationFileEntity.fromJson(Map<String, dynamic> json) =>
      ApplicationFileEntity(
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

  @override
  List<Object?> get props => [
        id,
        fileType,
        name,
        fileName,
        fileNameExt,
        url,
        mimeType,
        fileIcon,
        uploadedBy,
        createdAt,
        approvedBy,
        updatedAt,
        deletedBy,
        deletedAt,
      ];
}
