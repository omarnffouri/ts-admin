// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PermissionEntity>? roles;
  final List<PermissionEntity>? permissions;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? birthDate;
  final String? emplyeeNumber;
  String? status;
  final bool? isOtpEnabled;
  final bool? offDaysEnabled;
  final List<int>? offDays;
  final int? supervisorId;
  final dynamic joiningDate;
  final DepartmentEntity? department;
  final DesignationEntity? designation;
  final CountryEntity? country;

  UserEntity({
    this.id,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.roles,
    this.permissions,
    this.firstName,
    this.lastName,
    this.address,
    this.birthDate,
    this.emplyeeNumber,
    this.status,
    this.isOtpEnabled,
    this.offDaysEnabled,
    this.offDays,
    this.supervisorId,
    this.joiningDate,
    this.department,
    this.designation,
    this.country,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        image,
        phone,
        createdAt,
        updatedAt,
        roles,
        permissions,
        firstName,
        lastName,
        address,
        birthDate,
        emplyeeNumber,
        status,
        isOtpEnabled,
        offDaysEnabled,
        offDays,
        supervisorId,
        joiningDate,
        department,
        designation,
        country,
      ];

  bool get isSuspended => status == "suspended";
}

class PermissionEntity extends Equatable {
  final String? id;
  final String? name;

  const PermissionEntity({
    this.id,
    this.name,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [id, name];
}

class DepartmentEntity extends Equatable {
  final String? id;
  final String? title;
  final String? name;

  const DepartmentEntity({
    this.id,
    this.title,
    this.name,
  });

  @override
  List<Object?> get props => [id, title, name];
}

class DesignationEntity extends Equatable {
  final String? id;
  final String? title;
  final String? name;

  const DesignationEntity({
    this.id,
    this.title,
    this.name,
  });

  @override
  List<Object?> get props => [id, title, name];
}

class CountryEntity extends Equatable {
  final String? id;
  final String? name;

  const CountryEntity({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
