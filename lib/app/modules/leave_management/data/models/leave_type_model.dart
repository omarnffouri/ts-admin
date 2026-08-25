// To parse this JSON data, do
//
//     final leaveTypeModel = leaveTypeModelFromJson(jsonString);

import '../../domain/entities/leave_type_entity.dart';

class LeaveTypeModel extends LeaveTypeEntity {
  const LeaveTypeModel({
    super.id,
    super.countryName,
    super.value,
    super.type,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) => LeaveTypeModel(
        id: json["id"],
        countryName: json["countryName"],
        value: json["value"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryName": countryName,
        "value": value,
        "type": type,
      };
}
