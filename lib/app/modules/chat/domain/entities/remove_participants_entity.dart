// To parse this JSON data, do
//
//     final addParticipantsEntity = addParticipantsEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

RemoveParticipantsEntity removeParticipantsEntityFromJson(String str) =>
    RemoveParticipantsEntity.fromJson(json.decode(str));

String removeParticipantsEntityToJson(RemoveParticipantsEntity data) =>
    json.encode(data.toJson());

class RemoveParticipantsEntity extends Equatable {
  final bool? error;
  final String? message;
  final int? code;

  const RemoveParticipantsEntity({
    this.error,
    this.message,
    this.code,
  });

  factory RemoveParticipantsEntity.fromJson(Map<String, dynamic> json) =>
      RemoveParticipantsEntity(
        error: json["error"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "code": code,
      };

  @override
  List<Object?> get props => [
        error,
        message,
        code,
      ];
}
