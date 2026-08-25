import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

import '../entities/super_visor_entity.dart';

class GetAllSuperVisorsUsecase
    extends BaseUseCase<List<SupervisorEntity>, Map<String, dynamic>> {
  ILeaveManagementRepository repository;
  GetAllSuperVisorsUsecase({required this.repository});

  @override
  Future<Either<List<SupervisorEntity>, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.getAllSupervisors(params);
  }
}
