// To parse this JSON data, do
//
//     final taskDropdownsModel = taskDropdownsModelFromJson(jsonString);

import '../../domain/entities/task_dropdown_entity.dart';

class TaskDropdownsModel extends TaskDropdownsEntity {
  const TaskDropdownsModel({
    super.name,
    super.id,
    super.image,
    super.designation,
  });

  factory TaskDropdownsModel.fromJson(Map<String, dynamic> json) =>
      TaskDropdownsModel(
        name: json["name"],
        id: json["id"],
        image: json["image"],
        designation: json["designation"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "image": image,
        "designation": designation,
      };
}
