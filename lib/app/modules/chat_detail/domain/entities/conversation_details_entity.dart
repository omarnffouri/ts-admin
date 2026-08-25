// To parse this JSON data, do
//
//     final conversationDetailsModel = conversationDetailsModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';

ConversationDetailsEntity conversationDetailsModelFromJson(String str) =>
    ConversationDetailsEntity.fromJson(json.decode(str));

String conversationDetailsModelToJson(ConversationDetailsEntity data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class ConversationDetailsEntity extends Equatable {
  final int? id;
  final int? isPrivate;
  final int? modelId;
  final ModelType? modelType;
  final String? type;
  final String? groupName;
  final ConversationDetailsReciverEntity? receiver;
  final List<ConversationWithParticipentEntity>? participants;
  List<ConversationMessageEntity>? messages;

  ConversationDetailsEntity({
    this.id,
    this.isPrivate,
    this.modelId,
    this.modelType,
    this.receiver,
    this.type,
    this.groupName,
    this.participants,
    this.messages,
  });

  factory ConversationDetailsEntity.fromJson(Map<String, dynamic> json) =>
      ConversationDetailsEntity(
        id: json["id"],
        isPrivate: json["is_private"],
        modelId: json["model_id"],
        modelType: modelTypeValues.map[json["model_type"]],
        type: json["type"],
        groupName: json["group_name"],
        participants: json["participants"] == null
            ? null
            : List<ConversationWithParticipentEntity>.from(json["participants"]!
                .map((x) => ConversationWithParticipentEntity.fromJson(x))),
        messages: json["messages"] == null
            ? []
            : List<ConversationMessageEntity>.from(json["messages"]!
                .map((x) => ConversationMessageEntity.fromJson(x))),
        receiver: json["receiver"] == null
            ? null
            : ConversationDetailsReciverEntity.fromJson(json["receiver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_private": isPrivate,
        "model_id": modelId,
        "model_type": modelTypeValues.reverse[modelType],
        "type": type,
        "group_name": groupName,
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
        "receiver": receiver?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        isPrivate,
        modelId,
        modelType,
        type,
        participants,
        messages,
        receiver,
        groupName
      ];
}

// ignore: must_be_immutable
class ConversationMessageEntity extends Equatable {
  int? id;
  dynamic conversationId;
  final String? modelType;
  final int? modelId;
  final int? forwardMessageId;
  int? duration;
  ConversationMessageEntity? replyOn;
  final String? type;
  String? message;
  LocationModel? location;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  final bool? authIsSender;
  final String? dateTimeInHumans;
  final String? callType;
  final dynamic sender;
  ConversationUserModelEntity? model;
  final String? tempId;
  String? readAt;
  List<AttachmentEntity>? attachments;
  List<ReadByEntity>? readBy;
  final List<ConversationMentionEntity>? mentions;
  List<MessageReactionEntity>? reactions;
  bool sendedNow = false;
  bool sentSuccessfully = false;
  bool? isEdited;

  ConversationMessageEntity({
    this.id,
    this.conversationId,
    this.modelType,
    this.modelId,
    this.type,
    this.message,
    this.deletedAt,
    this.readBy,
    this.replyOn,
    this.createdAt,
    this.updatedAt,
    this.authIsSender,
    this.location,
    this.mentions,
    this.dateTimeInHumans,
    this.sender,
    this.callType,
    this.model,
    this.tempId,
    this.isEdited,
    this.duration,
    this.readAt,
    this.forwardMessageId,
    this.reactions,
    this.attachments,
  });

  factory ConversationMessageEntity.fromJson(Map<String, dynamic> json) =>
      ConversationMessageEntity(
        id: json["id"],
        duration: json["duration"],
        conversationId: json["conversation_id"],
        modelType: json["model_type"],
        forwardMessageId: json["forward_message_id"],
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
            : DateTime.parse(json["updated_at"]).toLocal(),
        authIsSender: json["auth_is_sender"],
        dateTimeInHumans: json["date_time_in_humans"],
        sender: json["sender"],
        readAt: json["read_at"],
        tempId: json["temp_id"],
        isEdited: json["is_edited"] == null ? false : json['is_edited'],
        model: json["model"] == null
            ? null
            : ConversationUserModelEntity.fromJson(json["model"]),
        replyOn: json["reply_on"] == null
            ? null
            : ConversationMessageEntity.fromJson(json["reply_on"]),
        attachments: json["attachments"] == null
            ? []
            : List<AttachmentEntity>.from(
                json["attachments"]!.map((x) => AttachmentEntity.fromJson(x))),
        readBy: json["read_by"] == null
            ? []
            : List<ReadByEntity>.from(
                json["read_by"]!.map((x) => ReadByEntity.fromJson(x))),
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
        "id": id,
        "conversation_id": conversationId,
        "model_type": modelType,
        "forward_message_id": forwardMessageId,
        "model_id": modelId,
        "type": type,
        "duration": duration,
        "call_type": callType,
        "message": message,
        'location': location?.toJson(),
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "auth_is_sender": authIsSender,
        "date_time_in_humans": dateTimeInHumans,
        "temp_id": tempId,
        "is_edited": isEdited,
        "sender": sender,
        "read_at": readAt,
        "model": model?.toJson(),
        "reply_on": replyOn?.toJson(),
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "mentions": mentions == null
            ? []
            : List<dynamic>.from(mentions!.map((x) => x.toJson())),
        "read_by": readBy == null
            ? []
            : List<dynamic>.from(readBy!.map((x) => x.toJson())),
        "reactions": reactions == null
            ? []
            : List<dynamic>.from(reactions!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        id,
        conversationId,
        modelType,
        modelId,
        type,
        forwardMessageId,
        message,
        deletedAt,
        createdAt,
        replyOn,
        callType,
        updatedAt,
        readBy,
        duration,
        authIsSender,
        dateTimeInHumans,
        sender,
        model,
        readAt,
        mentions,
        tempId,
        isEdited,
        attachments,
        reactions,
      ];
}

class ConversationUserModelEntity extends Equatable {
  final int? id;
  final String? name;
  final String? image;
  final String? email;
  final String? phone;
  final String? modelType;
  final String? userDesignation;

  const ConversationUserModelEntity({
    this.id,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.modelType,
    this.userDesignation,
  });

  factory ConversationUserModelEntity.fromJson(Map<String, dynamic> json) =>
      ConversationUserModelEntity(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        email: json["email"],
        phone: json["phone"],
        modelType: json["model_type"],
        userDesignation: json["user_designation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "email": email,
        "phone": phone,
        "model_type": modelType,
        "user_designation": userDesignation,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        email,
        phone,
        modelType,
        userDesignation,
      ];
}

// ignore: must_be_immutable
class ConversationWithParticipentEntity extends Equatable {
  final int? id;
  final String? phone;
  final String? name;
  final String? image;
  final String? userDesignation;
  final String? modelType;
  bool? isGroupAdmin;
  final int? pId;

  ConversationWithParticipentEntity(
      {this.id,
      this.phone,
      this.name,
      this.image,
      this.userDesignation,
      this.pId,
      this.modelType,
      this.isGroupAdmin});

  factory ConversationWithParticipentEntity.fromJson(
          Map<String, dynamic> json) =>
      ConversationWithParticipentEntity(
        id: json["id"],
        pId: json["p_id"],
        phone: json["phone"],
        name: json["name"],
        image: json["image"],
        modelType: json["model_type"],
        userDesignation: json["user_designation"],
        isGroupAdmin: json["is_group_admin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "name": name,
        "image": image,
        "user_designation": userDesignation,
        "p_id": pId,
        "model_type": modelType,
        "is_group_admin": isGroupAdmin,
      };

  @override
  List<Object?> get props =>
      [id, phone, name, image, modelType, userDesignation, isGroupAdmin, pid];
}

class LocationModel extends Equatable {
  final double? lat, lng;

  const LocationModel({this.lat, this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  @override
  List<Object?> get props => [lat, lng];
}

// ignore: must_be_immutable
class ReadByEntity extends Equatable {
  final int? id;
  final int? pid;
  final int? messageId;
  final String? modelType;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  ReadByUserEntity? readByUser;

  ReadByEntity({
    this.id,
    this.pid,
    this.messageId,
    this.modelType,
    this.modelId,
    this.readByUser,
    this.createdAt,
    this.updatedAt,
  });

  factory ReadByEntity.fromJson(Map<String, dynamic> json) => ReadByEntity(
        id: json["id"],
        pid: json["p_id"],
        messageId: json["message_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        // user: json["model"] == null
        //     ? null
        //     : ReadByUserEntity.fromJson(json["model"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "p_id": pid,
        "message_id": messageId,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        // "model": user?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        pid,
        messageId,
        modelType,
        modelId,
        // user,
        createdAt,
        updatedAt,
      ];
}

// ignore: must_be_immutable
class ConversationDetailsReciverEntity extends Equatable {
  int? id;
  String? phone;
  String? name;
  String? image;
  String? modelType;

  ConversationDetailsReciverEntity({
    this.id,
    this.phone,
    this.name,
    this.image,
    this.modelType,
  });

  factory ConversationDetailsReciverEntity.fromJson(
          Map<String, dynamic> json) =>
      ConversationDetailsReciverEntity(
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
class ReadByUserEntity extends Equatable {
  int? id;
  String? phone;
  String? name;
  String? image;
  String? modelType;
  String? userDesignation;

  ReadByUserEntity({
    this.id,
    this.phone,
    this.name,
    this.image,
    this.userDesignation,
    this.modelType,
  });

  factory ReadByUserEntity.fromJson(Map<String, dynamic> json) =>
      ReadByUserEntity(
        id: json["id"],
        phone: json["phone"],
        modelType: json["model_type"],
        name: json["name"],
        image: json["image"],
        userDesignation: json["user_designation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "model_type": modelType,
        "name": name,
        "image": image,
        "user_designation": userDesignation
      };

  @override
  List<Object?> get props =>
      [id, modelType, phone, name, image, userDesignation];
}

class ConversationMentionEntity extends Equatable {
  final int? id;
  final int? messageId;
  final int? participantId;
  final String? modelType;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final MentionUserModelEntity? user;

  const ConversationMentionEntity({
    this.id,
    this.messageId,
    this.modelType,
    this.modelId,
    this.user,
    this.participantId,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationMentionEntity.fromJson(Map<String, dynamic> json) =>
      ConversationMentionEntity(
        id: json["id"],
        messageId: json["echo_message_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        participantId: json["participant_id"],
        user: json["model"] == null
            ? null
            : MentionUserModelEntity.fromJson(json["model"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

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

  @override
  List<Object?> get props => [
        id,
        messageId,
        modelType,
        modelId,
        participantId,
        user,
        createdAt,
        updatedAt,
      ];
}

class MentionUserModelEntity extends Equatable {
  final int? id;
  final String? name;
  final String? image;
  final String? phone;
  final String? modelType;
  final String? designation;

  const MentionUserModelEntity({
    this.id,
    this.name,
    this.image,
    this.phone,
    this.modelType,
    this.designation,
  });

  factory MentionUserModelEntity.fromJson(Map<String, dynamic> json) =>
      MentionUserModelEntity(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        phone: json["phone"],
        modelType: json["model_type"],
        designation: json["user_designation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "phone": phone,
        "model_type": modelType,
        "user_designation": designation
      };

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        phone,
        modelType,
        designation,
      ];
}

// ignore: must_be_immutable
class MessageReactionEntity extends Equatable {
  final int? id;
  final int? pId;
  String? reaction;

  //
  //
  // not form the api maually added
  ConversationWithParticipentEntity? reactedBy;

  MessageReactionEntity({this.id, this.pId, this.reaction, this.reactedBy});

  factory MessageReactionEntity.fromJson(Map<String, dynamic> json) =>
      MessageReactionEntity(
        id: json["id"],
        pId: json["p_id"],
        reaction: json["reaction"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "p_id": pId,
        "reaction": reaction,
      };

  @override
  List<Object?> get props => [
        id,
        pId,
        reaction,
      ];
}

// ignore: must_be_immutable
class AttachmentEntity extends Equatable {
  final String? fileName;
  final int? id;
  String? mimeType;
  final int? size;
  final String? thumbUrl;
  final String? url;
  final String? uuid;

  bool sendedNow = false;
  bool sending = false;
  RxDouble downloadProgress = (0.0).obs;
  RxBool isDownloading = false.obs;
  bool sendedSuccessfully = false;
  File? file;
  String attachmentType = MessageTypes.attachment;

  AttachmentEntity({
    this.fileName,
    this.id,
    this.mimeType,
    this.size,
    this.thumbUrl,
    this.url,
    this.uuid,
  });

  factory AttachmentEntity.fromJson(Map<String, dynamic> json) =>
      AttachmentEntity(
        fileName: json["file_name"],
        id: json["id"],
        mimeType: json["mime_type"],
        size: json["size"],
        thumbUrl: json["thumb_url"],
        url: json["url"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "file_name": fileName,
        "id": id,
        "mime_type": mimeType,
        "size": size,
        "thumb_url": thumbUrl,
        "url": url,
        "uuid": uuid,
      };

  @override
  List<Object?> get props => [
        fileName,
        id,
        mimeType,
        size,
        thumbUrl,
        url,
        uuid,
      ];
}
