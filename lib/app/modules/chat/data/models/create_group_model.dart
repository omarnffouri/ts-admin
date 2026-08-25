// To parse this JSON data, do
//
//     final createGroupEntity = createGroupEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/data/models/group_conversation_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_group_entity.dart';

CreateGroupModel createGroupModelFromJson(String str) =>
    CreateGroupModel.fromJson(json.decode(str));

String createGroupModelToJson(CreateGroupModel data) =>
    json.encode(data.toJson());

class CreateGroupModel extends CreateGroupEntity {
  const CreateGroupModel({super.error, super.message, super.code, super.data});

  factory CreateGroupModel.fromJson(Map<String, dynamic> json) =>
      CreateGroupModel(
        error: json["error"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null
            ? null
            : GroupConversationModel.fromJson(json["data"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}
