import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

import '../entities/requested_leave_entity.dart';

class GetRequestedLeavesUsecase
    extends BaseUseCase<List<RequestEntity>, Map<String, dynamic>> {
  ILeaveManagementRepository repository;
  GetRequestedLeavesUsecase({required this.repository});

  @override
  Future<Either<List<RequestEntity>, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.getAllRequestedLeaves(params);
  }
}
