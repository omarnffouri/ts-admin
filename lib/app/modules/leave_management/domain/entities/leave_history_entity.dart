import 'package:equatable/equatable.dart';

// To parse this JSON data, do
//
//     final leaveHistoryModel = leaveHistoryModelFromJson(jsonString);

class LeaveHistoryEntity extends Equatable {
  final int? id;
  final String? remainingDays;
  final int? duration;
  final String? userName;
  final String? phoneNumber;
  final String? departmentName;
  final String? designation;
  final String? remainigDays;
  final String? leaveType;
  final String? status;
  final String? comments;
  final String? reason;
  final DateTime? requestedAt;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? updatedById;
  final String? updatedBy;
  final DateTime? updatedAt;

  const LeaveHistoryEntity({
    this.id,
    this.remainingDays,
    this.requestedAt,
    this.userName,
    this.phoneNumber,
    this.departmentName,
    this.designation,
    this.remainigDays,
    this.duration,
    this.leaveType,
    this.status,
    this.fromDate,
    this.toDate,
    this.comments,
    this.reason,
    this.updatedBy,
    this.updatedById,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        remainingDays,
        requestedAt,
        userName,
        phoneNumber,
        departmentName,
        designation,
        remainigDays,
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
