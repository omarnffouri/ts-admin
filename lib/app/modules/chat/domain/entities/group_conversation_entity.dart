// To parse this JSON data, do
//
//     final groupConversationEntity = groupConversationEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/enum_values.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/on_going_call_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';

GroupConversationEntity groupConversationEntityFromJson(String str) =>
    GroupConversationEntity.fromJson(json.decode(str));

String groupConversationEntityToJson(GroupConversationEntity data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class GroupConversationEntity extends Equatable {
  int? id;
  String? name;
  List<GroupConversationConversationEntity>? conversations;
  int? unreadCount;
  int? conversationsCount;
  GroupSettingsEntity? groupSettings;

  //
  // states variables
  RxBool isLoadingSubGroups = true.obs;

  GroupConversationEntity({
    this.id,
    this.name,
    this.conversations,
    this.unreadCount,
    this.conversationsCount,
    this.groupSettings,
  });

  factory GroupConversationEntity.fromJson(Map<String, dynamic> json) =>
      GroupConversationEntity(
        id: json["id"],
        name: json["name"],
        conversations: json["conversations"] == null
            ? []
            : List<GroupConversationConversationEntity>.from(
                json["conversations"]!.map(
                    (x) => GroupConversationConversationEntity.fromJson(x))),
        unreadCount: json["unread_count"],
        conversationsCount: json["conversations_count"],
        groupSettings: GroupSettingsEntity.fromJson(json["group_setting"]),
      );

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

  List<dynamic> converstionListToJson() => conversations == null
      ? []
      : List<dynamic>.from(conversations!.map((x) => x.toJson()));

  @override
  List<Object?> get props => [
        id,
        name,
        conversations,
        unreadCount,
        conversationsCount,
        groupSettings,
      ];

  bool get haveOngoingCall =>
      conversations?.firstWhereOrNull((item) => item.haveOngoingCall) != null;

  // bool get haveOngoingCall => false;
}

// ignore: must_be_immutable
class GroupConversationConversationEntity extends Equatable {
  final int? id;
  String? groupName;
  final int? modelId;
  final ModelType? modelType;
  final String? name;
  final String? type;
  final String? image;
  final List<ParticipantEntity>? participants;
  bool? chatAble;
  String? status;
  String? dateTimeInHumans;
  final int? lastMessagedAt;
  int? unreadCount;
  GroupLastMessageEntity? message;
  List<int>? mentioned;
  bool? notificationMuted;
  OngoingCallEntity? ongoingCall;

  GroupConversationConversationEntity({
    this.id,
    this.groupName,
    this.name,
    this.type,
    this.image,
    this.participants,
    this.dateTimeInHumans,
    this.chatAble,
    this.status,
    this.lastMessagedAt,
    this.mentioned,
    this.unreadCount,
    this.message,
    this.modelId,
    this.modelType,
    this.notificationMuted,
    this.ongoingCall,
  });

  factory GroupConversationConversationEntity.fromJson(
          Map<String, dynamic> json) =>
      GroupConversationConversationEntity(
        id: json["id"],
        name: json["name"],
        groupName: json["group_name"],
        status: json["status"],
        chatAble: json["chat_able"],
        type: json["type"],
        image: json["image"],
        notificationMuted: json["notification_muted"],
        participants: json["participants"] == null
            ? []
            : List<ParticipantEntity>.from(json["participants"]!
                .map((x) => ParticipantEntity.fromJson(x))),
        dateTimeInHumans: json["date_time_in_humans"],
        lastMessagedAt: json["last_messaged_at"],
        unreadCount: json["unread_count"],
        message: json["message"] == null
            ? null
            : GroupLastMessageEntity.fromJson(json["message"]),
        mentioned: json["mentioned"] == null
            ? []
            : List<int>.from(json["mentioned"]!.map((x) => x)),
        modelId: json["model_id"],
        modelType: modelTypeValues.map[json["model_type"]],
        ongoingCall: json["ongoing_call"] == null
            ? null
            : OngoingCallEntity.fromJson(json["ongoing_call"]),
      );

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
        // "ongoing_call": ongoingCall?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        groupName,
        name,
        type,
        image,
        participants,
        dateTimeInHumans,
        lastMessagedAt,
        mentioned,
        unreadCount,
        message,
        chatAble,
        status,
        modelId,
        modelType,
        notificationMuted,
        ongoingCall,
      ];

  bool get haveOngoingCall => ongoingCall != null;
  // bool get haveOngoingCall => false;
}

// ignore: must_be_immutable
class GroupLastMessageEntity extends Equatable {
  final int? id;
  final int? conversationId;
  final String? modelType;
  final int? modelId;
  final int? duration;
  final String? type;
  final String? message;
  final dynamic readAt;
  DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? authIsSender;
  final String? dateTimeInHumans;
  final List<AttachmentEntity>? attachments;
  final List<ConversationMentionEntity>? mentions;

  GroupLastMessageEntity({
    this.id,
    this.conversationId,
    this.modelType,
    this.modelId,
    this.type,
    this.message,
    this.duration,
    this.readAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.mentions,
    this.authIsSender,
    this.dateTimeInHumans,
    this.attachments,
  });

  factory GroupLastMessageEntity.fromJson(Map<String, dynamic> json) =>
      GroupLastMessageEntity(
        id: json["id"],
        conversationId: json["conversation_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        type: json["type"],
        duration: json["duration"],
        message: json["message"],
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
            : List<AttachmentEntity>.from(
                json["attachments"]!.map((x) => AttachmentEntity.fromJson(x))),
        mentions: json["mentions"] == null
            ? []
            : List<ConversationMentionEntity>.from(json["mentions"]!
                .map((x) => ConversationMentionEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "model_type": modelType,
        "model_id": modelId,
        "type": type,
        "message": message,
        "duration": duration,
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

  @override
  List<Object?> get props => [
        id,
        conversationId,
        modelType,
        duration,
        modelId,
        type,
        message,
        readAt,
        deletedAt,
        mentions,
        createdAt,
        updatedAt,
        authIsSender,
        dateTimeInHumans,
        attachments,
      ];
}

// ignore: must_be_immutable
class GroupSettingsEntity extends Equatable {
  final int? id;
  String? name;
  String? logo;
  bool? autoAddDrivers;

  GroupSettingsEntity({
    this.id,
    this.name,
    this.logo,
    this.autoAddDrivers,
  });

  factory GroupSettingsEntity.fromJson(Map<String, dynamic> json) =>
      GroupSettingsEntity(
          id: json["id"],
          name: json["name"],
          logo: json["logo"],
          autoAddDrivers: json["auto_add_drivers"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
        "auto_add_drivers": autoAddDrivers,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
        autoAddDrivers,
      ];
}

// ignore: constant_identifier_names
enum ModelType { APPLICANTS, USERS }

final modelTypeValues =
    EnumValues({"applicants": ModelType.APPLICANTS, "users": ModelType.USERS});
