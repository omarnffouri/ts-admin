// To parse this JSON data, do
//
//     final updateProfileDataEntity = updateProfileDataEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

UpdateProfileDataEntity updateProfileDataEntityFromJson(String str) =>
    UpdateProfileDataEntity.fromJson(json.decode(str));

String updateProfileDataEntityToJson(UpdateProfileDataEntity data) =>
    json.encode(data.toJson());

class UpdateProfileDataEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? image;

  const UpdateProfileDataEntity({
    this.firstName,
    this.lastName,
    this.phone,
    this.image,
  });

  factory UpdateProfileDataEntity.fromJson(Map<String, dynamic> json) =>
      UpdateProfileDataEntity(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "image": image,
      };

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phone,
        image,
      ];
}
