import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/user_entity.dart';
import '../repositories/user_management_repository.dart';

class GetAllUsersUsecase
    extends BaseUseCase<BaseResponse<List<UserEntity>>, Map<String, dynamic>> {
  IUserManagementRepository repository;
  GetAllUsersUsecase({required this.repository});

  @override
  Future<Either<BaseResponse<List<UserEntity>>, Failure>> call(
      Map<String, dynamic> params) async {
    return await repository.getAllUsers(params);
  }
}
