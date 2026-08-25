import '../../domain/entities/leave_history_entity.dart';

// To parse this JSON data, do
//
//     final leaveHistoryModel = leaveHistoryModelFromJson(jsonString);

class LeaveHistoryModel extends LeaveHistoryEntity {
  const LeaveHistoryModel({
    super.id,
    super.remainingDays,
    super.requestedAt,
    super.userName,
    super.phoneNumber,
    super.departmentName,
    super.designation,
    super.remainigDays,
    super.duration,
    super.leaveType,
    super.status,
    super.fromDate,
    super.toDate,
    super.comments,
    super.updatedAt,
    super.reason,
    super.updatedBy,
    super.updatedById,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) =>
      LeaveHistoryModel(
        id: json["id"],
        remainingDays: json["balance"].toString(),
        requestedAt: json["requestedAt"] == null
            ? null
            : DateTime.parse(json["requestedAt"]),
        userName: json["name"],
        phoneNumber: json["phoneNumber"],
        departmentName: json["department"],
        designation: json["designation"],
        remainigDays: json["balance"].toString(),
        duration: json["duration"] == 0 ? 1 : json["duration"],
        leaveType: json["leaveType"],
        status: json["status"],
        fromDate:
            json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
        toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
        comments: json["comments"],
        updatedAt:
            json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
        reason: json["reason"],
        updatedBy: json["updatedBy"],
        updatedById: json["updatedById"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": remainingDays,
        "requestedAt": requestedAt?.toIso8601String(),
        "userName": userName,
        "phoneNumber": phoneNumber,
        "departmentName": departmentName,
        "designation": designation,
        "remainigDays": remainigDays,
        "duration": duration,
        "leaveType": leaveType,
        "status": status,
        "fromDate": fromDate?.toIso8601String(),
        "toDate": toDate?.toIso8601String(),
        "comments": comments,
        "updatedAt": updatedAt?.toIso8601String(),
        "reason": reason,
        "updatedBy": updatedBy,
        "updatedById": updatedById,
      };

  @override
  List<Object?> get props => [
        id,
        remainingDays,
        requestedAt,
        duration,
        leaveType,
        status,
        fromDate,
        toDate,
        comments,
        updatedAt,
        reason,
        updatedBy,
        updatedById,
      ];
}
