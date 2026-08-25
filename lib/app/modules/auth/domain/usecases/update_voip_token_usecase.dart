import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

class UpdateVoipTokenUsecase extends BaseUseCase<bool, String> {
  final IAuthRepository repository;

  UpdateVoipTokenUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(String params) async {
    return await repository.updateVoipToken(params);
  }
}
