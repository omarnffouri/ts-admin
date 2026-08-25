import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/app_configration_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/logout_entitiy.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/update_password_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/user_permission_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/update_password_params.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/verify_otp_params.dart';

import '../../../../core/network/error/failures.dart';

abstract class IAuthRepository {
  Future<Either<UpdatePasswordEntity, Failure>> updatePassword(
      UpdatePasswordParams params);

  Future<Either<BaseResponse<LoginPayloadEntity>, Failure>> login(
    Map<String, dynamic> body,
  );

  Future<Either<BaseResponse<LoginPayloadEntity>, Failure>> verifyOtp(
    VerifyOtpParams body,
  );

  Future<Either<UserEntity, Failure>> getProfile();

  Future<Either<BaseResponse<List<UserPermissionEntity>>, Failure>>
      getUserPermissions();

  Future<Either<bool, Failure>> updateVoipToken(String params);

  Future<Either<LogoutEntity, Failure>> logout();
  Future<Either<AppConfiguration, Failure>> getAppConfigration();
  Future<Either<BaseResponse<RealtimeConfiguration>, Failure>>
      getRealtimeConfiguration();
}
