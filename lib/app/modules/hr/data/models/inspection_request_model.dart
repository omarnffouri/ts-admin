import 'package:ts_admin/app/modules/hr/data/models/application_file_model.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/inspection_request_entity.dart';

class RoadTestInspectionModel extends RoadTestInspectionEntity {
  const RoadTestInspectionModel({
    super.id,
    super.inspector,
    super.file,
    super.status,
    super.requestedDate,
    super.doneDate,
  });

  factory RoadTestInspectionModel.fromJson(Map<String, dynamic> json) =>
      RoadTestInspectionModel(
        id: json["id"],
        inspector: json["inspector"],
        file: json["file"] == null
            ? null
            : ApplicationFileModel.fromJson(json["file"]),
        status: json["status"],
        requestedDate: json["requested_date"],
        doneDate: json["done_date"] == null
            ? null
            : DateTime.parse(json["done_date"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "inspector": inspector,
        "file": file?.toJson(),
        "status": status,
        "requested_date": requestedDate,
        "done_date":
            "${doneDate?.year.toString().padLeft(4, '0')}-${doneDate?.month.toString().padLeft(2, '0')}-${doneDate?.day.toString().padLeft(2, '0')}",
      };
}
