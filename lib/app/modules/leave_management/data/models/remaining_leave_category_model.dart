import '../../domain/entities/remaining_leave_category_entity.dart';

class RemainingLeaveCategoryModel extends RemainingLeaveCategoryEntity {
  const RemainingLeaveCategoryModel({
    super.leaveTypeId,
    super.leaveType,
    super.total,
    super.remaining,
  });

  factory RemainingLeaveCategoryModel.fromJson(Map<String, dynamic> json) =>
      RemainingLeaveCategoryModel(
        leaveTypeId: json["leave_type_id"],
        leaveType: json["leave_type"],
        total: json["total"]?.toString(),
        remaining: json["remaining"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "leave_type_id": leaveTypeId,
        "leave_type": leaveType,
        "total": total,
        "remaining": remaining,
      };
}
