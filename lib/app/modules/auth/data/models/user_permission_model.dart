import 'dart:convert';

import 'package:ts_admin/app/modules/auth/domain/entities/user_permission_entity.dart';

UserPermissionModel userPermissionModelFromJson(String str) =>
    UserPermissionModel.fromJson(json.decode(str));

String userPermissionModelToJson(UserPermissionModel data) =>
    json.encode(data.toJson());

class UserPermissionModel extends UserPermissionEntity {
  const UserPermissionModel({
    super.id,
    super.name,
  });

  factory UserPermissionModel.fromJson(Map<String, dynamic> json) =>
      UserPermissionModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
