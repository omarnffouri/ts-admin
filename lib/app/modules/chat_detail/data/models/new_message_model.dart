// To parse this JSON data, do
//
//     final conversationDetailsModel = conversationDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/new_message_entity.dart';

NewMessageModel newMessageModelFromJson(String str) =>
    NewMessageModel.fromJson(json.decode(str));

String conversationDetailsModelToJson(NewMessageModel data) =>
    json.encode(data.toJson());

class NewMessageModel extends NewMessageEntity {
  const NewMessageModel({
    super.id,
    super.image,
    super.phone,
    super.senderName,
    super.senderId,
    super.message,
    super.time,
    super.messageData,
  });

  factory NewMessageModel.fromJson(Map<String, dynamic> json) =>
      NewMessageModel(
        id: json["id"],
        image: json["image"],
        phone: json["phone"],
        senderName: json["sender_name"],
        senderId: json["sender_id"],
        message: json["message"],
        time: json["time"],
        messageData: json["message_data"] == null
            ? null
            : NewMessageDataModel.fromJson(json["message_data"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "phone": phone,
        "sender_name": senderName,
        "sender_id": senderId,
        "message": message,
        "time": time,
        "message_data": messageData?.toJson(),
      };

  ConversationMessageModel convertToConversationMessageModel() {
    return ConversationMessageModel(
      id: messageData?.id,
      conversationId: int.parse(messageData?.conversationId ?? "0"),
      modelType: messageData?.modelType,
      modelId: messageData?.modelId,
      type: messageData?.type,
      callType: messageData?.callType,
      message: messageData?.message,
      mentions: messageData?.mentions,
      duration: messageData?.duration,
      deletedAt: null,
      replyOn: ConversationMessageModel.fromJsonAndNullable(
          messageData?.replyOn?.toJson()),
      createdAt: messageData?.createdAt,
      updatedAt: messageData?.updatedAt,
      readAt: messageData?.readAt,
      isEdited: messageData?.isEdited,
      authIsSender: messageData?.authIsSender,
      dateTimeInHumans: messageData?.dateTimeInHumans,
      sender: messageData?.sender,
      attachments: messageData?.attachments != null
          ? List.from(messageData!.attachments!)
          : null,
      model: ConversationUserModel(
        id: messageData?.model?.id,
        name: messageData?.model?.name,
        image: messageData?.model?.image,
        email: messageData?.model?.email,
        phone: messageData?.model?.phone,
        modelType: messageData?.model?.modelType,
      ),
    );
  }
}

class NewMessageDataModel extends NewMessageDataEntity {
  const NewMessageDataModel(
      {super.conversationId,
      super.modelId,
      super.modelType,
      super.type,
      super.message,
      super.duration,
      super.mentions,
      super.updatedAt,
      super.createdAt,
      super.deletedAt,
      super.tempId,
      super.replyOn,
      super.id,
      super.callType,
      super.forwardMessageId,
      super.authIsSender,
      super.isEdited,
      super.dateTimeInHumans,
      super.sender,
      super.model,
      super.readAt,
      super.attachments,
      super.reactions});

  factory NewMessageDataModel.fromJson(Map<String, dynamic> json) =>
      NewMessageDataModel(
        conversationId: json["conversation_id"]?.toString(),
        modelId: json["model_id"],
        duration: json["duration"],
        modelType: json["model_type"],
        forwardMessageId: json["forward_message_id"],
        type: json["type"],
        callType: json["call_type"] ?? "audio",
        message: json["message"],
        tempId: json["temp_id"],
        readAt: json["read_at"],
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
            : NewMessageUserModel.fromJson(json["model"]),
        replyOn: json["reply_on"] == null
            ? null
            : NewMessageDataModel.fromJson(json["reply_on"]),
        attachments: json["attachments"] == null
            ? []
            : List<AttachmentModel>.from(
                json["attachments"]!.map((x) => AttachmentModel.fromJson(x))),
        mentions: json["mentions"] == null
            ? []
            : List<ConversationMentionModel>.from(json["mentions"]!
                .map((x) => ConversationMentionModel.fromJson(x))),
        reactions: json["reactions"] == null
            ? []
            : List<MessageReactionModel>.from(json["reactions"]!
                .map((x) => MessageReactionModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "conversation_id": conversationId,
        "model_id": modelId,
        "duration": duration,
        "model_type": modelType,
        "forward_message_id": forwardMessageId,
        "type": type,
        "message": message,
        "call_type": callType,
        "temp_id": tempId,
        "is_edited": isEdited,
        "deleted_at": deletedAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "read_at": readAt,
        "reply_on": replyOn?.toJson(),
        "auth_is_sender": authIsSender,
        "date_time_in_humans": dateTimeInHumans,
        "sender": sender,
        "model": model?.toJson(),
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
}

class NewMessageUserModel extends NewMessageUserModelEntity {
  const NewMessageUserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.email,
    super.emailVerifiedAt,
    super.phone,
    super.birthDate,
    super.address,
    super.fcmToken,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.teamId,
    super.ringCentralUsername,
    super.ringCentralExtension,
    super.ringCentralPassword,
    super.name,
    super.image,
    super.modelType,
    super.userDesignation,
  });

  factory NewMessageUserModel.fromJson(Map<String, dynamic> json) =>
      NewMessageUserModel(
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

  @override
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
}
