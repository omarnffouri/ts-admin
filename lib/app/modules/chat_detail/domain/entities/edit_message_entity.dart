// To parse this JSON data, do
//
//     final editMessageEntity = editMessageEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

EditMessageEntity editMessageEntityFromJson(String str) =>
    EditMessageEntity.fromJson(json.decode(str));

String editMessageEntityToJson(EditMessageEntity data) =>
    json.encode(data.toJson());

class EditMessageEntity extends Equatable {
  final bool? error;
  final String? message;
  final int? code;

  const EditMessageEntity({
    this.error,
    this.message,
    this.code,
  });

  factory EditMessageEntity.fromJson(Map<String, dynamic> json) =>
      EditMessageEntity(
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
  List<Object?> get props => [error, message, code];
}
