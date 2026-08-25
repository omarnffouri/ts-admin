// To parse this JSON data, do
//
//     final eligibilityModel = eligibilityModelFromJson(jsonString);

import '../../domain/entities/eligibility_entity.dart';

class EligibilityModel extends EligibilityEntity {
  const EligibilityModel({
    super.leaveType,
    super.availableBalance,
    super.totalDaysOff,
    super.balanceEligibility,
  });

  factory EligibilityModel.fromJson(Map<String, dynamic> json) =>
      EligibilityModel(
        leaveType: json["leave_type"],
        availableBalance: json["available_balance"].toString(),
        totalDaysOff: json["total_days_off"],
        balanceEligibility: json["balance_eligibility"],
      );

  Map<String, dynamic> toJson() => {
        "leave_type": leaveType,
        "available_balance": availableBalance,
        "total_days_off": totalDaysOff,
        "balance_eligibility": balanceEligibility,
      };
}
