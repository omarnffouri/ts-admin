import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

class AdminActionUsecase extends BaseUseCase<bool, Map<String, dynamic>> {
  ILeaveManagementRepository repository;
  AdminActionUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Map<String, dynamic> params) async {
    return await repository.adminAction(params);
  }
}
