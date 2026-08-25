import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/user_management_repository.dart';

class UpdateAdminUsecase extends BaseUseCase<bool, Map<String, dynamic>> {
  IUserManagementRepository repository;
  UpdateAdminUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.updateAdmin(params);
  }
}
