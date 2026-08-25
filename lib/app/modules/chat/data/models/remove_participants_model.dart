// To parse this JSON data, do
//
//     final addParticipantsEntity = addParticipantsEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/remove_participants_entity.dart';

RemoveParticipantsModel removeParticipantsModelFromJson(String str) =>
    RemoveParticipantsModel.fromJson(json.decode(str));

String removeParticipantsModelToJson(RemoveParticipantsModel data) =>
    json.encode(data.toJson());

class RemoveParticipantsModel extends RemoveParticipantsEntity {
  const RemoveParticipantsModel({
    super.error,
    super.message,
    super.code,
  });

  factory RemoveParticipantsModel.fromJson(Map<String, dynamic> json) =>
      RemoveParticipantsModel(
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
