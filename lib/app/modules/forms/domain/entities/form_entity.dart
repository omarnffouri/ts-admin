import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormEntity extends Equatable {
  FormEntity({
    this.formId,
    this.applicantFormId,
    this.violationId,
    this.formName,
    this.applicantName,
    this.formFields,
    this.formKey,
    this.isSigned,
    this.createdAt,
    this.assignBy,
    required this.attachments,
    required this.videos,
    required this.otherDocuments,
  });

  final int? formId;
  final int? applicantFormId;
  final int? violationId;
  final String? formName;
  final String? applicantName;
  final List<FormFieldEntity>? formFields;
  final String? formKey;
  bool? isSigned;
  final DateTime? createdAt;
  final AssignByEntity? assignBy;
  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  final List<FormAttachmentEntity> attachments;
  final List<FormAttachmentEntity> videos;
  final List<FormAttachmentEntity> otherDocuments;

  FormEntity copyWith({
    int? formId,
    int? applicantFormId,
    int? violationId,
    String? formName,
    String? applicantName,
    List<FormFieldEntity>? formFields,
    String? formKey,
    bool? isSigned,
    DateTime? createdAt,
    AssignByEntity? assignBy,
    List<FormAttachmentEntity>? attachments,
    List<FormAttachmentEntity>? videos,
    List<FormAttachmentEntity>? otherDocuments,
  }) =>
      FormEntity(
        formId: formId ?? this.formId,
        applicantFormId: applicantFormId ?? this.applicantFormId,
        violationId: violationId ?? this.violationId,
        formName: formName ?? this.formName,
        applicantName: applicantName ?? this.applicantName,
        formFields: formFields ?? this.formFields,
        formKey: formKey ?? this.formKey,
        isSigned: isSigned ?? this.isSigned,
        createdAt: createdAt ?? this.createdAt,
        assignBy: assignBy ?? this.assignBy,
        attachments: attachments ?? this.attachments,
        videos: videos ?? this.videos,
        otherDocuments: videos ?? this.videos,
      );

  @override
  List<Object?> get props => [
        formId,
        applicantFormId,
        violationId,
        formName,
        applicantName,
        formFields,
        formKey,
        isSigned,
        createdAt,
        assignBy,
        attachments,
        otherDocuments,
        videos,
      ];
}

class FormFieldEntity extends Equatable {
  FormFieldEntity({
    this.fieldId,
    this.type,
    this.label,
    this.value,
    this.autoFill,
    this.isRequired,
    this.formFieldsValue,
  });

  final int? fieldId;
  final String? type;
  final String? label;
  final int? value;
  final dynamic autoFill;
  final int? isRequired;
  final FormFieldsValueEntity? formFieldsValue;
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  FormFieldEntity copyWith({
    int? fieldId,
    String? type,
    String? label,
    int? value,
    dynamic autoFill,
    int? isRequired,
    FormFieldsValueEntity? formFieldsValue,
  }) =>
      FormFieldEntity(
        fieldId: fieldId ?? this.fieldId,
        type: type ?? this.type,
        label: label ?? this.label,
        value: value ?? this.value,
        autoFill: autoFill ?? this.autoFill,
        isRequired: isRequired ?? this.isRequired,
        formFieldsValue: formFieldsValue ?? this.formFieldsValue,
      );

  factory FormFieldEntity.fromRawEntity(String str) =>
      FormFieldEntity.fromEntity(json.decode(str));

  String toRawEntity() => json.encode(toEntity());

  factory FormFieldEntity.fromEntity(Map<String, dynamic> json) =>
      FormFieldEntity(
        fieldId: json["field_id"],
        type: json["type"],
        label: json["label"],
        value: json["value"],
        autoFill: json["auto_fill"],
        isRequired: json["is_required"],
        formFieldsValue: json["form_fields_value"] == null
            ? null
            : FormFieldsValueEntity.fromEntity(json["form_fields_value"]),
      );

  Map<String, dynamic> toEntity() => {
        "field_id": fieldId,
        "type": type,
        "label": label,
        "value": value,
        "auto_fill": autoFill,
        "is_required": isRequired,
        "form_fields_value": formFieldsValue?.toEntity(),
      };

  @override
  List<Object?> get props => [
        fieldId,
        type,
        label,
        value,
        autoFill,
        isRequired,
        formFieldsValue,
      ];
}

class FormFieldsValueEntity extends Equatable {
  const FormFieldsValueEntity({
    this.id,
    this.applicantFormId,
    this.formFieldId,
    required this.value,
    this.createdAt,
    this.updatedAt,
    this.title,
  });

  final int? id;
  final int? applicantFormId;
  final int? formFieldId;
  final String value;
  final String? createdAt;
  final String? updatedAt;
  final int? title;

  FormFieldsValueEntity copyWith({
    int? id,
    int? applicantFormId,
    int? formFieldId,
    String? value,
    String? createdAt,
    String? updatedAt,
    int? title,
  }) =>
      FormFieldsValueEntity(
        id: id ?? this.id,
        applicantFormId: applicantFormId ?? this.applicantFormId,
        formFieldId: formFieldId ?? this.formFieldId,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        title: title ?? this.title,
      );

  factory FormFieldsValueEntity.fromRawEntity(String str) =>
      FormFieldsValueEntity.fromEntity(json.decode(str));

  String toRawEntity() => json.encode(toEntity());

  factory FormFieldsValueEntity.fromEntity(Map<String, dynamic> json) =>
      FormFieldsValueEntity(
        id: json["id"],
        applicantFormId: json["applicant_form_id"],
        formFieldId: json["form_field_id"],
        value: json["value"] ?? "",
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        title: json["title"],
      );

  Map<String, dynamic> toEntity() => {
        "id": id,
        "applicant_form_id": applicantFormId,
        "form_field_id": formFieldId,
        "value": value,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "title": title,
      };

  @override
  List<Object?> get props => [
        id,
        applicantFormId,
        formFieldId,
        value,
        createdAt,
        updatedAt,
        title,
      ];
}

class AssignByEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? image;

  const AssignByEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
  });

  AssignByEntity copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? image,
  }) =>
      AssignByEntity(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        image: image ?? this.image,
      );

  factory AssignByEntity.fromJson(Map<String, dynamic> json) => AssignByEntity(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
      };

  @override
  List<Object?> get props => [id, firstName, lastName, image];
}

class FormAttachmentEntity extends Equatable {
  final int? id;
  final DateTime? seenAt;
  final String? url;
  final String? title;

  const FormAttachmentEntity({
    this.id,
    this.seenAt,
    this.url,
    this.title,
  });

  factory FormAttachmentEntity.fromJson(Map<String, dynamic> json) =>
      FormAttachmentEntity(
        id: json["id"],
        seenAt: json["seen_at"] == null
            ? null
            : DateTime.parse(json["seen_at"])
                .add(DateTime.now().timeZoneOffset),
        url: json["url"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seen_at": seenAt?.toIso8601String(),
        "url": url,
        "title": title,
      };

  @override
  List<Object?> get props => [
        id,
        seenAt,
        url,
        title,
      ];
}
