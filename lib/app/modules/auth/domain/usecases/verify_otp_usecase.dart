import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/verify_otp_params.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';

class VerifyOtpUsecase
    extends BaseUseCase<BaseResponse<LoginPayloadEntity>, VerifyOtpParams> {
  final IAuthRepository authRepository;
  VerifyOtpUsecase({required this.authRepository});

  @override
  Future<Either<BaseResponse<LoginPayloadEntity>, Failure>> call(
      VerifyOtpParams params) async {
    return await authRepository.verifyOtp(params);
  }
}
