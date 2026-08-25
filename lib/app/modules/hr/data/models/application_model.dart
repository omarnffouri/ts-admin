import 'dart:convert';
import 'package:ts_admin/app/modules/hr/domain/entities/application_entity.dart';

ApplicationModel applicationModelFromJson(String str) =>
    ApplicationModel.fromJson(json.decode(str));

String applicationModelToJson(ApplicationModel data) =>
    json.encode(data.toJson());

class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    super.id,
    super.firstName,
    super.lastName,
    super.name,
    super.jobCategory,
    super.email,
    super.ssNo,
    super.mobileNumber,
    super.applicationDate,
    super.applicationTime,
    super.status,
    super.statusCreatedAt,
    super.statusText,
    super.previousStatus,
    super.actionCode,
    super.trainingStatus,
    super.trainingStatusText,
    super.hasDriver,
    super.driverId,
    super.teamId,
    super.isOwnerPartner,
    super.path,
    super.assignedTrucks,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      ApplicationModel(
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

  @override
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
}
