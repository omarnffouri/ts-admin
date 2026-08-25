import 'dart:convert';

import 'package:ts_admin/app/modules/storage/domain/entities/storage_users_entity.dart';

StorageUsersModel getStorageUsersModelFromJson(String str) =>
    StorageUsersModel.fromJson(json.decode(str));

String getStorageUsersModelToJson(StorageUsersModel data) =>
    json.encode(data.toJson());

class StorageUsersModel extends StorageUsersEntity {
  const StorageUsersModel({
    super.employees,
  });

  factory StorageUsersModel.fromJson(Map<String, dynamic> json) =>
      StorageUsersModel(
        employees: json["employees"] == null
            ? []
            : List<EmployeeModel>.from(
                json["employees"]!.map((x) => EmployeeModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "employees": employees == null
            ? []
            : List<dynamic>.from(employees!.map((x) => x.toJson())),
      };
}

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    super.firstName,
    super.lastName,
    super.id,
    super.name,
    super.modelType,
    super.userDesignation,
    super.image,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        id: json["id"],
        name: json["name"],
        modelType: json["model_type"],
        userDesignation: json["user_designation"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "id": id,
        "name": name,
        "model_type": modelType,
        "user_designation": userDesignation,
        "image": image,
      };
}
