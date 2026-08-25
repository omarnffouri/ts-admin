import 'dart:convert';

import 'package:ts_admin/app/modules/chat/data/models/conversation_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_conversation_entity.dart';

CreateConversationModel createConversationModelFromJson(String str) =>
    CreateConversationModel.fromJson(json.decode(str));

String createConversationModelToJson(CreateConversationModel data) =>
    json.encode(data.toJson());

class CreateConversationModel extends CreateConversationEntity {
  const CreateConversationModel({
    super.conversation,
  });

  factory CreateConversationModel.fromJson(Map<String, dynamic> json) =>
      CreateConversationModel(
        conversation: json["conversation"] == null
            ? null
            : ConversationModel.fromJson(json["conversation"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "conversation": conversation?.toJson(),
      };
}
