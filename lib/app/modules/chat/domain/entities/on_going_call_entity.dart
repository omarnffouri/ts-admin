// To parse this JSON data, do
//
//     final ongoingCallEntity = ongoingCallEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';

OngoingCallEntity ongoingCallEntityFromJson(String str) =>
    OngoingCallEntity.fromJson(json.decode(str));

String ongoingCallEntityToJson(OngoingCallEntity data) =>
    json.encode(data.toJson());

class OngoingCallEntity extends Equatable {
  final int? id;
  final int? conversationId;
  final String? modelType;
  final int? modelId;
  final String? type;
  final int? duration;
  final String? message;
  final String? callType;
  final DateTime? createdAt;
  final dynamic tempId;
  final ConversationUserModelEntity? model;
  final RxBool isAccepted = false.obs;

  OngoingCallEntity({
    this.id,
    this.conversationId,
    this.modelType,
    this.modelId,
    this.type,
    this.duration,
    this.message,
    this.callType,
    this.createdAt,
    this.tempId,
    this.model,
  });

  factory OngoingCallEntity.fromJson(Map<String, dynamic> json) =>
      OngoingCallEntity(
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
            : ConversationUserModelEntity.fromJson(json["model"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        tempId: json["temp_id"],
      );

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

  @override
  List<Object?> get props => [
        id,
        conversationId,
        modelType,
        modelId,
        type,
        model,
        duration,
        message,
        callType,
        createdAt,
        tempId,
      ];
}
