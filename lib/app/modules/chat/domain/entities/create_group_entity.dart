// To parse this JSON data, do
//
//     final createGroupEntity = createGroupEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

CreateGroupEntity createGroupEntityFromJson(String str) =>
    CreateGroupEntity.fromJson(json.decode(str));

String createGroupEntityToJson(CreateGroupEntity data) =>
    json.encode(data.toJson());

class CreateGroupEntity extends Equatable {
  final bool? error;
  final String? message;
  final GroupConversationEntity? data;
  final int? code;

  const CreateGroupEntity({
    this.error,
    this.message,
    this.data,
    this.code,
  });

  factory CreateGroupEntity.fromJson(Map<String, dynamic> json) =>
      CreateGroupEntity(
        error: json["error"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null
            ? null
            : GroupConversationEntity.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };

  @override
  List<Object?> get props => [error, message, code, data];
}
