// To parse this JSON data, do
//
//     final createConversationEntity = createConversationEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';

CreateConversationEntity createConversationEntityFromJson(String str) =>
    CreateConversationEntity.fromJson(json.decode(str));

String createConversationEntityToJson(CreateConversationEntity data) =>
    json.encode(data.toJson());

class CreateConversationEntity extends Equatable {
  final ConversationEntity? conversation;

  const CreateConversationEntity({
    this.conversation,
  });

  factory CreateConversationEntity.fromJson(Map<String, dynamic> json) =>
      CreateConversationEntity(
        conversation: json["conversation"] == null
            ? null
            : ConversationEntity.fromJson(json["conversation"]),
      );

  Map<String, dynamic> toJson() => {
        "conversation": conversation?.toJson(),
      };

  @override
  List<Object?> get props => [conversation];
}
