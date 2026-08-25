import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/data/data_sources/auth_data_source.dart';
import 'package:ts_admin/app/modules/auth/data/models/login_model.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/app_configration_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/logout_entitiy.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/update_password_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/user_permission_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/update_password_params.dart';
import 'package:ts_admin/app/modules/auth/domain/params/verify_otp_params.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class AuthRepositoryImp extends IAuthRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  IAuthRemoteDataSource dataSource;

  AuthRepositoryImp({
    required this.dataSource,
  });

  static const Failure _offline =
      OfflineFailure(message: 'No Internet, try again later');

  @override
  Future<Either<UpdatePasswordEntity, Failure>> updatePassword(
      UpdatePasswordParams params) async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.updatePassword(params);
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<BaseResponse<LoginPayloadModel>, Failure>> login(
      Map<String, dynamic> body) async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.login(body);
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<BaseResponse<List<UserPermissionEntity>>, Failure>>
      getUserPermissions() async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.getUserPermissions();
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<LogoutEntity, Failure>> logout() async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.logout();
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<bool, Failure>> updateVoipToken(String params) async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.updateVoipToken(params);
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<BaseResponse<LoginPayloadEntity>, Failure>> verifyOtp(
      VerifyOtpParams body) async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.verifyOtp(body);
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<AppConfiguration, Failure>> getAppConfigration() async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.getAppConfigration();
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<BaseResponse<RealtimeConfiguration>, Failure>>
      getRealtimeConfiguration() async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.getRealtimeConfiguration();
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> getProfile() async {
    if (!await networkInfo.isConnected) return const Right(_offline);
    try {
      return await dataSource.getProfile();
    } on ServerException catch (e) {
      return Right(ServerFailure(title: '', message: e.message));
    }
  }
}
