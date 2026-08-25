import 'dart:convert';

import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';

ResourceModel resourceModelFromJson(String str) =>
    ResourceModel.fromJson(json.decode(str));

String resourceModelToJson(ResourceModel data) => json.encode(data.toJson());

// ignore: must_be_immutable
class ResourceModel extends ResourceEntity {
  ResourceModel({
    super.id,
    super.userId,
    super.ownerId,
    super.isOwner,
    super.owner,
    super.shared,
    super.sharedWithUsers,
    super.resourceId,
    super.parentId,
    super.resourceName,
    super.resourceType,
    super.children,
    super.media,
    super.permission,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) => ResourceModel(
        id: json["id"],
        userId: json["user_id"],
        ownerId: json["owner_id"],
        isOwner: json["is_owner"],
        owner: json["owner"],
        shared: json["shared"],
        sharedWithUsers: json["shared_with_users"] == null
            ? []
            : List<SharedWithUserModel>.from(json["shared_with_users"]!
                .map((x) => SharedWithUserModel.fromJson(x))),
        resourceId: json["resource_id"],
        parentId: json["parent_id"],
        resourceName: json["resource_name"],
        resourceType: json["resource_type"],
        children: json["children"],
        media: json["media"] == null
            ? []
            : List<ResourceFileModel>.from(
                json["media"]!.map((x) => ResourceFileModel.fromJson(x))),
        permission: json["permission"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "owner_id": ownerId,
        "is_owner": isOwner,
        "owner": owner,
        "shared": shared,
        "shared_with_users": sharedWithUsers == null
            ? []
            : List<dynamic>.from(sharedWithUsers!.map((x) => x.toJson())),
        "resource_id": resourceId,
        "parent_id": parentId,
        "resource_name": resourceName,
        "resource_type": resourceType,
        "children": children,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "permission": permission,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
      };
}

class ResourceFileModel extends ResourceFileEntity {
  const ResourceFileModel({
    super.id,
    super.fileType,
    super.name,
    super.fileName,
    super.fileNameExt,
    super.url,
    super.mimeType,
    super.size,
    super.fileIcon,
    super.uploadedBy,
    super.createdAt,
    super.approvedBy,
    super.updatedAt,
  });

  factory ResourceFileModel.fromJson(Map<String, dynamic> json) =>
      ResourceFileModel(
        id: json["id"],
        fileType: json["file_type"],
        name: json["name"],
        fileName: json["file_name"],
        fileNameExt: json["file_name_ext"],
        url: json["url"],
        mimeType: json["mime_type"],
        size: json["size"],
        fileIcon: json["file_icon"],
        uploadedBy: json["uploadedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        approvedBy: json["approvedBy"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
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
        "size": size,
        "file_icon": fileIcon,
        "uploadedBy": uploadedBy,
        "createdAt": createdAt?.toIso8601String(),
        "approvedBy": approvedBy,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class SharedWithUserModel extends SharedWithUserEntity {
  const SharedWithUserModel({
    super.id,
    super.userId,
    super.name,
    super.permission,
    super.designation,
    super.image,
  });

  factory SharedWithUserModel.fromJson(Map<String, dynamic> json) =>
      SharedWithUserModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        permission: json["permission"],
        designation: json["designation"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "permission": permission,
        "designation": designation,
        "image": image,
      };
}
