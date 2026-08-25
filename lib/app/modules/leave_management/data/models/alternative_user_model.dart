// To parse this JSON data, do
//
//     final supervisorModel = supervisorModelFromJson(jsonString);

import '../../domain/entities/alternative_user_entity.dart';

class AlternativeUserModel extends AlternativeUserEntity {
  const AlternativeUserModel({
    super.id,
    super.name,
  });

  factory AlternativeUserModel.fromJson(Map<String, dynamic> json) =>
      AlternativeUserModel(
        id: json["id"],
        name: "${json["first_name"]} ${json["last_name"]}",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
