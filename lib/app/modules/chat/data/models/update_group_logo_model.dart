// To parse this JSON data, do

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/update_group_logo_entity.dart';

UpdateGroupLogoModel updateGroupNameModelFromJson(String str) =>
    UpdateGroupLogoModel.fromJson(json.decode(str));

String updateGroupNameModelToJson(UpdateGroupLogoModel data) =>
    json.encode(data.toJson());

class UpdateGroupLogoModel extends UpdateGroupLogoEntity {
  const UpdateGroupLogoModel({
    super.error,
    super.message,
    super.data,
    super.code,
  });

  factory UpdateGroupLogoModel.fromJson(Map<String, dynamic> json) =>
      UpdateGroupLogoModel(
        error: json["error"],
        message: json["message"],
        data: json["data"],
        code: json["code"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "code": code,
        "data": data,
      };
}
