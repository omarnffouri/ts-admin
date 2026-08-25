import 'package:equatable/equatable.dart';

class PersonalInformationEntity extends Equatable {
  final int? applicationId;
  final String? companyName;
  final String? jobAppliedFor;
  final String? jobCategory;
  final String? referredBy;
  final bool? active;
  final int? id;
  final String? name;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? ssNo;
  final String? dob;
  final String? mobileNumber;
  final String? otherMobileNumber;
  final String? email;
  final String? status;
  final dynamic previousStatus;
  final String? originalStatus;
  final bool? applicationStatus;
  final dynamic isOwnerPartner;
  final bool? applicationActive;

  const PersonalInformationEntity({
    this.applicationId,
    this.companyName,
    this.jobAppliedFor,
    this.jobCategory,
    this.referredBy,
    this.active,
    this.id,
    this.name,
    this.firstName,
    this.middleName,
    this.lastName,
    this.ssNo,
    this.dob,
    this.mobileNumber,
    this.otherMobileNumber,
    this.email,
    this.status,
    this.previousStatus,
    this.originalStatus,
    this.applicationStatus,
    this.isOwnerPartner,
    this.applicationActive,
  });

  factory PersonalInformationEntity.fromJson(Map<String, dynamic> json) =>
      PersonalInformationEntity(
        applicationId: json["application_id"],
        companyName: json["company_name"],
        jobAppliedFor: json["job_applied_for"],
        jobCategory: json["job_category"],
        referredBy: json["referred_by"],
        active: json["active"],
        id: json["id"],
        name: json["name"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        ssNo: json["ss_no"],
        dob: json["dob"],
        mobileNumber: json["mobile_number"],
        otherMobileNumber: json["other_mobile_number"],
        email: json["email"],
        status: json["status"],
        previousStatus: json["previous_status"],
        originalStatus: json["original_status"],
        applicationStatus: json["application_status"],
        isOwnerPartner: json["is_owner_partner"],
        applicationActive: json["application_active"],
      );

  Map<String, dynamic> toJson() => {
        "application_id": applicationId,
        "company_name": companyName,
        "job_applied_for": jobAppliedFor,
        "job_category": jobCategory,
        "referred_by": referredBy,
        "active": active,
        "id": id,
        "name": name,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "ss_no": ssNo,
        "dob": dob,
        "mobile_number": mobileNumber,
        "other_mobile_number": otherMobileNumber,
        "email": email,
        "status": status,
        "previous_status": previousStatus,
        "original_status": originalStatus,
        "application_status": applicationStatus,
        "is_owner_partner": isOwnerPartner,
        "application_active": applicationActive,
      };

  @override
  List<Object?> get props => [
        applicationId,
        companyName,
        jobAppliedFor,
        jobCategory,
        referredBy,
        active,
        id,
        name,
        firstName,
        middleName,
        lastName,
        ssNo,
        dob,
        mobileNumber,
        otherMobileNumber,
        email,
        status,
        previousStatus,
        originalStatus,
        applicationStatus,
        isOwnerPartner,
        applicationActive,
      ];
}
