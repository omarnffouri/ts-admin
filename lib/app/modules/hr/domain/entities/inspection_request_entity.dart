import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_file_entity.dart';

class RoadTestInspectionEntity extends Equatable {
  final int? id;
  final String? inspector;
  final ApplicationFileEntity? file;
  final String? status;
  final String? requestedDate;
  final DateTime? doneDate;

  const RoadTestInspectionEntity({
    this.id,
    this.inspector,
    this.file,
    this.status,
    this.requestedDate,
    this.doneDate,
  });

  factory RoadTestInspectionEntity.fromJson(Map<String, dynamic> json) =>
      RoadTestInspectionEntity(
        id: json["id"],
        inspector: json["inspector"],
        file: json["file"] == null
            ? null
            : ApplicationFileEntity.fromJson(json["file"]),
        status: json["status"],
        requestedDate: json["requested_date"],
        doneDate: json["done_date"] == null
            ? null
            : DateTime.parse(json["done_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inspector": inspector,
        "file": file?.toJson(),
        "status": status,
        "requested_date": requestedDate,
        "done_date":
            "${doneDate?.year.toString().padLeft(4, '0')}-${doneDate?.month.toString().padLeft(2, '0')}-${doneDate?.day.toString().padLeft(2, '0')}",
      };

  @override
  List<Object?> get props => [
        id,
        inspector,
        file,
        status,
        requestedDate,
        doneDate,
      ];
}
