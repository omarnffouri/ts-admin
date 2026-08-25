// To parse this JSON data, do
//
//     final eligibilityModel = eligibilityModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

class EligibilityEntity extends Equatable {
  final String? leaveType;
  final String? availableBalance;
  final int? totalDaysOff;
  final bool? balanceEligibility;

  const EligibilityEntity({
    this.leaveType,
    this.availableBalance,
    this.totalDaysOff,
    this.balanceEligibility,
  });

  @override
  List<Object?> get props => [
        leaveType,
        availableBalance,
        totalDaysOff,
        balanceEligibility,
      ];
}
