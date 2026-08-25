import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

import '../entities/eligibility_entity.dart';

class CheckEligibilityUsecase
    extends BaseUseCase<EligibilityEntity, CheckEligibilityParams> {
  ILeaveManagementRepository repository;
  CheckEligibilityUsecase({required this.repository});

  @override
  Future<Either<EligibilityEntity, Failure>> call(
    CheckEligibilityParams params,
  ) async {
    return await repository.checkEligibility(params);
  }
}

class CheckEligibilityParams {
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String userId;

  CheckEligibilityParams({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'leave_type_id': leaveType,
      'from_date': fromDate,
      'to_date': toDate,
    };
  }
}
