// To parse this JSON data, do
//
//     final loginPayloadModel = loginPayloadModelFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';

LoginPayloadModel loginPayloadModelFromJson(String str) =>
    LoginPayloadModel.fromJson(json.decode(str));

String loginPayloadModelToJson(LoginPayloadModel data) =>
    json.encode(data.toJson());

class LoginPayloadModel extends LoginPayloadEntity {
  const LoginPayloadModel({
    super.user,
    super.accessToken,
    super.tokenType,
    super.otpSent,
  });

  factory LoginPayloadModel.fromJson(Map<String, dynamic> json) =>
      LoginPayloadModel(
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        accessToken: json["accessToken"],
        tokenType: json["token_type"],
        otpSent: json["otp_sent"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toEntity(),
        "accessToken": accessToken,
        "token_type": tokenType,
        "otp_sent": otpSent,
      };
}

// ignore: must_be_immutable
class UserModel extends UserEntity {
  UserModel(
      {super.id,
      super.firstName,
      super.lastName,
      super.email,
      super.emailVerifiedAt,
      super.phone,
      super.birthDate,
      super.address,
      super.fcmToken,
      super.createdAt,
      super.updatedAt,
      super.deletedAt,
      super.teamId,
      super.ringCentralUsername,
      super.ringCentralExtension,
      super.ringCentralPassword,
      super.modelType,
      super.isSuperAdmin,
      super.department,
      super.name,
      super.image,
      super.driver,
      super.designation,
      super.roles});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        phone: json["phone"],
        birthDate: json["birth_date"],
        address: json["address"],
        fcmToken: json["fcm_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        designation: json["designation"] == null
            ? null
            : UserDesignationModel.fromJson(json["designation"]),
        deletedAt: json["deleted_at"],
        teamId: json["team_id"],
        ringCentralUsername: json["ring_central_username"],
        ringCentralExtension: json["ring_central_extension"],
        ringCentralPassword: json["ring_central_password"],
        modelType: json["model_type"],
        isSuperAdmin: json["is_super_admin"],
        department: json["department"] == null
            ? null
            : UserDesignationModel.fromJson(json["department"]),
        name: json["name"],
        image: json["image"],
        driver: json["driver"],
        roles: json["roles"] == null
            ? null
            : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  @override
  Map<String, dynamic> toEntity() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "phone": phone,
        "birth_date": birthDate,
        "address": address,
        "fcm_token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "team_id": teamId,
        "ring_central_username": ringCentralUsername,
        "ring_central_extension": ringCentralExtension,
        "ring_central_password": ringCentralPassword,
        "model_type": modelType,
        "is_super_admin": isSuperAdmin,
        "department": department,
        "name": name,
        "image": image,
        "driver": driver,
        "designation": designation?.toJson(),
        "roles": roles == null
            ? null
            : List<dynamic>.from(
                roles!.map((x) => x.toEntity()),
              ),
      };
}

class UserDesignationModel extends UserDesignationEntity {
  const UserDesignationModel({
    super.id,
    super.title,
    super.name,
    super.deletedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory UserDesignationModel.fromJson(Map<String, dynamic> json) =>
      UserDesignationModel(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Role extends RoleEntity {
  const Role({
    required super.id,
    required super.name,
    required super.guardName,
    required super.createdAt,
    required super.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      guardName: json['guard_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
