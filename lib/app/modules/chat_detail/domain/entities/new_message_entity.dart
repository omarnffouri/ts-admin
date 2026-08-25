// To parse this JSON data, do
//
//     final conversationDetailsModel = conversationDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

import '../../../chat/domain/entities/conversation_entity.dart';

NewMessageEntity newMessageEntityFromJson(String str) =>
    NewMessageEntity.fromJson(json.decode(str));

String conversationDetailsModelToJson(NewMessageEntity data) =>
    json.encode(data.toJson());

class NewMessageEntity extends Equatable {
  final int? id;
  final String? image;
  final dynamic phone;
  final String? senderName;
  final int? senderId;
  final String? message;
  final String? time;
  final NewMessageDataEntity? messageData;

  const NewMessageEntity({
    this.id,
    this.image,
    this.phone,
    this.senderName,
    this.senderId,
    this.message,
    this.time,
    this.messageData,
  });

  factory NewMessageEntity.fromJson(Map<String, dynamic> json) =>
      NewMessageEntity(
        id: json["id"],
        image: json["image"],
        phone: json["phone"],
        senderName: json["sender_name"],
        senderId: json["sender_id"],
        message: json["message"],
        time: json["time"],
        messageData: json["message_data"] == null
            ? null
            : NewMessageDataEntity.fromJson(json["message_data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "phone": phone,
        "sender_name": senderName,
        "sender_id": senderId,
        "message": message,
        "time": time,
        "message_data": messageData?.toJson()
      };

  @override
  List<Object?> get props =>
      [id, image, phone, senderName, senderId, message, time, messageData];

  ConversationMessageEntity convertToConversationMessageEntity() {
    return ConversationMessageEntity(
      id: messageData?.id,
      conversationId:
          int.parse((messageData?.conversationId ?? "0").toString()),
      modelType: messageData?.modelType,
      modelId: messageData?.modelId,
      type: messageData?.type,
      tempId: messageData?.tempId,
      callType: messageData?.callType,
      forwardMessageId: messageData?.forwardMessageId,
      mentions: messageData?.mentions,
      reactions: messageData?.reactions,
      duration: messageData?.duration,
      message: messageData?.message,
      deletedAt: messageData?.deletedAt,
      readAt: messageData?.readAt,
      createdAt: messageData?.createdAt,
      updatedAt: messageData?.updatedAt,
      isEdited: messageData?.isEdited,
      authIsSender: messageData?.authIsSender,
      dateTimeInHumans: messageData?.dateTimeInHumans,
      sender: messageData?.sender,
      attachments: messageData?.attachments != null
          ? List.from(messageData!.attachments!)
          : null,
      replyOn: ConversationMessageModel.fromJsonAndNullable(
          messageData?.replyOn?.toJson()),
      model: ConversationUserModelEntity(
        id: messageData?.model?.id,
        name: messageData?.model?.name,
        image: messageData?.model?.image,
        email: messageData?.model?.email,
        phone: messageData?.model?.phone,
        modelType: messageData?.model?.modelType,
        userDesignation: messageData?.model?.userDesignation,
      ),
    );
  }

  ConversationLastMessageEntity convertToConversationLastMessageEntity() {
    return ConversationLastMessageEntity(
      id: messageData?.id,
      modelId: messageData?.modelId,
      type: messageData?.type,
      message: messageData?.message,
      mentions: messageData?.mentions,
      createdAt: messageData?.createdAt,
      updatedAt: messageData?.updatedAt,
      deletedAt: messageData?.deletedAt,
      duration: messageData?.duration,
      attachments: messageData?.attachments != null
          ? List.from(messageData!.attachments!)
          : null,
    );
  }

  GroupLastMessageEntity convertToGroupConversationLastMessageEntity() {
    return GroupLastMessageEntity(
      id: messageData?.id,
      modelId: messageData?.modelId,
      type: messageData?.type,
      message: messageData?.message,
      createdAt: messageData?.createdAt,
      updatedAt: messageData?.updatedAt,
      deletedAt: messageData?.deletedAt,
      mentions: messageData?.mentions,
      duration: messageData?.duration,
      attachments: messageData?.attachments != null
          ? List.from(messageData!.attachments!)
          : null,
    );
  }
}

class NewMessageDataEntity extends Equatable {
  final String? conversationId;
  final int? modelId;
  final int? duration;
  final int? forwardMessageId;
  final String? modelType;
  final String? type;
  final String? message;
  final String? tempId;
  final String? callType;
  final DateTime? updatedAt;
  final String? readAt;
  final NewMessageDataEntity? replyOn;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final int? id;
  final bool? authIsSender;
  final bool? isEdited;
  final String? dateTimeInHumans;
  final dynamic sender;
  final NewMessageUserModelEntity? model;
  final List<AttachmentEntity>? attachments;
  final List<ConversationMentionEntity>? mentions;
  final List<MessageReactionEntity>? reactions;

  const NewMessageDataEntity(
      {this.conversationId,
      this.modelId,
      this.modelType,
      this.type,
      this.message,
      this.tempId,
      this.replyOn,
      this.duration,
      this.updatedAt,
      this.mentions,
      this.createdAt,
      this.deletedAt,
      this.callType,
      this.id,
      this.authIsSender,
      this.isEdited,
      this.dateTimeInHumans,
      this.sender,
      this.model,
      this.attachments,
      this.readAt,
      this.forwardMessageId,
      this.reactions});

  factory NewMessageDataEntity.fromJson(Map<String, dynamic> json) =>
      NewMessageDataEntity(
        conversationId: json["conversation_id"],
        modelId: json["model_id"],
        duration: json["duration"],
        forwardMessageId: json["forward_message_id"],
        modelType: json["model_type"],
        type: json["type"],
        callType: json["call_type"] ?? "audio",
        message: json["message"],
        tempId: json["temp_id"],
        readAt: json["read_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]).toLocal(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        id: json["id"],
        authIsSender: json["auth_is_sender"],
        isEdited: json["is_edited"] == null ? false : json['is_edited'],
        dateTimeInHumans: json["date_time_in_humans"],
        sender: json["sender"],
        model: json["model"] == null
            ? null
            : NewMessageUserModelEntity.fromJson(json["model"]),
        replyOn: json["reply_on"] == null
            ? null
            : NewMessageDataEntity.fromJson(json["reply_on"]),
        attachments: json["attachments"] == null
            ? []
            : List<AttachmentEntity>.from(
                json["attachments"]!.map((x) => AttachmentEntity.fromJson(x))),
        mentions: json["mentions"] == null
            ? []
            : List<ConversationMentionEntity>.from(json["mentions"]!
                .map((x) => ConversationMentionEntity.fromJson(x))),
        reactions: json["reactions"] == null
            ? []
            : List<MessageReactionEntity>.from(json["reactions"]!
                .map((x) => MessageReactionEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "conversation_id": conversationId,
        "model_id": modelId,
        "duration": duration,
        "model_type": modelType,
        "type": type,
        "forward_message_id": forwardMessageId,
        "message": message,
        "temp_id": tempId,
        "read_at": readAt,
        "deleted_at": deletedAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "call_type": callType,
        "auth_is_sender": authIsSender,
        "is_edited": isEdited,
        "date_time_in_humans": dateTimeInHumans,
        "sender": sender,
        "model": model?.toJson(),
        "reply_on": replyOn?.toJson(),
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "mentions": mentions == null
            ? []
            : List<dynamic>.from(mentions!.map((x) => x.toJson())),
        "reactions": reactions == null
            ? []
            : List<dynamic>.from(reactions!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        conversationId,
        modelId,
        modelType,
        type,
        message,
        replyOn,
        forwardMessageId,
        updatedAt,
        mentions,
        callType,
        duration,
        createdAt,
        id,
        tempId,
        readAt,
        authIsSender,
        isEdited,
        dateTimeInHumans,
        sender,
        model,
        attachments,
        reactions,
        deletedAt,
      ];
}

class NewMessageUserModelEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? phone;
  final String? birthDate;
  final String? address;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic teamId;
  final String? ringCentralUsername;
  final String? ringCentralExtension;
  final String? ringCentralPassword;
  final String? name;
  final String? image;
  final String? modelType;
  final String? userDesignation;

  const NewMessageUserModelEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.birthDate,
    this.address,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.teamId,
    this.ringCentralUsername,
    this.ringCentralExtension,
    this.ringCentralPassword,
    this.name,
    this.image,
    this.modelType,
    this.userDesignation,
  });

  factory NewMessageUserModelEntity.fromJson(Map<String, dynamic> json) =>
      NewMessageUserModelEntity(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        phone: json["phone"],
        birthDate: json["birth_date"],
        address: json["address"],
        fcmToken: json["fcm_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        teamId: json["team_id"],
        ringCentralUsername: json["ring_central_username"],
        ringCentralExtension: json["ring_central_extension"],
        ringCentralPassword: json["ring_central_password"],
        name: json["name"],
        image: json["image"],
        modelType: json["model_type"],
        userDesignation: json["user_designation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "phone": phone,
        "birth_date": birthDate,
        "address": address,
        "fcm_token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "team_id": teamId,
        "ring_central_username": ringCentralUsername,
        "ring_central_extension": ringCentralExtension,
        "ring_central_password": ringCentralPassword,
        "name": name,
        "image": image,
        "model_type": modelType,
        "user_designation": userDesignation,
      };

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        emailVerifiedAt,
        phone,
        birthDate,
        address,
        fcmToken,
        createdAt,
        updatedAt,
        deletedAt,
        teamId,
        ringCentralUsername,
        ringCentralExtension,
        ringCentralPassword,
        name,
        image,
        modelType,
        userDesignation,
      ];
}
