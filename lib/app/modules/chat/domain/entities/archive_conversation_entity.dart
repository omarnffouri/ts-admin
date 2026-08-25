import 'dart:convert';

import 'package:equatable/equatable.dart';

ArchiveConversationEntity archiveConversationEntityFromJson(String str) =>
    ArchiveConversationEntity.fromJson(json.decode(str));

String archiveConversationEntityToJson(ArchiveConversationEntity data) =>
    json.encode(data.toJson());

class ArchiveConversationEntity extends Equatable {
  final bool? error;
  final String? message;

  const ArchiveConversationEntity({this.error, this.message});

  factory ArchiveConversationEntity.fromJson(Map<String, dynamic> json) =>
      ArchiveConversationEntity(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {"error": error, "message": message};

  @override
  List<Object?> get props => [error, message];
}
