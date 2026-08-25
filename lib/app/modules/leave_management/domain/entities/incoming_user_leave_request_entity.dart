// To parse this JSON data, do
//
//     final usersRequestModel = usersRequestModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

class UserLeaveRequestEntity extends Equatable {
  final int? id;
  final DateTime? requestedAt;
  final String? remainingDays;
  final int? duration;
  final String? leaveType;
  final String? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? name;
  final String? phoneNumber;
  final String? department;
  final String? designation;
  final String? comments;
  final String? reason;

  const UserLeaveRequestEntity({
    this.id,
    this.requestedAt,
    this.remainingDays,
    this.duration,
    this.leaveType,
    this.status,
    this.fromDate,
    this.toDate,
    this.name,
    this.phoneNumber,
    this.department,
    this.designation,
    this.comments,
    this.reason,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "requestedAt": requestedAt?.toIso8601String(),
        "balance": remainingDays,
        "duration": duration,
        "leaveType": leaveType,
        "status": status,
        "fromDate": fromDate?.toIso8601String(),
        "toDate": toDate?.toIso8601String(),
        "name": name,
        "phoneNumber": phoneNumber,
        "department": department,
        "designation": designation,
        "comments": comments,
        "reason": reason,
      };

  @override
  List<Object?> get props => [
        id,
        requestedAt,
        duration,
        leaveType,
        status,
        fromDate,
        toDate,
        name,
        phoneNumber,
        department,
        designation,
        comments,
        reason,
      ];
}
