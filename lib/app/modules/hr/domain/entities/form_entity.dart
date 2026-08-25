import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_file_entity.dart';

class FormEntity extends Equatable {
  final int? id;
  final String? formName;
  final String? type;
  final bool? signed;
  final String? createdAt;
  final String? updatedAt;
  final ApplicationFileEntity? file;
  final int? formId;

  const FormEntity({
    this.id,
    this.formName,
    this.type,
    this.signed,
    this.createdAt,
    this.updatedAt,
    this.file,
    this.formId,
  });

  factory FormEntity.fromJson(Map<String, dynamic> json) => FormEntity(
        id: json["id"],
        formName: json["form_name"],
        type: json["type"],
        signed: json["signed"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        file: json["file"] == null
            ? null
            : ApplicationFileEntity.fromJson(json["file"]),
        formId: json["form_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "form_name": formName,
        "type": type,
        "signed": signed,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "file": file?.toJson(),
        "form_id": formId,
      };

  @override
  List<Object?> get props => [
        id,
        formName,
        type,
        signed,
        createdAt,
        updatedAt,
        file,
        formId,
      ];
}
