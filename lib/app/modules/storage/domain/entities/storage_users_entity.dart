import 'dart:convert';

import 'package:equatable/equatable.dart';

StorageUsersEntity getStorageUsersEntityFromJson(String str) =>
    StorageUsersEntity.fromJson(json.decode(str));

String getStorageUsersEntityToJson(StorageUsersEntity data) =>
    json.encode(data.toJson());

class StorageUsersEntity extends Equatable {
  final List<EmployeeEntity>? employees;

  const StorageUsersEntity({
    this.employees,
  });

  factory StorageUsersEntity.fromJson(Map<String, dynamic> json) =>
      StorageUsersEntity(
        employees: json["employees"] == null
            ? []
            : List<EmployeeEntity>.from(
                json["employees"]!.map((x) => EmployeeEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employees": employees == null
            ? []
            : List<dynamic>.from(employees!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [employees];
}

class EmployeeEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? name;
  final String? modelType;
  final String? userDesignation;
  final String? image;

  const EmployeeEntity({
    this.firstName,
    this.lastName,
    this.id,
    this.name,
    this.modelType,
    this.userDesignation,
    this.image,
  });

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) => EmployeeEntity(
        firstName: json["first_name"],
        lastName: json["last_name"],
        id: json["id"],
        name: json["name"],
        modelType: json["model_type"],
        userDesignation: json["user_designation"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "id": id,
        "name": name,
        "model_type": modelType,
        "user_designation": userDesignation,
        "image": image,
      };

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        id,
        name,
        modelType,
        userDesignation,
        image,
      ];
}
