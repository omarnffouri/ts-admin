// To parse this JSON data, do
//
//     final conversationDetailsModel = conversationDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';

ConversationDetailsModel conversationDetailsModelFromJson(String str) =>
    ConversationDetailsModel.fromJson(json.decode(str));

String conversationDetailsModelToJson(ConversationDetailsModel data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class ConversationDetailsModel extends ConversationDetailsEntity {
  ConversationDetailsModel({
    super.id,
    super.isPrivate,
    super.modelId,
    super.modelType,
    super.type,
    super.groupName,
    super.receiver,
    super.participants,
    super.messages,
  });

  factory ConversationDetailsModel.fromJson(Map<String, dynamic> json) =>
      ConversationDetailsModel(
          id: json["id"],
          isPrivate: json["is_private"],
          modelId: json["model_id"],
          modelType: modelTypeValues.map[json["model_type"]],
          type: json["type"],
          groupName: json["group_name"],
          participants: json["participants"] == null
              ? null
              : List<ConversationWithParticipentModel>.from(
                  json["participants"]!.map(
                      (x) => ConversationWithParticipentModel.fromJson(x))),
          messages: json["messages"] == null
              ? []
              : List<ConversationMessageModel>.from(json["messages"]!
                  .map((x) => ConversationMessageModel.fromJson(x))),
          receiver: json["receiver"] == null
              ? null
              : ConversationDetailsReciverModel.fromJson(json["receiver"]));

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "is_private": isPrivate,
        "model_id": modelId,
        "model_type": modelTypeValues.reverse[modelType],
        "group_name": groupName,
        "type": type,
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
        "receiver": receiver?.toJson()
      };
}

// ignore: must_be_immutable
class ConversationMessageModel extends ConversationMessageEntity {
  ConversationMessageModel({
    super.id,
    super.conversationId,
    super.modelType,
    super.modelId,
    super.type,
    super.message,
    super.deletedAt,
    super.createdAt,
    super.updatedAt,
    super.duration,
    super.callType,
    super.location,
    super.readBy,
    super.forwardMessageId,
    super.authIsSender,
    super.mentions,
    super.replyOn,
    super.dateTimeInHumans,
    super.sender,
    super.model,
    super.tempId,
    super.isEdited,
    super.attachments,
    super.readAt,
    super.reactions,
  });

