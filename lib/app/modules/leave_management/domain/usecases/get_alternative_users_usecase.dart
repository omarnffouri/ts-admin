import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/alternative_user_entity.dart';
import '../repositories/leave_management_repository.dart';

class GetAlternativeUsersUsecase
    extends BaseUseCase<List<AlternativeUserEntity>, NoParams> {
  ILeaveManagementRepository repository;
  GetAlternativeUsersUsecase({required this.repository});

  @override
  Future<Either<List<AlternativeUserEntity>, Failure>> call(
    NoParams params,
  ) async {
    return await repository.getAlternativeUsers();
  }
}
