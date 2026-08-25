import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
  final int? id;
  final DateTime? requestedAt;
  final int? duration;
  final String? leaveType;
  final String? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? comments;
  final String? reason;

  const RequestEntity({
    this.id,
    this.requestedAt,
    this.duration,
    this.leaveType,
    this.status,
    this.fromDate,
    this.toDate,
    this.comments,
    this.reason,
  });

  Map<String, dynamic> toEntiy() => {
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

  @override
  List<Object?> get props => [
        id,
        requestedAt,
        duration,
        leaveType,
        status,
        fromDate,
        toDate,
        comments,
        reason,
      ];
}
