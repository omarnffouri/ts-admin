import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/on_going_call_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';

OngoingCallModel ongoingCallModelFromJson(String str) =>
    OngoingCallModel.fromJson(json.decode(str));

String ongoingCallModelToJson(OngoingCallModel data) =>
    json.encode(data.toJson());

class OngoingCallModel extends OngoingCallEntity {
  OngoingCallModel({
    super.id,
    super.conversationId,
    super.modelType,
    super.modelId,
    super.type,
    super.duration,
    super.message,
    super.callType,
    super.createdAt,
    super.tempId,
    super.model,
  });

  factory OngoingCallModel.fromJson(Map<String, dynamic> json) =>
      OngoingCallModel(
        id: json["id"],
        conversationId: json["conversation_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        type: json["type"],
        duration: json["duration"],
        message: json["message"],
        callType: json["call_type"],
        model: json["model"] == null
            ? null
            : ConversationUserModel.fromJson(json["model"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        tempId: json["temp_id"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "model_type": modelType,
        "model_id": modelId,
        "type": type,
        "duration": duration,
        "message": message,
        "call_type": callType,
        "model": model?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "temp_id": tempId,
      };
}
