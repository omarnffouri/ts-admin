import '../../domain/entities/requested_leave_entity.dart';

class RequestModel extends RequestEntity {
  const RequestModel({
    super.id,
    super.requestedAt,
    super.duration,
    super.leaveType,
    super.status,
    super.fromDate,
    super.toDate,
    super.comments,
    super.reason,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        requestedAt: json["requestedAt"] == null
            ? null
            : DateTime.parse(json["requestedAt"]),
        duration: json["duration"] == 0 ? 1 : json["duration"],
        leaveType: json["leaveType"],
        status: json["status"],
        fromDate:
            json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
        toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
        comments: json["comments"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requestedAt": requestedAt?.toIso8601String(),
        "duration": duration,
        "leaveType": leaveType,
        "status": status,
        "fromDate": fromDate?.toIso8601String(),
        "toDate": toDate?.toIso8601String(),
        "comments": comments,
        "reason": reason,
      };
}
