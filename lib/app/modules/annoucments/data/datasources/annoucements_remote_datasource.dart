import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../../../core/enum/http_request_type.dart';
import '../models/annoucement_model.dart';
import '../models/user_type_model.dart';

abstract class IAnnoucementsRemoteDataSource {
  Future<Either<List<AnnoucementModel>, Failure>> getAllAnnoucements();
  Future<Either<bool, Failure>> createAnnoucement(FormData params);
  Future<Either<bool, Failure>> updateAnnoucementReadStatus(int annoucementId);
  Future<Either<UserTypeModel, Failure>> getAnnoucementUserTypes();
}

class AnnoucementRemoteDataSourceImpl implements IAnnoucementsRemoteDataSource {
  final DioClient dioClient;
  AnnoucementRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<List<AnnoucementModel>, Failure>> getAllAnnoucements() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllAnnoucements,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => AnnoucementModel.fromJson(e))
                .toList();
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
  Future<Either<bool, Failure>> createAnnoucement(FormData params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.sendNotification,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return (response["code"] == 200 || response["code"] == 201);
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
  Future<Either<bool, Failure>> updateAnnoucementReadStatus(
      int annoucementId) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateAccoucementReadStatus,
        data: {"id": annoucementId},
        method: RequestType.PUT,
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
  Future<Either<UserTypeModel, Failure>> getAnnoucementUserTypes() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllUserTypes,
        converter: (response) {
          try {
            return UserTypeModel.fromJson(response['data']['data']);
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
}
