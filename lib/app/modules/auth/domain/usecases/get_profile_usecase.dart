import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase extends BaseUseCase<UserEntity, NoParams> {
  final IAuthRepository authRepository;

  GetProfileUseCase({required this.authRepository});

  @override
  Future<Either<UserEntity, Failure>> call(NoParams params) async {
    return await authRepository.getProfile();
  }
}
