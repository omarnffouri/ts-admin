// To parse this JSON data, do
//
//     final updateProfileDataEntity = updateProfileDataEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/auth/domain/entities/update_password_entity.dart';

UpdatePasswordModel updatePasswordModelFromJson(String str) =>
    UpdatePasswordModel.fromJson(json.decode(str));

String updatePasswordModelToJson(UpdatePasswordModel data) =>
    json.encode(data.toJson());

class UpdatePasswordModel extends UpdatePasswordEntity {
  const UpdatePasswordModel({
    super.message,
    super.code,
  });

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordModel(message: json["message"], code: json["code"]);

  @override
  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
      };
}
