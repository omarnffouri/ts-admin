import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';

class MessageNotificationResponseEntity extends Equatable {
  final List<MessageNotificationEntity>? data;
  final MessageNotificationPaginationEntity? pagination;

  const MessageNotificationResponseEntity({
    this.data,
    this.pagination,
  });

  factory MessageNotificationResponseEntity.fromJson(
          Map<String, dynamic> json) =>
      MessageNotificationResponseEntity(
        data: json["data"] == null
            ? []
            : List<MessageNotificationEntity>.from(json["data"]!
                .map((x) => MessageNotificationEntity.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : MessageNotificationPaginationEntity.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };

  @override
  List<Object?> get props => [
        data,
        pagination,
      ];
}

class MessageNotificationEntity extends Equatable {
  final ConversationMessageEntity? message;
  final MessageNotificationGroupEntity? group;

  final RxBool viewed = false.obs;
  final RxBool read = false.obs;

  MessageNotificationEntity({
    this.message,
    this.group,
  });

  factory MessageNotificationEntity.fromJson(Map<String, dynamic> json) =>
      MessageNotificationEntity(
        message: ConversationMessageEntity.fromJson(json),
        group: json["group"] == null
            ? null
            : MessageNotificationGroupEntity.fromJson(json["group"]),
      );

  Map<String, dynamic> toJson() => {
        ...(message?.toJson() ?? {}),
        "group": group?.toJson(),
      };

  @override
  List<Object?> get props => [
        message,
        group,
      ];
}

class MessageNotificationGroupEntity extends Equatable {
  final int? id;
  final String? name;

  const MessageNotificationGroupEntity({
    this.id,
    this.name,
  });

  factory MessageNotificationGroupEntity.fromJson(Map<String, dynamic> json) =>
      MessageNotificationGroupEntity(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}

// ignore: must_be_immutable
class MessageNotificationPaginationEntity extends Equatable {
  final int? currentPage;
  int? total;
  final int? perPage;

  MessageNotificationPaginationEntity({
    this.currentPage,
    this.total,
    this.perPage,
  });

  factory MessageNotificationPaginationEntity.fromJson(
          Map<String, dynamic> json) =>
      MessageNotificationPaginationEntity(
        currentPage: json["current_page"],
        total: json["total"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total": total,
        "per_page": perPage,
      };

  @override
  List<Object?> get props => [
        currentPage,
        total,
        perPage,
      ];
}