  factory ConversationMessageModel.fromJson(Map<String, dynamic> json) =>
      ConversationMessageModel(
        id: json["id"],
        duration: json["duration"],
        conversationId: json["conversation_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        callType: json["call_type"] ?? "audio",
        type: json["type"],
        message: json["message"],
        location: json["location"] == null
            ? null
            : LocationModel.fromJson(json["location"]),
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
        readAt: json["read_at"],
        isEdited: json["is_edited"] == null ? false : json['is_edited'],
        dateTimeInHumans: json["date_time_in_humans"],
        forwardMessageId: json["forward_message_id"],
        sender: json["sender"],
        tempId: json["temp_id"],
        readBy: json["read_by"] == null
            ? []
            : List<ReadByModel>.from(
                json["read_by"]!.map((x) => ReadByModel.fromJson(x))),
        model: json["model"] == null
            ? null
            : ConversationUserModel.fromJson(json["model"]),
        replyOn: json["reply_on"] == null
            ? null
            : ConversationMessageModel.fromJson(json["reply_on"]),
        mentions: json["mentions"] == null
            ? []
            : List<ConversationMentionModel>.from(json["mentions"]!
                .map((x) => ConversationMentionModel.fromJson(x))),
        attachments: json["attachments"] == null
            ? []
            : List<AttachmentModel>.from(
                json["attachments"]!.map((x) => AttachmentModel.fromJson(x))),
        reactions: json["reactions"] == null
            ? []
            : List<MessageReactionModel>.from(json["reactions"]!
                .map((x) => MessageReactionModel.fromJson(x))),
      );

  static ConversationMessageModel? fromJsonAndNullable(
      Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversationMessageModel(
      id: json["id"],
      duration: json["duration"],
      conversationId: json["conversation_id"],
      modelType: json["model_type"],
      modelId: json["model_id"],
      type: json["type"],
      location: json["location"] == null
          ? null
          : LocationModel.fromJson(json["location"]),
      forwardMessageId: json["forward_message_id"],
      callType: json["call_type"] ?? "audio",
      message: json["message"],
      tempId: json["temp_id"],
      isEdited: json["is_edited"] == null ? false : json['is_edited'],
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
      readAt: json["read_at"],
      readBy: json["read_by"] == null
          ? []
          : List<ReadByModel>.from(
              json["read_by"]!.map((x) => ReadByModel.fromJson(x))),
      dateTimeInHumans: json["date_time_in_humans"],
      sender: json["sender"],
      model: json["model"] == null
          ? null
          : ConversationUserModel.fromJson(json["model"]),
      replyOn: json["reply_on"] == null
          ? null
          : ConversationMessageModel.fromJson(json["reply_on"]),
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
          : List<MessageReactionModel>.from(
              json["reactions"]!.map((x) => MessageReactionModel.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "model_type": modelType,
        "model_id": modelId,
        "type": type,
        "duration": duration,
        "call_type": callType,
        "forward_message_id": forwardMessageId,
        "is_edited": isEdited,
        "message": message,
        "deleted_at": deletedAt?.toIso8601String(),
        "read_at": readAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "auth_is_sender": authIsSender,
        "date_time_in_humans": dateTimeInHumans,
        "sender": sender,
        "model": model?.toJson(),
        "temp_id": tempId,
        "reply_on": replyOn?.toJson(),
        "read_by": readBy == null
            ? []
            : List<dynamic>.from(readBy!.map((x) => x.toJson())),
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

class ConversationUserModel extends ConversationUserModelEntity {
  const ConversationUserModel({
    super.id,
    super.name,
    super.image,
    super.email,
    super.phone,
    super.modelType,
    super.userDesignation,
  });

  factory ConversationUserModel.fromJson(Map<String, dynamic> json) =>
      ConversationUserModel(
          id: json["id"],
          name: json["name"],
          image: json["image"],
          email: json["email"],
          phone: json["phone"],
          modelType: json["model_type"],
          userDesignation: json["user_designation"]);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "email": email,
        "phone": phone,
        "model_type": modelType,
        "user_designation": userDesignation,
      };
}

// ignore: must_be_immutable
class ConversationWithParticipentModel
    extends ConversationWithParticipentEntity {
  ConversationWithParticipentModel({
    super.id,
    super.phone,
    super.name,
    super.image,
    super.modelType,
    super.userDesignation,
    super.pId,
    super.isGroupAdmin,
  });

  factory ConversationWithParticipentModel.fromJson(
          Map<String, dynamic> json) =>
      ConversationWithParticipentModel(
        id: json["id"],
        phone: json["phone"],
        pId: json["p_id"],
        name: json["name"],
        image: json["image"],
        modelType: json["model_type"],
        isGroupAdmin: json["is_group_admin"],
        userDesignation: json["user_designation"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "name": name,
        "image": image,
        "model_type": modelType,
        "p_id": pId,
        "is_group_admin": isGroupAdmin,
        "user_designation": userDesignation,
      };
}

// ignore: must_be_immutable
class ReadByModel extends ReadByEntity {
  ReadByModel({
    super.id,
    super.pid,
    super.messageId,
    super.modelType,
    super.modelId,
    super.readByUser,
    super.createdAt,
    super.updatedAt,
  });

  factory ReadByModel.fromJson(Map<String, dynamic> json) => ReadByModel(
        id: json["id"],
        pid: json["p_id"],
        messageId: json["message_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        // user: json["model"] == null
        //     ? null
        //     : ReadByUserModel.fromJson(json["model"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "p_id": pid,
        "message_id": messageId,
        "model_type": modelType,
        "model_id": modelId,
        // "model": user?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

// ignore: must_be_immutable
class ConversationDetailsReciverModel extends ConversationDetailsReciverEntity {
  ConversationDetailsReciverModel({
    super.id,
    super.phone,
    super.name,
    super.image,
    super.modelType,
  });

  factory ConversationDetailsReciverModel.fromJson(Map<String, dynamic> json) =>
      ConversationDetailsReciverModel(
        id: json["id"],
        phone: json["phone"],
        modelType: json["model_type"],
        name: json["name"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "model_type": modelType,
        "name": name,
        "image": image,
      };
}

// ignore: must_be_immutable
class ReadByUserModel extends ReadByUserEntity {
  ReadByUserModel(
      {super.id,
      super.phone,
      super.name,
      super.image,
      super.modelType,
      super.userDesignation});

  factory ReadByUserModel.fromJson(Map<String, dynamic> json) =>
      ReadByUserModel(
        id: json["id"],
        phone: json["phone"],
        modelType: json["model_type"],
        name: json["name"],
        image: json["image"],
        userDesignation: json["user_designation"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "model_type": modelType,
        "name": name,
        "image": image,
        "user_designation": userDesignation
      };
}

class ConversationMentionModel extends ConversationMentionEntity {
  const ConversationMentionModel({
    super.id,
    super.messageId,
    super.modelType,
    super.modelId,
    super.user,
    super.participantId,
    super.createdAt,
    super.updatedAt,
  });

  factory ConversationMentionModel.fromJson(Map<String, dynamic> json) =>
      ConversationMentionModel(
        id: json["id"],
        messageId: json["echo_message_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        participantId: json["participant_id"],
        user: json["model"] == null
            ? null
            : MentionUserModel.fromJson(json["model"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "echo_message_id": messageId,
        "participant_id": participantId,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "model": user?.toJson(),
      };
}

class MentionUserModel extends MentionUserModelEntity {
  const MentionUserModel({
    super.id,
    super.name,
    super.image,
    super.phone,
    super.modelType,
    super.designation,
  });

  factory MentionUserModel.fromJson(Map<String, dynamic> json) =>
      MentionUserModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        phone: json["phone"],
        modelType: json["model_type"],
        designation: json["user_designation"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "phone": phone,
        "model_type": modelType,
        "user_designation": designation,
      };
}

// ignore: must_be_immutable
class MessageReactionModel extends MessageReactionEntity {
  MessageReactionModel({
    super.id,
    super.pId,
    super.reaction,
  });

  factory MessageReactionModel.fromJson(Map<String, dynamic> json) =>
      MessageReactionModel(
        id: json["id"],
        pId: json["p_id"],
        reaction: json["reaction"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "p_id": pId,
        "reaction": reaction,
      };
}

// ignore: must_be_immutable
class AttachmentModel extends AttachmentEntity {
  AttachmentModel({
    super.fileName,
    super.id,
    super.mimeType,
    super.size,
    super.thumbUrl,
    super.url,
    super.uuid,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      AttachmentModel(
        fileName: json["file_name"],
        id: json["id"],
        mimeType: json["mime_type"],
        size: json["size"],
        thumbUrl: json["thumb_url"],
        url: json["url"],
        uuid: json["uuid"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "file_name": fileName,
        "id": id,
        "mime_type": mimeType,
        "size": size,
        "thumb_url": thumbUrl,
        "url": url,
        "uuid": uuid,
      };
}
