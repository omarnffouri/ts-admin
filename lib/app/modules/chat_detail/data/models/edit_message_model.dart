// To parse this JSON data, do
//
//     final editMessageEntity = editMessageEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat_detail/domain/entities/edit_message_entity.dart';

EditMessageModel editMessageModelFromJson(String str) =>
    EditMessageModel.fromJson(json.decode(str));

String editMessageModelToJson(EditMessageModel data) =>
    json.encode(data.toJson());

class EditMessageModel extends EditMessageEntity {
  const EditMessageModel({
    super.error,
    super.message,
    super.code,
  });

  factory EditMessageModel.fromJson(Map<String, dynamic> json) =>
      EditMessageModel(
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
