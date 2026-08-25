// To parse this JSON data, do
//
//     final contactEntity = contactEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

ContactEntity contactEntityFromJson(String str) =>
    ContactEntity.fromJson(json.decode(str));

String contactEntityToJson(ContactEntity data) => json.encode(data.toJson());

GroupContactsEntity groupContactsEntityFromJson(String str) =>
    GroupContactsEntity.fromJson(json.decode(str));

String groupContactsEntityToJson(GroupContactsEntity data) =>
    json.encode(data.toJson());

class GroupContactsEntity extends Equatable {
  final List<ContactEntity>? applicants;
  final List<ContactEntity>? admins;

  const GroupContactsEntity({
    this.applicants,
    this.admins,
  });

  factory GroupContactsEntity.fromJson(Map<String, dynamic> json) =>
      GroupContactsEntity(
        applicants: json["applicants"] == null
            ? []
            : List<ContactEntity>.from(
                json["applicants"]!.map((x) => ContactEntity.fromJson(x))),
        admins: json["admins"] == null
            ? []
            : List<ContactEntity>.from(
                json["admins"]!.map((x) => ContactEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "applicants": applicants == null
            ? []
            : List<dynamic>.from(applicants!.map((x) => x.toJson())),
        "admins": admins == null
            ? []
            : List<dynamic>.from(admins!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [applicants, admins];
}

class ContactEntity extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final String? image;
  final String? designation;
  final ModelType? modelType;

  const ContactEntity({
    this.id,
    this.name,
    this.phone,
    this.image,
    this.modelType,
    this.designation,
  });

  factory ContactEntity.fromJson(Map<String, dynamic> json) => ContactEntity(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        image: json["image"],
        designation: json["designation"],
        modelType: modelTypeValues.map[json["model_type"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "image": image,
        "designation": designation,
        "model_type": modelTypeValues.reverse[modelType],
      };

  @override
  List<Object?> get props => [
        id,
        phone,
        name,
        image,
        modelType,
        designation,
      ];
}
