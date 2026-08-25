// To parse this JSON data, do
//
//     final groupConversationEntity = groupConversationEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/data/models/conversation_model.dart';
import 'package:ts_admin/app/modules/chat/data/models/on_going_call_model.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

GroupConversationModel groupConversationModelFromJson(String str) =>
    GroupConversationModel.fromJson(json.decode(str));

String groupConversationModelToJson(GroupConversationModel data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class GroupConversationModel extends GroupConversationEntity {
  GroupConversationModel({
    super.id,
    super.name,
    super.conversations,
    super.unreadCount,
    super.conversationsCount,
    super.groupSettings,
  });

  factory GroupConversationModel.fromJson(Map<String, dynamic> json) =>
      GroupConversationModel(
        id: json["id"],
        name: json["name"],
        conversations: json["conversations"] == null
            ? []
            : List<GroupConversationConversationModel>.from(
                json["conversations"]!.map(
                    (x) => GroupConversationConversationModel.fromJson(x))),
        unreadCount: json["unread_count"],
        conversationsCount: json["conversations_count"],
        groupSettings: GroupSettingsModel.fromJson(json["group_setting"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "conversations": conversations == null
            ? []
            : List<dynamic>.from(conversations!.map((x) => x.toJson())),
        "unread_count": unreadCount,
        "conversations_count": conversationsCount,
        "group_setting": groupSettings?.toJson(),
      };
}

// ignore: must_be_immutable
class GroupConversationConversationModel
    extends GroupConversationConversationEntity {
  GroupConversationConversationModel({
    super.id,
    super.groupName,
    super.name,
    super.type,
    super.image,
    super.chatAble,
    super.status,
    super.participants,
    super.dateTimeInHumans,
    super.lastMessagedAt,
    super.unreadCount,
    super.mentioned,
    super.message,
    super.modelId,
    super.modelType,
    super.notificationMuted,
    super.ongoingCall,
  });

  factory GroupConversationConversationModel.fromJson(
          Map<String, dynamic> json) =>
      GroupConversationConversationModel(
        id: json["id"],
        groupName: json["group_name"],
        name: json["name"],
        type: json["type"],
        image: json["image"],
        status: json["status"],
        chatAble: json["chat_able"],
        notificationMuted: json["notification_muted"],
        participants: json["participants"] == null
            ? []
            : List<ParticipantModel>.from(
                json["participants"]!.map((x) => ParticipantModel.fromJson(x))),
        dateTimeInHumans: json["date_time_in_humans"],
        lastMessagedAt: json["last_messaged_at"],
        unreadCount: json["unread_count"],
        message: json["message"] == null
            ? null
            : GroupLastMessageModel.fromJson(json["message"]),
        mentioned: json["mentioned"] == null
            ? []
            : List<int>.from(json["mentioned"]!.map((x) => x)),
        modelId: json["model_id"],
        modelType: modelTypeValues.map[json["model_type"]],
        ongoingCall: json["ongoing_call"] == null
            ? null
            : OngoingCallModel.fromJson(json["ongoing_call"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "name": name,
        "type": type,
        "image": image,
        "status": status,
        "chat_able": chatAble,
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "date_time_in_humans": dateTimeInHumans,
        "last_messaged_at": lastMessagedAt,
        "unread_count": unreadCount,
        "message": message?.toJson(),
        "mentioned": mentioned == null
            ? []
            : List<dynamic>.from(mentioned!.map((x) => x)),
        "model_id": modelId,
        "model_type": modelTypeValues.reverse[modelType],
        "notification_muted": notificationMuted,
        "ongoing_call": ongoingCall?.toJson(),
      };
}

// ignore: must_be_immutable
class GroupLastMessageModel extends GroupLastMessageEntity {
  GroupLastMessageModel({
    super.id,
    super.conversationId,
    super.modelType,
    super.modelId,
    super.type,
    super.message,
    super.readAt,
    super.deletedAt,
    super.createdAt,
    super.duration,
    super.mentions,
    super.updatedAt,
    super.authIsSender,
    super.dateTimeInHumans,
    super.attachments,
  });

  factory GroupLastMessageModel.fromJson(Map<String, dynamic> json) =>
      GroupLastMessageModel(
        id: json["id"],
        conversationId: json["conversation_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        type: json["type"],
        message: json["message"],
        duration: json["duration"],
        readAt: json["read_at"],
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
        "duration": duration,
        "message": message,
        "read_at": readAt,
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
class GroupSettingsModel extends GroupSettingsEntity {
  GroupSettingsModel({
    super.id,
    super.name,
    super.logo,
    super.autoAddDrivers,
  });

  factory GroupSettingsModel.fromJson(Map<String, dynamic> json) =>
      GroupSettingsModel(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
        autoAddDrivers: json["auto_add_drivers"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
        "auto_add_drivers": autoAddDrivers,
      };
}
