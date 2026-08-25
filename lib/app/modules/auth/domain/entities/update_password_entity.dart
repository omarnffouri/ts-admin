// To parse this JSON data, do
//
//     final updateProfileDataEntity = updateProfileDataEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

UpdatePasswordEntity updatePasswordEntityFromJson(String str) =>
    UpdatePasswordEntity.fromJson(json.decode(str));

String updatePasswordEntityToJson(UpdatePasswordEntity data) =>
    json.encode(data.toJson());

class UpdatePasswordEntity extends Equatable {
  final String? message;
  final int? code;

  const UpdatePasswordEntity({
    this.message,
    this.code,
  });

  factory UpdatePasswordEntity.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordEntity(message: json["message"], code: json["code"]);

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
      };

  @override
  List<Object?> get props => [
        message,
        code,
      ];
}
