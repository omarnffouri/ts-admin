// To parse this JSON data, do
//
//     final contactEntity = contactEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel extends ContactEntity {
  const ContactModel({
    super.id,
    super.name,
    super.phone,
    super.image,
    super.modelType,
    super.designation,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        image: json["image"],
        designation: json["designation"],
        modelType: modelTypeValues.map[json["model_type"]]!,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "image": image,
        "designation": designation,
        "model_type": modelTypeValues.reverse[modelType],
      };
}

GroupContactsModel groupContactsModelFromJson(String str) =>
    GroupContactsModel.fromJson(json.decode(str));

String groupContactsModelToJson(GroupContactsModel data) =>
    json.encode(data.toJson());

class GroupContactsModel extends GroupContactsEntity {
  const GroupContactsModel({
    super.applicants,
    super.admins,
  });

  factory GroupContactsModel.fromJson(Map<String, dynamic> json) =>
      GroupContactsModel(
        applicants: json["applicants"] == null
            ? []
            : List<ContactModel>.from(
                json["applicants"]!.map((x) => ContactModel.fromJson(x))),
        admins: json["admins"] == null
            ? []
            : List<ContactModel>.from(
                json["admins"]!.map((x) => ContactModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "applicants": applicants == null
            ? []
            : List<dynamic>.from(applicants!.map((x) => x.toJson())),
        "admins": admins == null
            ? []
            : List<dynamic>.from(admins!.map((x) => x.toJson())),
      };
}
