import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/user_management_repository.dart';

class UpdateUserStatusUsecase extends BaseUseCase<bool, Map<String, dynamic>> {
  IUserManagementRepository repository;
  UpdateUserStatusUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.updateUserStatus(params);
  }
}
