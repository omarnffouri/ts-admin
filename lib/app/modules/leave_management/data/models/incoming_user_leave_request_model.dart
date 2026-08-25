// To parse this JSON data, do
//
//     final usersRequestModel = usersRequestModelFromJson(jsonString);

import '../../domain/entities/incoming_user_leave_request_entity.dart';

class UserLeaveRequestModel extends UserLeaveRequestEntity {
  const UserLeaveRequestModel({
    super.id,
    super.requestedAt,
    super.remainingDays,
    super.duration,
    super.leaveType,
    super.status,
    super.fromDate,
    super.toDate,
    super.name,
    super.phoneNumber,
    super.department,
    super.designation,
    super.comments,
    super.reason,
  });

  factory UserLeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      UserLeaveRequestModel(
        id: json["id"],
        requestedAt: json["requestedAt"] == null
            ? null
            : DateTime.parse(json["requestedAt"]),
        remainingDays: json["balance"].toString(),
        duration: json["duration"] == 0 ? 1 : json["duration"],
        leaveType: json["leaveType"],
        status: json["status"],
        fromDate:
            json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
        toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        department: json["department"],
        designation: json["designation"],
        comments: json["comments"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requestedAt": requestedAt?.toIso8601String(),
        "balance": remainingDays,
        "duration": duration,
        "leaveType": leaveType,
        "status": status,
        "fromDate": fromDate?.toIso8601String(),
        "toDate": toDate?.toIso8601String(),
        "comments": comments,
        "name": name,
        "phoneNumber": phoneNumber,
        "department": department,
        "designation": designation,
        "reason": reason,
      };
}
