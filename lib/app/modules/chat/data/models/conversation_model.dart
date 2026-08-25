// To parse this JSON data, do
//
//     final conversationModel = conversationModelFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/data/models/on_going_call_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

ConversationModel conversationModelFromJson(String str) =>
    ConversationModel.fromJson(json.decode(str));

String conversationModelToJson(ConversationModel data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class ConversationModel extends ConversationEntity {
  ConversationModel({
    super.id,
    super.user,
    super.dateTimeInHumans,
    super.name,
    super.lastMessagedAt,
    super.chatAble,
    super.status,
    super.message,
    super.participants,
    super.unreadCount,
    super.notificationMuted,
    super.ongoingCall,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["id"],
        lastMessagedAt: json["last_messaged_at"],
        name: json["name"],
        status: json["status"],
        chatAble: json["chat_able"],
        notificationMuted: json["notification_muted"],
        user: json["receiver"] == null
            ? null
            : ConversationReceiverModel.fromJson(json["receiver"]),
        message: json["message"] == null
            ? null
            : ConversationLastMessageModel.fromJson(json["message"]),
        unreadCount: json["unread_count"],
        participants: json["participants"] == null
            ? []
            : List<ParticipantModel>.from(
                json["participants"]!.map((x) => ParticipantModel.fromJson(x))),
        dateTimeInHumans: json["date_time_in_humans"],
        ongoingCall: json["ongoing_call"] == null
            ? null
            : OngoingCallModel.fromJson(json["ongoing_call"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "last_messaged_at": lastMessagedAt,
        "receiver": user?.toJson(),
        "name": name,
        "status": status,
        "chat_able": chatAble,
        "message": message?.toJson(),
        "date_time_in_humans": dateTimeInHumans,
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "unread_count": unreadCount,
        "notification_muted": notificationMuted,
        "ongoing_call": ongoingCall?.toJson(),
      };
}

// ignore: must_be_immutable
class ConversationReceiverModel extends ConversationReciverEntity {
  ConversationReceiverModel({
    super.id,
    super.modelType,
    super.phone,
    super.name,
    super.image,
  });

  factory ConversationReceiverModel.fromJson(Map<String, dynamic> json) =>
      ConversationReceiverModel(
        id: json["id"],
        modelType: json["model_type"],
        phone: json["phone"],
        name: json["name"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "model_type": modelType,
        "phone": phone,
        "name": name,
        "image": image,
      };
}

// ignore: must_be_immutable
class ConversationLastMessageModel extends ConversationLastMessageEntity {
  ConversationLastMessageModel({
    super.id,
    super.conversationId,
    super.modelType,
    super.modelId,
    super.type,
    super.message,
    super.duration,
    super.deletedAt,
    super.createdAt,
    super.updatedAt,
    super.mentions,
    super.authIsSender,
    super.dateTimeInHumans,
    super.attachments,
  });

  factory ConversationLastMessageModel.fromJson(Map<String, dynamic> json) =>
      ConversationLastMessageModel(
        id: json["id"],
        conversationId: json["conversation_id"],
        duration: json["duration"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        type: json["type"],
        message: json["message"],
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]).toLocal(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        authIsSender: json["auth_is_sender"],
        dateTimeInHumans: json["date_time_in_humans"],
        attachments: json["attachments"] == null
            ? []
            : List<AttachmentModel>.from(
                json["attachments"]!.map((x) => AttachmentModel.fromJson(x))),
        mentions: json["mentions"] == null
            ? []
            : List<ConversationMentionModel>.from(json["mentions"]!
                .map((x) => ConversationMentionModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "model_type": modelType,
        "model_id": modelId,
        "type": type,
        "message": message,
        "duration": duration,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "auth_is_sender": authIsSender,
        "date_time_in_humans": dateTimeInHumans,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "mentions":
            mentions == null ? [] : List<dynamic>.from(mentions!.map((x) => x)),
      };
}

// ignore: must_be_immutable
class ParticipantModel extends ParticipantEntity {
  ParticipantModel({
    super.id,
    super.pid,
    super.name,
    super.phone,
    super.image,
    super.modelType,
    super.isGroupAdmin,
    super.userDesignation,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        id: json["id"],
        pid: json["p_id"],
        name: json["name"],
        phone: json["phone"],
        image: json["image"],
        modelType: modelTypeValues.map[json["model_type"]],
        isGroupAdmin: json["is_group_admin"],
        userDesignation: json["user_designation"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "p_id": pid,
        "name": name,
        "phone": phone,
        "image": image,
        "model_type": modelTypeValues.reverse[modelType],
        "is_group_admin": isGroupAdmin,
        "user_designation": userDesignation,
      };
}
