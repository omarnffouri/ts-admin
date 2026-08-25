import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/archive_conversation_entity.dart';

ArchiveConversationModel archiveConversationModelFromJson(String str) =>
    ArchiveConversationModel.fromJson(json.decode(str));

String archiveConversationModelToJson(ArchiveConversationModel data) =>
    json.encode(data.toJson());

class ArchiveConversationModel extends ArchiveConversationEntity {
  const ArchiveConversationModel({super.error, super.message});

  factory ArchiveConversationModel.fromJson(Map<String, dynamic> json) =>
      ArchiveConversationModel(
        error: json["error"],
        message: json["message"],
      );

  @override
  Map<String, dynamic> toJson() => {"error": error, "message": message};
}
