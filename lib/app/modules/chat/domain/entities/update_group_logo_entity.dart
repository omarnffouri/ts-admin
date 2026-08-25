// To parse this JSON data, do
//
//     final updateGroupNameEntity = updateGroupNameEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

UpdateGroupLogoEntity updateGroupNameEntityFromJson(String str) =>
    UpdateGroupLogoEntity.fromJson(json.decode(str));

String updateGroupNameEntityToJson(UpdateGroupLogoEntity data) =>
    json.encode(data.toJson());

class UpdateGroupLogoEntity extends Equatable {
  final bool? error;
  final String? message;
  final String? data;
  final int? code;

  const UpdateGroupLogoEntity({
    this.error,
    this.message,
    this.data,
    this.code,
  });

  factory UpdateGroupLogoEntity.fromJson(Map<String, dynamic> json) =>
      UpdateGroupLogoEntity(
        error: json["error"],
        message: json["message"],
        data: json["data"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data,
        "code": code,
      };

  @override
  List<Object?> get props => [
        error,
        message,
        code,
        data,
      ];
}
