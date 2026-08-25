import 'package:equatable/equatable.dart';

class LoginPayloadEntity extends Equatable {
  final UserEntity? user;
  final String? accessToken;
  final String? tokenType;
  final bool? otpSent;

  const LoginPayloadEntity({
    this.user,
    this.accessToken,
    this.tokenType,
    this.otpSent,
  });

  @override
  List<Object?> get props => [
        user,
        accessToken,
        tokenType,
        otpSent,
      ];
}

// ignore: must_be_immutable
class UserEntity extends Equatable {
  final int? id;
  String? firstName;
  String? lastName;
  final String? email;
  final DateTime? emailVerifiedAt;
  String? phone;
  final String? birthDate;
  final String? address;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic teamId;
  final String? ringCentralUsername;
  final String? ringCentralExtension;
  final String? ringCentralPassword;
  final String? modelType;
  final bool? isSuperAdmin;
  final UserDesignationEntity? department;
  final UserDesignationEntity? designation;
  String? name;
  String? image;
  final dynamic driver;
  List<RoleEntity>? roles;

  UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.birthDate,
    this.address,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.teamId,
    this.ringCentralUsername,
    this.ringCentralExtension,
    this.ringCentralPassword,
    this.modelType,
    this.name,
    this.designation,
    this.image,
    this.isSuperAdmin,
    this.department,
    this.driver,
    this.roles,
  });

  factory UserEntity.fromEntity(Map<String, dynamic> json) => UserEntity(
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
            : UserDesignationEntity.fromJson(json["designation"]),
        deletedAt: json["deleted_at"],
        teamId: json["team_id"],
        ringCentralUsername: json["ring_central_username"],
        ringCentralExtension: json["ring_central_extension"],
        ringCentralPassword: json["ring_central_password"],
        modelType: json["model_type"],
        isSuperAdmin: json["is_super_admin"],
        department: json["department"] == null
            ? null
            : UserDesignationEntity.fromJson(json["department"]),
        name: json["name"],
        image: json["image"],
        driver: json["driver"],
        roles: json["roles"] == null
            ? null
            : List<RoleEntity>.from(
                json["roles"].map((x) => RoleEntity.fromEntity(x))),
      );

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
        "department": department?.toJson(),
        "name": name,
        "image": image,
        "driver": driver,
        "designation": designation?.toJson(),
        "roles": roles == null
            ? null
            : List<dynamic>.from(roles!.map((x) => x.toEntity())),
      };

  // add copyWith method to update the user roles
  UserEntity copyWith({
    List<RoleEntity>? roles,
  }) {
    return UserEntity(
      roles: roles ?? this.roles,
    );
  }

  // Check if user has a specific role
  bool hasAnyRole(List<String> roleNames) {
    return roles?.any(
            (userRole) => roleNames.contains(userRole.name?.toLowerCase())) ??
        false;
  }

  bool hasSingleRole(String roleName) {
    return roles?.length == 1 &&
        roles?.first.name?.toLowerCase() == roleName.toLowerCase();
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        emailVerifiedAt,
        phone,
        birthDate,
        isSuperAdmin,
        department,
        address,
        fcmToken,
        createdAt,
        updatedAt,
        deletedAt,
        teamId,
        ringCentralUsername,
        ringCentralExtension,
        ringCentralPassword,
        modelType,
        name,
        image,
        driver,
        designation,
        roles,
      ];
}

class UserDesignationEntity extends Equatable {
  final int? id;
  final String? title;
  final String? name;
  final dynamic deletedAt;
  final String? createdAt;
  final DateTime? updatedAt;

  const UserDesignationEntity({
    this.id,
    this.title,
    this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDesignationEntity.fromJson(Map<String, dynamic> json) =>
      UserDesignationEntity(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        title,
        name,
        deletedAt,
        createdAt,
        updatedAt,
      ];
}

class RoleEntity extends Equatable {
  final int? id;
  final String? name;
  final String? guardName;
  final String? createdAt;
  final String? updatedAt;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleEntity.fromEntity(Map<String, dynamic> json) {
    return RoleEntity(
      id: json['id'],
      name: json['name'],
      guardName: json['guard_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toEntity() {
    return {
      "id": id,
      "name": name,
      "guard_name": guardName,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  @override
  List<Object?> get props => [id, name, guardName, createdAt, updatedAt];
}
