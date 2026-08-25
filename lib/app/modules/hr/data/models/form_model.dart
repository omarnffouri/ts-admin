import 'package:ts_admin/app/modules/hr/data/models/application_file_model.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/form_entity.dart';

class FormModel extends FormEntity {
  const FormModel({
    super.id,
    super.formName,
    super.type,
    super.signed,
    super.createdAt,
    super.updatedAt,
    super.file,
    super.formId,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        id: json["id"],
        formName: json["form_name"],
        type: json["type"],
        signed: json["signed"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        file: json["file"] == null
            ? null
            : ApplicationFileModel.fromJson(json["file"]),
        formId: json["form_id"],
      );

  @override
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
}
