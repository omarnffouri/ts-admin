// To parse this JSON data, do
//
//     final conversationModel = conversationModelFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/on_going_call_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

// ignore: must_be_immutable
class ConversationEntity extends Equatable {
  int? id;
  int? lastMessagedAt;
  ConversationReciverEntity? user;
  String? dateTimeInHumans;
  String? name;
  bool? chatAble;
  String? status;
  ConversationLastMessageEntity? message;
  final List<ParticipantEntity>? participants;
  int? unreadCount;
  bool? notificationMuted;
  OngoingCallEntity? ongoingCall;

  ConversationEntity({
    this.id,
    this.user,
    this.dateTimeInHumans,
    this.name,
    this.lastMessagedAt,
    this.chatAble,
    this.status,
    this.message,
    this.participants,
    this.unreadCount,
    this.notificationMuted,
    this.ongoingCall,
  });

  factory ConversationEntity.fromJson(Map<String, dynamic> json) =>
      ConversationEntity(
        id: json["id"],
        lastMessagedAt: json["last_messaged_at"],
        name: json["name"],
        status: json["status"],
        chatAble: json["chat_able"],
        notificationMuted: json["notification_muted"],
        user: json["receiver"] == null
            ? null
            : ConversationReciverEntity.fromJson(json["receiver"]),
        message: json["message"] == null
            ? null
            : ConversationLastMessageEntity.fromJson(json["message"]),
        unreadCount: json["unread_count"],
        participants: json["participants"] == null
            ? []
            : List<ParticipantEntity>.from(json["participants"]!
                .map((x) => ParticipantEntity.fromJson(x))),
        dateTimeInHumans: json["date_time_in_humans"],
        ongoingCall: json["ongoing_call"] == null
            ? null
            : OngoingCallEntity.fromJson(json["ongoing_call"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "last_messaged_at": lastMessagedAt,
        "chat_able": chatAble,
        "receiver": user?.toJson(),
        "date_time_in_humans": dateTimeInHumans,
        "message": message?.toJson(),
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "unread_count": unreadCount,
        "notification_muted": notificationMuted,
        "ongoing_call": ongoingCall?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        user,
        dateTimeInHumans,
        message,
        unreadCount,
        lastMessagedAt,
        name,
        chatAble,
        status,
        participants,
        notificationMuted,
        ongoingCall,
      ];
}

// ignore: must_be_immutable
class ConversationReciverEntity extends Equatable {
  int? id;
  String? phone;
  String? name;
  String? image;
  String? modelType;

  ConversationReciverEntity({
    this.id,
    this.phone,
    this.name,
    this.image,
    this.modelType,
  });

  factory ConversationReciverEntity.fromJson(Map<String, dynamic> json) =>
      ConversationReciverEntity(
        id: json["id"],
        phone: json["phone"],
        modelType: json["model_type"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "model_type": modelType,
        "name": name,
        "image": image,
      };

  @override
  List<Object?> get props => [id, modelType, phone, name, image];
}

// ignore: must_be_immutable
class ConversationLastMessageEntity extends Equatable {
  int? id;
  int? conversationId;
  String? modelType;
  int? modelId;
  int? duration;
  String? type;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  bool? authIsSender;
  String? dateTimeInHumans;
  List<ConversationMentionEntity>? mentions;
  List<AttachmentEntity>? attachments;

  ConversationLastMessageEntity({
    this.id,
    this.conversationId,
    this.modelType,
    this.modelId,
    this.type,
    this.message,
    this.deletedAt,
    this.mentions,
    this.createdAt,
    this.duration,
    this.updatedAt,
    this.authIsSender,
    this.dateTimeInHumans,
    this.attachments,
  });

  factory ConversationLastMessageEntity.fromJson(Map<String, dynamic> json) =>
      ConversationLastMessageEntity(
        id: json["id"],
        conversationId: json["conversation_id"],
        modelType: json["model_type"],
        duration: json["duration"],
        modelId: json["model_id"],
        type: json["type"],
        message: json["message"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
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
        "duration": duration,
        "type": type,
        "message": message,
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
        modelId,
        type,
        duration,
        message,
        deletedAt,
        createdAt,
        updatedAt,
        mentions,
        authIsSender,
        dateTimeInHumans,
        attachments,
      ];
}

// ignore: must_be_immutable
class ParticipantEntity extends Equatable {
  int? id;
  int? pid;
  String? name;
  String? phone;
  String? image;
  ModelType? modelType;
  bool? isGroupAdmin;
  String? userDesignation;

  ParticipantEntity({
    this.id,
    this.pid,
    this.name,
    this.phone,
    this.image,
    this.modelType,
    this.isGroupAdmin,
    this.userDesignation,
  });

  ParticipantEntity updateWith({
    ParticipantEntity? participantEntity,
  }) {
    id = participantEntity?.id ?? id;
    pid = participantEntity?.pid ?? pid;
    name = participantEntity?.name ?? name;
    phone = participantEntity?.phone ?? phone;
    image = participantEntity?.image ?? image;
    modelType = participantEntity?.modelType ?? modelType;
    isGroupAdmin = participantEntity?.isGroupAdmin ?? isGroupAdmin;
    userDesignation = participantEntity?.userDesignation ?? userDesignation;

    return this;
  }

  static ParticipantEntity createFrom({
    ConversationWithParticipentEntity? conversationWithParticipentEntity,
  }) =>
      ParticipantEntity(
        id: conversationWithParticipentEntity?.id,
        pid: conversationWithParticipentEntity?.pId,
        name: conversationWithParticipentEntity?.name,
        phone: conversationWithParticipentEntity?.phone,
        image: conversationWithParticipentEntity?.image,
        modelType:
            modelTypeValues.map[conversationWithParticipentEntity?.modelType],
        isGroupAdmin: conversationWithParticipentEntity?.isGroupAdmin,
        userDesignation: conversationWithParticipentEntity?.userDesignation,
      );

  factory ParticipantEntity.fromJson(Map<String, dynamic> json) =>
      ParticipantEntity(
        id: json["id"],
        pid: json["p_id"],
        name: json["name"],
        phone: json["phone"],
        image: json["image"],
        modelType: modelTypeValues.map[json["model_type"]],
        isGroupAdmin: json["is_group_admin"],
        userDesignation: json["user_designation"],
      );

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

  @override
  List<Object?> get props => [
        id,
        pid,
        name,
        phone,
        image,
        modelType,
        isGroupAdmin,
        userDesignation,
      ];
}
