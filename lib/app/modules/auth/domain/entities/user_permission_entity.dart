// To parse this JSON data, do
//
//     final userPermissionEntity = userPermissionEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

UserPermissionEntity userPermissionEntityFromJson(String str) =>
    UserPermissionEntity.fromJson(json.decode(str));

String userPermissionEntityToJson(UserPermissionEntity data) =>
    json.encode(data.toJson());

class UserPermissionEntity extends Equatable {
  final int? id;
  final String? name;

  const UserPermissionEntity({
    this.id,
    this.name,
  });

  UserPermissionEntity copyWith({
    int? id,
    String? name,
  }) =>
      UserPermissionEntity(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory UserPermissionEntity.fromJson(Map<String, dynamic> json) =>
      UserPermissionEntity(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
