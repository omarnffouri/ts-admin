import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class InspectionDetailsEntity extends Equatable {
  final List<InspectionDataEntity>? inspectionDetail;
  final InspectionInfoEntity? inspection;
  final DriverInfoEntity? driverInfo;
  final String? signature;

  const InspectionDetailsEntity({
    this.inspectionDetail,
    this.inspection,
    this.driverInfo,
    this.signature,
  });

  Map<String, dynamic> toEntity() => {
        "inspectionDetail": inspectionDetail == null
            ? []
            : List<dynamic>.from(inspectionDetail!.map((x) => x.toEntity())),
        "inspection": inspection?.toEntity(),
        "signature": signature,
      };

  @override
  List<Object?> get props => [inspectionDetail, inspection, signature];
}

class InspectionInfoEntity extends Equatable {
  final String? inspectorName;
  final DateTime? date;
  final String? time;
  final int? result;
  final String? remarks;

  const InspectionInfoEntity({
    this.inspectorName,
    this.date,
    this.time,
    this.result,
    this.remarks,
  });

  Map<String, dynamic> toEntity() => {
        "inspector_name": inspectorName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "result": result,
        "remarks": remarks,
      };

  @override
  List<Object?> get props => [inspectorName, date, time, result, remarks];
}

class InspectionDataEntity extends Equatable {
  final String? type;
  final List<CheckEntity>? checks;
  final ExpansibleController tileController = ExpansibleController();

  InspectionDataEntity({
    this.type,
    this.checks,
  });

  Map<String, dynamic> toEntity() => {
        "type": type,
        "checks": checks == null
            ? []
            : List<dynamic>.from(checks!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [type, checks];
}

class DriverInfoEntity extends Equatable {
  final int? id;
  final String? name;
  final dynamic cdlLicenseExpiration;
  final String? currentLicenseNum;
  final String? cdlIssuingState;
  final String? ssNo;

  const DriverInfoEntity({
    this.id,
    this.name,
    this.cdlLicenseExpiration,
    this.currentLicenseNum,
    this.cdlIssuingState,
    this.ssNo,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "cdl_license_expiration": cdlLicenseExpiration,
        "current_license_num": currentLicenseNum,
        "cdl_issuing_state": cdlIssuingState,
        "ss_no": ssNo,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        cdlLicenseExpiration,
        currentLicenseNum,
        cdlIssuingState,
        ssNo
      ];
}

class CheckEntity extends Equatable {
  final int? id;
  final String? name;
  final bool? needRepair;
  final bool? isRoadTestPassed;

  const CheckEntity({
    this.id,
    this.name,
    this.needRepair,
    this.isRoadTestPassed,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "need_repair": needRepair,
        "road_test_passed": isRoadTestPassed,
      };

  @override
  List<Object?> get props => [id, name, needRepair, isRoadTestPassed];
}
