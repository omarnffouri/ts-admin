// To parse this JSON data, do
//
//     final leaveTypeModel = leaveTypeModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

class LeaveTypeEntity extends Equatable {
  final int? id;
  final String? countryName;
  final int? value;
  final String? type;

  const LeaveTypeEntity({
    this.id,
    this.countryName,
    this.value,
    this.type,
  });

  @override
  List<Object?> get props => [id, countryName, value, type];
}
