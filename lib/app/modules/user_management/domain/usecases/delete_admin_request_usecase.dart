import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/user_management_repository.dart';

class DeleteAdminUsecase extends BaseUseCase<bool, String> {
  IUserManagementRepository repository;
  DeleteAdminUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(
    String params,
  ) async {
    return await repository.deleteUser(params);
  }
}
