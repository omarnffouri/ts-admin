// To parse this JSON data, do
//
//     final addParticipantsEntity = addParticipantsEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

AddParticipantsEntity addParticipantsEntityFromJson(String str) =>
    AddParticipantsEntity.fromJson(json.decode(str));

String addParticipantsEntityToJson(AddParticipantsEntity data) =>
    json.encode(data.toJson());

class AddParticipantsEntity extends Equatable {
  final bool? error;
  final String? message;
  final int? code;

  const AddParticipantsEntity({
    this.error,
    this.message,
    this.code,
  });

  factory AddParticipantsEntity.fromJson(Map<String, dynamic> json) =>
      AddParticipantsEntity(
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
