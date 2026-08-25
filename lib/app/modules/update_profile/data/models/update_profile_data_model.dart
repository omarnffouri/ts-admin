import 'dart:convert';

import 'package:ts_admin/app/modules/update_profile/domain/entities/update_profile_data_entity.dart';

UpdateProfileDataModel updateProfileDataModelFromJson(String str) =>
    UpdateProfileDataModel.fromJson(json.decode(str));

String updateProfileDataModelToJson(UpdateProfileDataModel data) =>
    json.encode(data.toJson());

class UpdateProfileDataModel extends UpdateProfileDataEntity {
  const UpdateProfileDataModel({
    super.firstName,
    super.lastName,
    super.phone,
    super.image,
  });

  factory UpdateProfileDataModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileDataModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "image": image,
      };
}
