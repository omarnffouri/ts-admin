import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';

class MessageNotificationResponseModel
    extends MessageNotificationResponseEntity {
  const MessageNotificationResponseModel({
    super.data,
    super.pagination,
  });

  factory MessageNotificationResponseModel.fromJson(
          Map<String, dynamic> json) =>
      MessageNotificationResponseModel(
        data: json["data"] == null
            ? []
            : List<MessageNotificationModel>.from(
                json["data"]!.map((x) => MessageNotificationModel.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : MessageNotificationPaginationModel.fromJson(json["pagination"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class MessageNotificationModel extends MessageNotificationEntity {
  MessageNotificationModel({
    super.message,
    super.group,
  });

  factory MessageNotificationModel.fromJson(Map<String, dynamic> json) =>
      MessageNotificationModel(
        message: ConversationMessageModel.fromJson(json),
        group: json["group"] == null
            ? null
            : MessageNotificationGroupModel.fromJson(json["group"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        ...(message?.toJson() ?? {}),
        "group": group?.toJson(),
      };
}

class MessageNotificationGroupModel extends MessageNotificationGroupEntity {
  const MessageNotificationGroupModel({
    super.id,
    super.name,
  });

  factory MessageNotificationGroupModel.fromJson(Map<String, dynamic> json) =>
      MessageNotificationGroupModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// ignore: must_be_immutable
class MessageNotificationPaginationModel
    extends MessageNotificationPaginationEntity {
  MessageNotificationPaginationModel({
    super.currentPage,
    super.total,
    super.perPage,
  });

  factory MessageNotificationPaginationModel.fromJson(
          Map<String, dynamic> json) =>
      MessageNotificationPaginationModel(
        currentPage: json["current_page"],
        total: json["total"],
        perPage: json["per_page"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total": total,
        "per_page": perPage,
      };
}
