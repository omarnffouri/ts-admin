// To parse this JSON data, do
//
//     final taskDropdownsModel = taskDropdownsModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

class TaskDropdownsEntity extends Equatable {
  final String? name;
  final int? id;
  final String? image;
  final String? designation;

  const TaskDropdownsEntity({
    this.name,
    this.id,
    this.image,
    this.designation,
  });

  @override
  List<Object?> get props => [name, id, image, designation];
}
