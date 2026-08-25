import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/update_password_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/update_password_params.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

class UpdatePasswordUsecase
    extends BaseUseCase<UpdatePasswordEntity, UpdatePasswordParams> {
  final IAuthRepository repository;

  UpdatePasswordUsecase({required this.repository});

  @override
  Future<Either<UpdatePasswordEntity, Failure>> call(
      UpdatePasswordParams params) async {
    return await repository.updatePassword(params);
  }
}
