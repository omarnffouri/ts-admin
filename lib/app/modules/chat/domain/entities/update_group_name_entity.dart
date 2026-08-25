// To parse this JSON data, do
//
//     final updateGroupNameEntity = updateGroupNameEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

UpdateGroupNameEntity updateGroupNameEntityFromJson(String str) =>
    UpdateGroupNameEntity.fromJson(json.decode(str));

String updateGroupNameEntityToJson(UpdateGroupNameEntity data) =>
    json.encode(data.toJson());

class UpdateGroupNameEntity extends Equatable {
  final bool? error;
  final String? message;
  final int? code;

  const UpdateGroupNameEntity({
    this.error,
    this.message,
    this.code,
  });

  factory UpdateGroupNameEntity.fromJson(Map<String, dynamic> json) =>
      UpdateGroupNameEntity(
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
