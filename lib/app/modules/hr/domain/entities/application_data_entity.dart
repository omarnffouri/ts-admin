import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/address_information_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/document_request_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/driving_license_information_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/inspection_request_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/personal_infomation_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/requested_document_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/statuses_history_entity.dart';

ApplicationDataEntity applicationDataEntityFromJson(String str) =>
    ApplicationDataEntity.fromJson(json.decode(str));

String applicationDataEntityToJson(ApplicationDataEntity data) =>
    json.encode(data.toJson());

class ApplicationDataEntity extends Equatable {
  final List<RequestedDocumentEntity>? requestedDocuments;
  final List<StatusesHistoryEntity>? statusesHistory;
  final List<RoadTestInspectionEntity>? inspectionRequests;
  final int? pendingRoadTestRequestsCount;
  final List<FormEntity>? applicationForms;
  final List<DocumentRequestEntity>? documentRequests;
  final PersonalInformationEntity? personalInformation;
  final AddressInformationEntity? addressInformation;
  final DrivingLicenseInformationEntity? drivingLicenseInformation;

  const ApplicationDataEntity({
    this.requestedDocuments,
    this.statusesHistory,
    this.inspectionRequests,
    this.pendingRoadTestRequestsCount,
    this.applicationForms,
    this.documentRequests,
    this.personalInformation,
    this.addressInformation,
    this.drivingLicenseInformation,
  });

  factory ApplicationDataEntity.fromJson(Map<String, dynamic> json) =>
      ApplicationDataEntity(
        requestedDocuments: json["requestedDocuments"] == null
            ? []
            : List<RequestedDocumentEntity>.from(json["requestedDocuments"]!
                .map((x) => RequestedDocumentEntity.fromJson(x))),
        statusesHistory: json["statusesHistory"] == null
            ? []
            : List<StatusesHistoryEntity>.from(json["statusesHistory"]!
                .map((x) => StatusesHistoryEntity.fromJson(x))),
        inspectionRequests: json["inspectionRequests"] == null
            ? []
            : List<RoadTestInspectionEntity>.from(json["inspectionRequests"]!
                .map((x) => RoadTestInspectionEntity.fromJson(x))),
        pendingRoadTestRequestsCount: json["pendingRoadTestRequestsCount"],
        applicationForms: json["applicationForms"] == null
            ? []
            : List<FormEntity>.from(
                json["applicationForms"]!.map((x) => FormEntity.fromJson(x))),
        documentRequests: json["documentRequests"] == null
            ? []
            : List<DocumentRequestEntity>.from(json["documentRequests"]!
                .map((x) => DocumentRequestEntity.fromJson(x))),
        personalInformation: json["personalInformation"] == null
            ? null
            : PersonalInformationEntity.fromJson(json["personalInformation"]),
        addressInformation: json["addressInformation"] == null
            ? null
            : AddressInformationEntity.fromJson(json["addressInformation"]),
        drivingLicenseInformation: json["drivingLicenseInformation"] == null
            ? null
            : DrivingLicenseInformationEntity.fromJson(
                json["drivingLicenseInformation"]),
      );

  Map<String, dynamic> toJson() => {
        "requestedDocuments": requestedDocuments == null
            ? []
            : List<dynamic>.from(requestedDocuments!.map((x) => x.toJson())),
        "statusesHistory": statusesHistory == null
            ? []
            : List<dynamic>.from(statusesHistory!.map((x) => x.toJson())),
        "inspectionRequests": inspectionRequests == null
            ? []
            : List<dynamic>.from(inspectionRequests!.map((x) => x.toJson())),
        "pendingRoadTestRequestsCount": pendingRoadTestRequestsCount,
        "applicationForms": applicationForms == null
            ? []
            : List<dynamic>.from(applicationForms!.map((x) => x.toJson())),
        "documentRequests": documentRequests == null
            ? []
            : List<dynamic>.from(documentRequests!.map((x) => x.toJson())),
        "personalInformation": personalInformation?.toJson(),
        "addressInformation": addressInformation?.toJson(),
        "drivingLicenseInformation": drivingLicenseInformation?.toJson(),
      };

  @override
  List<Object?> get props => [
        requestedDocuments,
        statusesHistory,
        inspectionRequests,
        pendingRoadTestRequestsCount,
        applicationForms,
        documentRequests,
        personalInformation,
        addressInformation,
        drivingLicenseInformation,
      ];
}
