// To parse this JSON data, do
//
//     final inspectionDetailsModel = inspectionDetailsModelFromJson(jsonString);

import '../../domain/entities/inspection_details_entity.dart';

class InspectionDetailsModel extends InspectionDetailsEntity {
  const InspectionDetailsModel({
    super.inspectionDetail,
    super.inspection,
    super.driverInfo,
    super.signature,
  });

  factory InspectionDetailsModel.fromJson(Map<String, dynamic> json) =>
      InspectionDetailsModel(
        inspectionDetail: json["inspectionDetail"] == null
            ? []
            : List<InspectionDataModel>.from(json["inspectionDetail"]!
                .map((x) => InspectionDataModel.fromJson(x))),
        inspection: json["inspection"] == null
            ? null
            : InspectionInfoModel.fromJson(json["inspection"]),
        driverInfo: json["driver"] == null
            ? null
            : DriverInfoModel.fromJson(json["driver"]),
        signature: json["signature"],
      );

  Map<String, dynamic> toJson() => {
        "inspectionDetail": inspectionDetail == null
            ? []
            : List<dynamic>.from(inspectionDetail!.map((x) => x.toEntity())),
        "inspection": inspection?.toEntity(),
        "signature": signature,
      };
}

class InspectionInfoModel extends InspectionInfoEntity {
  const InspectionInfoModel({
    super.inspectorName,
    super.date,
    super.time,
    super.result,
    super.remarks,
  });

  factory InspectionInfoModel.fromJson(Map<String, dynamic> json) =>
      InspectionInfoModel(
        inspectorName: json["inspector_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        result: json["result"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "inspector_name": inspectorName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "result": result,
        "remarks": remarks,
      };
}

class DriverInfoModel extends DriverInfoEntity {
  const DriverInfoModel({
    super.id,
    super.name,
    super.cdlLicenseExpiration,
    super.currentLicenseNum,
    super.cdlIssuingState,
    super.ssNo,
  });

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) =>
      DriverInfoModel(
        id: json["id"],
        name: json["name"],
        cdlLicenseExpiration: json["cdl_license_expiration"],
        currentLicenseNum: json["current_license_num"],
        cdlIssuingState: json["cdl_issuing_state"],
        ssNo: json["ss_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cdl_license_expiration": cdlLicenseExpiration,
        "current_license_num": currentLicenseNum,
        "cdl_issuing_state": cdlIssuingState,
        "ss_no": ssNo,
      };
}

class InspectionDataModel extends InspectionDataEntity {
  InspectionDataModel({
    super.type,
    super.checks,
  });

  factory InspectionDataModel.fromJson(Map<String, dynamic> json) =>
      InspectionDataModel(
        type: json["type"],
        checks: json["checks"] == null
            ? []
            : List<CheckModel>.from(
                json["checks"]!.map((x) => CheckModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "checks": checks == null
            ? []
            : List<dynamic>.from(checks!.map((x) => x.toEntity())),
      };
}

class CheckModel extends CheckEntity {
  const CheckModel({
    super.id,
    super.name,
    super.needRepair,
    super.isRoadTestPassed,
  });

  factory CheckModel.fromJson(Map<String, dynamic> json) => CheckModel(
        id: json["id"],
        name: json["name"],
        needRepair: json["need_repair"],
        isRoadTestPassed: json["road_test_passed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "need_repair": needRepair,
        "road_test_passed": isRoadTestPassed,
      };
}
