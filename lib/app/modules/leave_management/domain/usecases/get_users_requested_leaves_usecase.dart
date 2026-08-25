import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';
import '../entities/incoming_user_leave_request_entity.dart';

class GetUsersRequestedLeavesUsecase
    extends BaseUseCase<List<UserLeaveRequestEntity>, NoParams> {
  ILeaveManagementRepository repository;
  GetUsersRequestedLeavesUsecase({required this.repository});

  @override
  Future<Either<List<UserLeaveRequestEntity>, Failure>> call(
      NoParams params) async {
    return await repository.getUsersRequestedLeaves();
  }
}
