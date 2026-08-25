import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/logout_entitiy.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase extends BaseUseCase<LogoutEntity, NoParams> {
  final IAuthRepository repository;

  LogoutUsecase({required this.repository});

  @override
  Future<Either<LogoutEntity, Failure>> call(NoParams params) async {
    return await repository.logout();
  }
}
