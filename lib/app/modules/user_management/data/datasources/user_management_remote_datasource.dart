import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/user_management/data/models/data_model.dart';

import '../models/rule_model.dart';
import '../models/user_mode.dart';

abstract class IUserManagementRemoteDataSource {
  Future<Either<bool, Failure>> createAdmin(Map<String, dynamic> params);
  Future<Either<bool, Failure>> updateAdmin(Map<String, dynamic> params);
  Future<Either<bool, Failure>> updateUserStatus(Map<String, dynamic> params);
  Future<Either<bool, Failure>> updateAdminPassword(
      Map<String, dynamic> params);
  Future<Either<bool, Failure>> deleteUser(String params);
  Future<Either<BaseResponse<List<UserModel>>, Failure>> getAllUsers(
      Map<String, dynamic> params);
  Future<Either<List<RuleModel>, Failure>> getAllRules();
  Future<Either<List<DataModel>, Failure>> getAllCountries();
  Future<Either<List<DataModel>, Failure>> getAllSupervisors();
  Future<Either<List<DataModel>, Failure>> getAllDepartments();
  Future<Either<List<DataModel>, Failure>> getAllDesignations();
  Future<Either<List<DataModel>, Failure>> getUserOffDays();
}

class UserManagementRemoteDataSourceImpl
    extends IUserManagementRemoteDataSource {
  final DioClient dioClient;
  UserManagementRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<bool, Failure>> createAdmin(Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createAdmin,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return response['code'] == 200;
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
  Future<Either<bool, Failure>> updateAdmin(Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateAdmin,
        method: RequestType.PUT,
        data: params,
        converter: (response) {
          try {
            return response['code'] == 200;
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
  Future<Either<bool, Failure>> deleteUser(String params) async {
    try {
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.deleteAdmin}$params/delete",
        method: RequestType.DELETE,
        converter: (response) {
          try {
            return response['code'] == 200;
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

  // this method for updating admins password
  @override
  Future<Either<bool, Failure>> updateAdminPassword(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateAdminsPassword,
        method: RequestType.PATCH,
        data: params,
        converter: (response) {
          try {
            return response['code'] == 200;
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
  Future<Either<BaseResponse<List<UserModel>>, Failure>> getAllUsers(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllUsers,
        data: params,
        converter: (response) {
          final int limit = (params['limit'] as num?)?.toInt() ?? 0;
          return BaseResponse.listFromJson(
            response,
            (e) => UserModel.fromJson(e),
            hasMoreWhenOmitted: (data) => limit > 0 && data.length >= limit,
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<RuleModel>, Failure>> getAllRules() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllRules,
        converter: (response) {
          return (response['data'] as List? ?? [])
              .map((e) => RuleModel.fromJson(e))
              .toList();
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<DataModel>, Failure>> getAllCountries() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllCountries,
        converter: (response) {
          return (response['data'] as List? ?? [])
              .map((e) => DataModel.fromJson(e))
              .toList();
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<DataModel>, Failure>> getAllSupervisors() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllSupervisors,
        converter: (response) {
          return (response['data'] as List? ?? [])
              .map((e) => DataModel.fromJson(e))
              .toList();
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<DataModel>, Failure>> getAllDepartments() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllDepartments,
        converter: (response) {
          return (response['data'] as List? ?? [])
              .map((e) => DataModel.fromJson(e))
              .toList();
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<DataModel>, Failure>> getAllDesignations() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllDesignations,
        converter: (response) {
          return (response['data'] as List? ?? [])
              .map((e) => DataModel.fromJson(e))
              .toList();
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<List<DataModel>, Failure>> getUserOffDays() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getUserOffDays,
        converter: (response) {
          return (response['data'] as List? ?? [])
              .map((e) => DataModel.fromJson(e))
              .toList();
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> updateUserStatus(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.upadateUserStatus,
        method: RequestType.PUT,
        data: params,
        converter: (response) {
          return response['code'] == 200;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
