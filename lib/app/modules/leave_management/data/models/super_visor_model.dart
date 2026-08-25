// To parse this JSON data, do
//
//     final supervisorModel = supervisorModelFromJson(jsonString);

import '../../domain/entities/super_visor_entity.dart';

class SupervisorModel extends SupervisorEntity {
  const SupervisorModel({
    super.id,
    super.name,
    super.firstName,
    super.lastName,
  });

  factory SupervisorModel.fromJson(Map<String, dynamic> json) =>
      SupervisorModel(
        id: json["id"],
        name: "${json["firstName"]} ${json["lastName"]}",
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "firstName": firstName,
        "lastName": lastName,
      };
}
