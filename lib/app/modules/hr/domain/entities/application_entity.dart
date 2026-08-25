import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/enum_values.dart';

ApplicationEntity applicationEntityFromJson(String str) =>
    ApplicationEntity.fromJson(json.decode(str));

String applicationEntityToJson(ApplicationEntity data) =>
    json.encode(data.toJson());

class ApplicationEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final JobCategories? jobCategory;
  final String? email;
  final String? ssNo;
  final String? mobileNumber;
  final String? applicationDate;
  final String? applicationTime;
  final ApplicationStatuses? status;
  final DateTime? statusCreatedAt;
  final String? statusText;
  final String? previousStatus;
  final dynamic actionCode;
  final String? trainingStatus;
  final String? trainingStatusText;
  final bool? hasDriver;
  final int? driverId;
  final int? teamId;
  final bool? isOwnerPartner;
  final String? path;
  final List<dynamic>? assignedTrucks;

  const ApplicationEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.jobCategory,
    this.email,
    this.ssNo,
    this.mobileNumber,
    this.applicationDate,
    this.applicationTime,
    this.status,
    this.statusCreatedAt,
    this.statusText,
    this.previousStatus,
    this.actionCode,
    this.trainingStatus,
    this.trainingStatusText,
    this.hasDriver,
    this.driverId,
    this.teamId,
    this.isOwnerPartner,
    this.path,
    this.assignedTrucks,
  });

  factory ApplicationEntity.fromJson(Map<String, dynamic> json) =>
      ApplicationEntity(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        name: json["name"],
        jobCategory: jobCategories.map[json["job_category"]],
        email: json["email"],
        ssNo: json["ss_no"],
        mobileNumber: json["mobile_number"],
        applicationDate: json["application_date"],
        applicationTime: json["application_time"],
        status: applicationStatuses.map[json["status"]],
        statusCreatedAt: json["status_created_at"] == null
            ? null
            : DateTime.parse(json["status_created_at"]),
        statusText: json["status_text"],
        previousStatus: json["previous_status"],
        actionCode: json["action_code"],
        trainingStatus: json["training_status"],
        trainingStatusText: json["training_status_text"],
        hasDriver: json["has_driver"],
        driverId: json["driver_id"],
        teamId: json["team_id"],
        isOwnerPartner: json["is_owner_partner"],
        path: json["path"],
        assignedTrucks: json["assigned_trucks"] == null
            ? []
            : List<dynamic>.from(json["assigned_trucks"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "name": name,
        "job_category": jobCategories.reverse[jobCategory],
        "email": email,
        "ss_no": ssNo,
        "mobile_number": mobileNumber,
        "application_date": applicationDate,
        "application_time": applicationTime,
        "status": applicationStatuses.reverse[status],
        "status_created_at": statusCreatedAt?.toIso8601String(),
        "status_text": statusText,
        "previous_status": previousStatus,
        "action_code": actionCode,
        "training_status": trainingStatus,
        "training_status_text": trainingStatusText,
        "has_driver": hasDriver,
        "driver_id": driverId,
        "team_id": teamId,
        "is_owner_partner": isOwnerPartner,
        "path": path,
        "assigned_trucks": assignedTrucks == null
            ? []
            : List<dynamic>.from(assignedTrucks!.map((x) => x)),
      };

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        name,
        jobCategory,
        email,
        ssNo,
        mobileNumber,
        applicationDate,
        applicationTime,
        status,
        statusCreatedAt,
        statusText,
        previousStatus,
        actionCode,
        trainingStatus,
        trainingStatusText,
        hasDriver,
        driverId,
        teamId,
        isOwnerPartner,
        path,
        assignedTrucks,
      ];
}

final applicationStatuses = EnumValues<ApplicationStatuses>(
  {
    'under_review': ApplicationStatuses.underReview,
    'phone_screening': ApplicationStatuses.phoneScreening,
    'in_process': ApplicationStatuses.inProcess,
    'approved': ApplicationStatuses.approved,
    'hired': ApplicationStatuses.hired,
    'on_hold': ApplicationStatuses.onHold,
    'rejected': ApplicationStatuses.rejected,
    'terminated': ApplicationStatuses.terminated,
  },
);

enum ApplicationStatuses {
  all,
  underReview,
  phoneScreening,
  inProcess,
  approved,
  hired,
  onHold,
  rejected,
  terminated,
}

extension ApplicationStatusesExt on ApplicationStatuses {
  String getName() {
    if (this == ApplicationStatuses.underReview) {
      return "Under Review";
    }

    if (this == ApplicationStatuses.phoneScreening) {
      return "Phone Screening";
    }

    if (this == ApplicationStatuses.inProcess) {
      return "In Process";
    }

    if (this == ApplicationStatuses.onHold) {
      return "On Hold";
    }
    return name.capitalizeFirst ?? "";
  }
}

final jobCategories = EnumValues<JobCategories>(
  {
    'Driver': JobCategories.driver,
    'Owner Operator': JobCategories.ownerOperator,
  },
);

enum JobCategories {
  driver,
  ownerOperator,
}

extension JobCategoriesExt on JobCategories {
  String getName() {
    if (this == JobCategories.driver) {
      return "Driver";
    }
    if (this == JobCategories.ownerOperator) {
      return "Owner Operator";
    }
    return name.capitalizeFirst ?? "";
  }
}
