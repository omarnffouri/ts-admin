// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import '../../domain/entities/user_entity.dart';

// ignore: must_be_immutable
class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.name,
    super.email,
    super.image,
    super.phone,
    super.createdAt,
    super.updatedAt,
    super.roles,
    super.permissions,
    super.firstName,
    super.lastName,
    super.address,
    super.birthDate,
    super.emplyeeNumber,
    super.status,
    super.isOtpEnabled,
    super.offDaysEnabled,
    super.offDays,
    super.supervisorId,
    super.joiningDate,
    super.department,
    super.designation,
    super.country,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"].toString(),
        name: json["name"].toString(),
        email: json["email"].toString(),
        image: json["image"].toString(),
        phone: json["phone"].toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        roles: json["roles"] == null
            ? []
            : List<PermissionModel>.from(
                json["roles"]!.map((x) => PermissionModel.fromJson(x))),
        permissions: json["permissions"] == null
            ? []
            : List<PermissionModel>.from(
                json["permissions"]!.map((x) => PermissionModel.fromJson(x))),
        firstName: json["first_name"],
        lastName: json["last_name"],
        address: json["address"],
        birthDate: json["birth_date"],
        emplyeeNumber: json["emplyee_number"].toString(),
        status: json["status"] == "suspended" ? "suspended" : "active",
        isOtpEnabled: json["is_otp_enabled"] == 1 ? true : false,
        offDaysEnabled: json["off_days_enabled"],
        offDays: json["off_days"] == null
            ? []
            : List<int>.from(json["off_days"]!.map((x) => x)),
        supervisorId: json["supervisor_id"],
        joiningDate: json["joining_date"],
        department: json["department"] == null
            ? null
            : DepartmentModel.fromJson(json["department"]),
        designation: json["designation"] == null
            ? null
            : DesignationModel.fromJson(json["designation"]),
        country: json["country"] == null
            ? null
            : CountryModel.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
        "phone": phone,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toEntity())),
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toEntity())),
        "first_name": firstName,
        "last_name": lastName,
        "address": address,
        "birth_date": birthDate,
        "emplyee_number": emplyeeNumber,
        "status": status,
        "is_otp_enabled": isOtpEnabled == true ? 1 : 0,
        "off_days_enabled": offDaysEnabled,
        "off_days":
            offDays == null ? [] : List<dynamic>.from(offDays!.map((x) => x)),
        "supervisor_id": supervisorId,
        "joining_date": joiningDate,
        "department": department,
        "designation": designation,
        "country": country,
      };
}

class PermissionModel extends PermissionEntity {
  const PermissionModel({
    super.id,
    super.name,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        id: json["id"].toString(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    super.id,
    super.title,
    super.name,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(
        id: json["id"].toString(),
        title: json["title"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
      };
}

class DesignationModel extends DesignationEntity {
  const DesignationModel({
    super.id,
    super.title,
    super.name,
  });

  factory DesignationModel.fromJson(Map<String, dynamic> json) =>
      DesignationModel(
        id: json["id"].toString(),
        title: json["title"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
      };
}

class CountryModel extends CountryEntity {
  const CountryModel({
    super.id,
    super.name,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["id"].toString(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
