import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/alternative_user_entity.dart';
import '../entities/eligibility_entity.dart';
import '../entities/incoming_user_leave_request_entity.dart';
import '../entities/leave_history_entity.dart';
import '../entities/leave_type_entity.dart';
import '../entities/remaining_leave_category_entity.dart';
import '../entities/requested_leave_entity.dart';
import '../entities/super_visor_entity.dart';
import '../usecases/check_eligibility_usecase.dart';

abstract class ILeaveManagementRepository {
  //! new request
  Future<Either<List<LeaveTypeEntity>, Failure>> getAllLeaveTypes();
  Future<Either<List<RemainingLeaveCategoryEntity>, Failure>>
      getRemainingLeavesPerCategory();
  Future<Either<List<SupervisorEntity>, Failure>> getAllSupervisors(
    Map<String, dynamic> params,
  );
  Future<Either<List<AlternativeUserEntity>, Failure>> getAlternativeUsers();
  Future<Either<EligibilityEntity, Failure>> checkEligibility(
    CheckEligibilityParams params,
  );
  Future<Either<bool, Failure>> sumbitLeaveRequest(FormData params);

  //! leave requested
  Future<Either<List<RequestEntity>, Failure>> getAllRequestedLeaves(
    Map<String, dynamic> params,
  );

  //! manage leave
  Future<Either<List<UserLeaveRequestEntity>, Failure>>
      getUsersRequestedLeaves();
  Future<Either<bool, Failure>> adminAction(Map<String, dynamic> params);

  //! leave history
  Future<Either<List<LeaveHistoryEntity>, Failure>> getRequestedHistory();
}
