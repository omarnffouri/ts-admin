import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';

class LoginUseCase extends BaseUseCase<BaseResponse<LoginPayloadEntity>,
    Map<String, dynamic>> {
  final IAuthRepository authRepository;
  LoginUseCase({required this.authRepository});

  @override
  Future<Either<BaseResponse<LoginPayloadEntity>, Failure>> call(
      Map<String, dynamic> params) async {
    return await authRepository.login(params);
  }
}
