import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

ResourceEntity resourceEntityFromJson(String str) =>
    ResourceEntity.fromJson(json.decode(str));

String resourceEntityToJson(ResourceEntity data) => json.encode(data.toJson());

// ignore: must_be_immutable
class ResourceEntity extends Equatable {
  final int? id;
  int? userId;
  int? ownerId;
  bool? isOwner;
  String? owner;
  bool? shared;
  List<SharedWithUserEntity>? sharedWithUsers;
  int? resourceId;
  int? parentId;
  String? resourceName;
  String? resourceType;
  int? children;
  List<ResourceFileEntity>? media;
  String? permission;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ResourceEntity({
    this.id,
    this.userId,
    this.ownerId,
    this.isOwner,
    this.owner,
    this.shared,
    this.sharedWithUsers,
    this.resourceId,
    this.parentId,
    this.resourceName,
    this.resourceType,
    this.children,
    this.media,
    this.permission,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ResourceEntity.fromJson(Map<String, dynamic> json) => ResourceEntity(
        id: json["id"],
        userId: json["user_id"],
        ownerId: json["owner_id"],
        isOwner: json["is_owner"],
        owner: json["owner"],
        shared: json["shared"],
        sharedWithUsers: json["shared_with_users"] == null
            ? []
            : List<SharedWithUserEntity>.from(json["shared_with_users"]!
                .map((x) => SharedWithUserEntity.fromJson(x))),
        resourceId: json["resource_id"],
        parentId: json["parent_id"],
        resourceName: json["resource_name"],
        resourceType: json["resource_type"],
        children: json["children"],
        media: json["media"] == null
            ? []
            : List<ResourceFileEntity>.from(
                json["media"]!.map((x) => ResourceFileEntity.fromJson(x))),
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

  @override
  List<Object?> get props => [
        id,
        userId,
        ownerId,
        isOwner,
        owner,
        shared,
        sharedWithUsers,
        resourceId,
        parentId,
        resourceName,
        resourceType,
        children,
        media,
        permission,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  //
  //
  /// function to update resource data
  updateResourceDetails(ResourceEntity resource) {
    if (id != resource.id && resource.id != null) {
      return;
    }
    userId = resource.userId ?? userId;
    ownerId = resource.ownerId ?? ownerId;
    isOwner = resource.isOwner ?? isOwner;
    owner = resource.owner ?? owner;
    shared = resource.shared ?? shared;
    sharedWithUsers = resource.sharedWithUsers ?? sharedWithUsers;
    resourceId = resource.resourceId ?? resourceId;
    parentId = resource.parentId ?? parentId;
    resourceName = resource.resourceName ?? resourceName;
    resourceType = resource.resourceType ?? resourceType;
    children = resource.children ?? children;
    media = resource.media ?? media;
    permission = resource.permission ?? permission;
    createdAt = resource.createdAt ?? createdAt;
    updatedAt = resource.updatedAt ?? updatedAt;
    deletedAt = resource.deletedAt ?? deletedAt;
  }

  //
  //
  /// represents that resource is file or not
  bool get isFile => resourceType == "file";

  ResourceFileEntity? get primaryMedia => media?.firstOrNull;

  String get primaryMediaUrl => primaryMedia?.url ?? "";

  //
  //
  /// represents that i am the owner of resource or not
  bool get iAmOwner => isOwner ?? false;

  //
  //
  /// represents that resource is shared with me by some one
  bool get isSharedWithMe =>
      (!iAmOwner) && (shared ?? false) && (sharedWithUsers?.isNotEmpty ?? true);

  //
  //
  /// represents that resource is shared by me to some one
  bool get isSharedByMe =>
      iAmOwner && (shared ?? false) && (sharedWithUsers?.isNotEmpty ?? true);

  //
  //
  /// represents the children count non null
  int get childrenCount => children ?? 0;

  //
  //
  /// resprents that have many children or only one child resource
  bool get haveManyChildren => childrenCount > 1;

  //
  //
  /// represents the no of peoples resorce shared with
  int get sharedWithCount => sharedWithUsers?.length ?? 0;

  //
  //
  /// represents that resource is shared with more then one person
  bool get sharedWithMany => sharedWithCount > 1;

  //
  //
  /// represents that user can delete this resource or not
  bool canDelete(int userId) {
    if (iAmOwner) {
      return true;
    } else {
      final me =
          sharedWithUsers?.firstWhereOrNull((user) => user.userId == userId);

      if (me == null) {
        return false;
      }

      return me.permission == "all" || me.permission == "rwd";
    }
  }

  //
  //
  /// represents that user can share this resource or not
  bool canShare(int userId) {
    if (iAmOwner) {
      return true;
    } else {
      final me =
          sharedWithUsers?.firstWhereOrNull((user) => user.userId == userId);

      if (me == null) {
        return false;
      }

      return me.permission == "all";
    }
  }

  //
  //
  /// represents that user can edit this resource or not
  bool canEdit(int userId) {
    if (iAmOwner) {
      return true;
    } else {
      final me =
          sharedWithUsers?.firstWhereOrNull((user) => user.userId == userId);

      if (me == null) {
        return false;
      }

      return me.permission == "all" ||
          me.permission == "rw" ||
          me.permission == "rwd";
    }
  }
}

class ResourceFileEntity extends Equatable {
  final int? id;
  final String? fileType;
  final String? name;
  final String? fileName;
  final String? fileNameExt;
  final String? url;
  final String? mimeType;
  final String? size;
  final String? fileIcon;
  final String? uploadedBy;
  final DateTime? createdAt;
  final dynamic approvedBy;
  final DateTime? updatedAt;

  const ResourceFileEntity({
    this.id,
    this.fileType,
    this.name,
    this.fileName,
    this.fileNameExt,
    this.url,
    this.mimeType,
    this.size,
    this.fileIcon,
    this.uploadedBy,
    this.createdAt,
    this.approvedBy,
    this.updatedAt,
  });

  factory ResourceFileEntity.fromJson(Map<String, dynamic> json) =>
      ResourceFileEntity(
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

  @override
  List<Object?> get props => [
        id,
        fileType,
        name,
        fileName,
        fileNameExt,
        url,
        mimeType,
        size,
        fileIcon,
        uploadedBy,
        createdAt,
        approvedBy,
        updatedAt,
      ];
}

class SharedWithUserEntity extends Equatable {
  final int? id;
  final int? userId;
  final String? name;
  final String? permission;
  final String? designation;
  final String? image;

  const SharedWithUserEntity({
    this.id,
    this.userId,
    this.name,
    this.permission,
    this.designation,
    this.image,
  });

  factory SharedWithUserEntity.fromJson(Map<String, dynamic> json) =>
      SharedWithUserEntity(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        permission: json["permission"],
        designation: json["designation"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "permission": permission,
        "designation": designation,
        "image": image,
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        permission,
        designation,
        image,
      ];

  String getPermissionText() {
    if (permission == "all") {
      return "All";
    } else if (permission == "r") {
      return "Read";
    } else if (permission == "rw") {
      return "Read, Write";
    } else if (permission == "rwd") {
      return "Read, Write, Delete";
    } else {
      return "";
    }
  }
}
