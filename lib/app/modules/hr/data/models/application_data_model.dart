import 'package:ts_admin/app/modules/hr/data/models/address_information_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/document_request_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/driving_license_information_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/form_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/inspection_request_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/personal_infomation_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/requested_document_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/statuses_history_model.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_data_entity.dart';

class ApplicationDataModel extends ApplicationDataEntity {
  const ApplicationDataModel({
    super.requestedDocuments,
    super.statusesHistory,
    super.inspectionRequests,
    super.pendingRoadTestRequestsCount,
    super.applicationForms,
    super.documentRequests,
    super.personalInformation,
    super.addressInformation,
    super.drivingLicenseInformation,
  });

  factory ApplicationDataModel.fromJson(Map<String, dynamic> json) =>
      ApplicationDataModel(
        requestedDocuments: json["requestedDocuments"] == null
            ? []
            : List<RequestedDocumentModel>.from(json["requestedDocuments"]!
                .map((x) => RequestedDocumentModel.fromJson(x))),
        statusesHistory: json["statusesHistory"] == null
            ? []
            : List<StatusesHistoryModel>.from(json["statusesHistory"]!
                .map((x) => StatusesHistoryModel.fromJson(x))),
        inspectionRequests: json["inspectionRequests"] == null
            ? []
            : List<RoadTestInspectionModel>.from(json["inspectionRequests"]!
                .map((x) => RoadTestInspectionModel.fromJson(x))),
        pendingRoadTestRequestsCount: json["pendingRoadTestRequestsCount"],
        applicationForms: json["applicationForms"] == null
            ? []
            : List<FormModel>.from(
                json["applicationForms"]!.map((x) => FormModel.fromJson(x))),
        documentRequests: json["documentRequests"] == null
            ? []
            : List<DocumentRequestModel>.from(json["documentRequests"]!
                .map((x) => DocumentRequestModel.fromJson(x))),
        personalInformation: json["personalInformation"] == null
            ? null
            : PersonalInformationModel.fromJson(json["personalInformation"]),
        addressInformation: json["addressInformation"] == null
            ? null
            : AddressInformationModel.fromJson(json["addressInformation"]),
        drivingLicenseInformation: json["drivingLicenseInformation"] == null
            ? null
            : DrivingLicenseInformationModel.fromJson(
                json["drivingLicenseInformation"]),
      );

  @override
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
}
