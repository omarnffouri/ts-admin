import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/data/models/app_configration_model.dart';
import 'package:ts_admin/app/modules/auth/data/models/logout_model.dart';
import 'package:ts_admin/app/modules/auth/data/models/realtime_configuration_model.dart';
import 'package:ts_admin/app/modules/auth/data/models/update_password_model.dart';
import 'package:ts_admin/app/modules/auth/data/models/user_permission_model.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/user_permission_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/params/update_password_params.dart';
import 'package:ts_admin/app/modules/auth/data/models/login_model.dart';
import 'package:ts_admin/app/modules/auth/domain/params/verify_otp_params.dart';

abstract class IAuthRemoteDataSource {
  Future<Either<BaseResponse<LoginPayloadModel>, Failure>> login(
      Map<String, dynamic> body);

  Future<Either<BaseResponse<LoginPayloadModel>, Failure>> verifyOtp(
      VerifyOtpParams body);

  /// The `user` block, same shape as login's.
  Future<Either<UserModel, Failure>> getProfile();

  Future<Either<UpdatePasswordModel, Failure>> updatePassword(
      UpdatePasswordParams params);

  Future<Either<BaseResponse<List<UserPermissionEntity>>, Failure>>
      getUserPermissions();
  Future<Either<bool, Failure>> updateVoipToken(String params);
  Future<Either<LogoutModel, Failure>> logout();
  Future<Either<AppConfigurationModel, Failure>> getAppConfigration();
  Future<Either<BaseResponse<RealtimeConfigurationModel>, Failure>>
      getRealtimeConfiguration();
}

class AuthRemoteDataSourceImp extends IAuthRemoteDataSource {
  final DioClient dioClient;
  AuthRemoteDataSourceImp({required this.dioClient});
  @override
  Future<Either<UpdatePasswordModel, Failure>> updatePassword(
      UpdatePasswordParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updatePassword,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          try {
            return UpdatePasswordModel.fromJson(response);
          } catch (e) {
            throw Exception(e);
          }
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<LoginPayloadModel>, Failure>> login(
      Map<String, dynamic> body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.login,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          return BaseResponse<LoginPayloadModel>.fromJson(
            response as Map<String, dynamic>,
            (payload) => LoginPayloadModel.fromJson(payload),
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<List<UserPermissionEntity>>, Failure>>
      getUserPermissions() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.userPermissions,
        method: RequestType.GET,
        converter: (response) => BaseResponse.listFromJson(
          response as Map<String, dynamic>,
          (x) => UserPermissionModel.fromJson(x),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<LogoutModel, Failure>> logout() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.logout,
        method: RequestType.POST,
        converter: (response) {
          return LogoutModel.fromJson(response);
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> updateVoipToken(String params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateVoip,
        data: {
          "voip_token": params,
        },
        method: RequestType.POST,
        converter: (response) {
          final data = BaseResponse.fromJson(response, (json) {
            return null;
          });
          return data.code == 200;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<LoginPayloadModel>, Failure>> verifyOtp(
      VerifyOtpParams body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.verifyOtp,
        method: RequestType.PUT,
        data: body.toJson(),
        converter: (response) {
          return BaseResponse<LoginPayloadModel>.fromJson(
            response as Map<String, dynamic>,
            (payload) => LoginPayloadModel.fromJson(payload),
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<AppConfigurationModel, Failure>> getAppConfigration() async {
    final response = await dioClient.makeRequest(
      url: ApiConstants.getAppConfiguration,
      method: RequestType.GET,
      converter: (response) {
        return AppConfigurationModel.fromJson(response['data']);
      },
    );
    return response;
  }

  @override
  Future<Either<BaseResponse<RealtimeConfigurationModel>, Failure>>
      getRealtimeConfiguration() async {
    final response = await dioClient.makeRequest(
      url: ApiConstants.realtimeConfiguration,
      method: RequestType.GET,
      converter: (response) {
        return BaseResponse<RealtimeConfigurationModel>.fromJson(
          response as Map<String, dynamic>,
          (payload) => RealtimeConfigurationModel.fromJson(payload),
        );
      },
    );
    return response;
  }

  @override
  Future<Either<UserModel, Failure>> getProfile() async {
    final response = await dioClient.makeRequest(
      url: ApiConstants.profile,
      method: RequestType.GET,
      converter: (response) {
        final user = response['data']?['user'];
        if (user == null) {
          throw ServerException(message: 'Profile response has no user');
        }
        return UserModel.fromJson(user);
      },
    );
    return response;
  }
}
