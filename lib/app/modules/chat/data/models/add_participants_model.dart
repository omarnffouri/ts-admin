// To parse this JSON data, do
//
//     final addParticipantsEntity = addParticipantsEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/add_participants_entity.dart';

AddParticipantsModel addParticipantsModelFromJson(String str) =>
    AddParticipantsModel.fromJson(json.decode(str));

String addParticipantsModelToJson(AddParticipantsModel data) =>
    json.encode(data.toJson());

class AddParticipantsModel extends AddParticipantsEntity {
  const AddParticipantsModel({
    super.error,
    super.message,
    super.code,
  });

  factory AddParticipantsModel.fromJson(Map<String, dynamic> json) =>
      AddParticipantsModel(
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
