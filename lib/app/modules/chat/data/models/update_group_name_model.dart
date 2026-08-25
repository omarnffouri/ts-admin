// To parse this JSON data, do
//
//     final updateGroupNameEntity = updateGroupNameEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/update_group_name_entity.dart';

UpdateGroupNameModel updateGroupNameModelFromJson(String str) =>
    UpdateGroupNameModel.fromJson(json.decode(str));

String updateGroupNameModelToJson(UpdateGroupNameModel data) =>
    json.encode(data.toJson());

class UpdateGroupNameModel extends UpdateGroupNameEntity {
  const UpdateGroupNameModel({
    super.error,
    super.message,
    super.code,
  });

  factory UpdateGroupNameModel.fromJson(Map<String, dynamic> json) =>
      UpdateGroupNameModel(
        error: json["error"],
        message: json["message"],
        code: json["code"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "code": code,
      };
}
