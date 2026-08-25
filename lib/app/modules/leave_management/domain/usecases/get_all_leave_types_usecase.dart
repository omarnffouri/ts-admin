import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

import '../entities/leave_type_entity.dart';

class GetAllLeaveTypesUsecase
    extends BaseUseCase<List<LeaveTypeEntity>, NoParams> {
  ILeaveManagementRepository repository;
  GetAllLeaveTypesUsecase({required this.repository});

  @override
  Future<Either<List<LeaveTypeEntity>, Failure>> call(NoParams params) async {
    return await repository.getAllLeaveTypes();
  }
}
