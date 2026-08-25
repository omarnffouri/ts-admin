// To parse this JSON data, do
//
//     final formModel = formModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/form_entity.dart';

// ignore: must_be_immutable
class FormModel extends FormEntity {
  FormModel(
      {super.formId,
      super.applicantFormId,
      super.violationId,
      super.formName,
      super.applicantName,
      super.formFields,
      super.formKey,
      super.isSigned,
      super.createdAt,
      super.assignBy,
      required super.attachments,
      required super.videos,
      required super.otherDocuments});

  factory FormModel.fromRawJson(String str) =>
      FormModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        formId: json["form_id"],
        formKey: json["form_id"].toString(),
        applicantFormId: json["applicant_form_id"],
        violationId: json["violation_id"],
        formName: json["form_name"],
        applicantName: json["applicant_name"],
        formFields: json["form_fields"] == null
            ? []
            : List<FormField>.from(
                json["form_fields"]!.map((x) => FormField.fromJson(x))),
        isSigned: json["is_signed"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        assignBy: json["assign_by"] == null
            ? null
            : AssignByModel.fromJson(json["assign_by"]),
        attachments: json["attachments"] == null
            ? []
            : List<FormAttachmentModel>.from(json["attachments"]!
                .map((x) => FormAttachmentModel.fromJson(x))),
        videos: json["videos"] == null
            ? []
            : List<FormAttachmentModel>.from(
                json["videos"]!.map((x) => FormAttachmentModel.fromJson(x))),
        otherDocuments: json["other_documents"] == null
            ? []
            : List<FormAttachmentEntity>.from(json["other_documents"]!
                .map((x) => FormAttachmentEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "form_id": formId,
        "applicant_form_id": applicantFormId,
        "violation_id": violationId,
        "form_name": formName,
        "applicant_name": applicantName,
        "is_signed": isSigned,
        "form_fields": formFields == null
            ? []
            : List<dynamic>.from(formFields!.map((x) => x.toEntity())),
        "created_at": createdAt?.toIso8601String(),
        "assign_by": assignBy?.toJson(),
        "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
        "other_documents":
            List<dynamic>.from(otherDocuments.map((x) => x.toJson())),
      };
}

class FormField extends FormFieldEntity {
  FormField({
    super.fieldId,
    super.type,
    super.label,
    super.value,
    super.autoFill,
    super.isRequired,
    super.formFieldsValue,
  });

  factory FormField.fromRawJson(String str) =>
      FormField.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FormField.fromJson(Map<String, dynamic> json) => FormField(
        fieldId: json["field_id"],
        type: json["type"],
        label: json["label"],
        value: json["value"],
        autoFill: json["auto_fill"],
        isRequired: json["is_required"],
        formFieldsValue: json["form_fields_value"] == null
            ? null
            : FormFieldsValue.fromJson(json["form_fields_value"]),
      );

  Map<String, dynamic> toJson() => {
        "field_id": fieldId,
        "type": type,
        "label": label,
        "value": value,
        "auto_fill": autoFill,
        "is_required": isRequired,
        "form_fields_value": formFieldsValue?.toEntity(),
      };
}

class FormFieldsValue extends FormFieldsValueEntity {
  const FormFieldsValue({
    super.id,
    super.applicantFormId,
    super.formFieldId,
    required super.value,
    super.createdAt,
    super.updatedAt,
    super.title,
  });

  factory FormFieldsValue.fromRawJson(String str) =>
      FormFieldsValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FormFieldsValue.fromJson(Map<String, dynamic> json) =>
      FormFieldsValue(
        id: json["id"],
        applicantFormId: json["applicant_form_id"],
        formFieldId: json["form_field_id"],
        value: json["value"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "applicant_form_id": applicantFormId,
        "form_field_id": formFieldId,
        "value": value,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "title": title,
      };
}

class AssignByModel extends AssignByEntity {
  const AssignByModel({
    super.id,
    super.firstName,
    super.lastName,
    super.image,
  });

  factory AssignByModel.fromJson(Map<String, dynamic> json) => AssignByModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
      };
}

class FormAttachmentModel extends FormAttachmentEntity {
  const FormAttachmentModel({
    super.id,
    super.seenAt,
    super.url,
    super.title,
  });

  factory FormAttachmentModel.fromJson(Map<String, dynamic> json) =>
      FormAttachmentModel(
        id: json["id"],
        seenAt: json["seen_at"] == null
            ? null
            : DateTime.parse(json["seen_at"])
                .add(DateTime.now().timeZoneOffset),
        url: json["url"],
        title: json["title"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "seen_at": seenAt?.toIso8601String(),
        "url": url,
        "title": title,
      };
}
