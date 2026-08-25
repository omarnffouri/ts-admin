import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

import '../entities/leave_history_entity.dart';

class GetRequestedHistoryUsecase
    extends BaseUseCase<List<LeaveHistoryEntity>, NoParams> {
  ILeaveManagementRepository repository;
  GetRequestedHistoryUsecase({required this.repository});

  @override
  Future<Either<List<LeaveHistoryEntity>, Failure>> call(
    NoParams params,
  ) async {
    return await repository.getRequestedHistory();
  }
}
