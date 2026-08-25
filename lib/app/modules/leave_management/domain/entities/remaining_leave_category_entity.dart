import 'package:equatable/equatable.dart';

class RemainingLeaveCategoryEntity extends Equatable {
  final int? leaveTypeId;
  final String? leaveType;
  final String? total;
  final String? remaining;

  const RemainingLeaveCategoryEntity({
    this.leaveTypeId,
    this.leaveType,
    this.total,
    this.remaining,
  });

  @override
  List<Object?> get props => [leaveTypeId, leaveType, total, remaining];
}
