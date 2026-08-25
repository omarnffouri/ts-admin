import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../../../core/enum/http_request_type.dart';
import '../../../../core/values/constants.dart';
import '../models/form_model.dart';

abstract class IFormRemoteDataSource {
  Future<Either<List<FormModel>, Failure>> getAllForms();
  Future<Either<bool, Failure>> signForm(MapBody body);
  Future<Either<bool, Failure>> rejectForm(MapBody body);
}

class FormRemoteDataSourceImpl implements IFormRemoteDataSource {
  final DioClient dioClient;
  FormRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<List<FormModel>, Failure>> getAllForms() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getForms,
        converter: (response) {
          try {
            return (response['data'] as List? ?? [])
                .map((e) => FormModel.fromJson(e))
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
  Future<Either<bool, Failure>> signForm(MapBody body) async {
    try {
      final response = await dioClient.makeRequest(
        method: RequestType.POST,
        url: ApiConstants.signForm,
        data: body,
        converter: (response) {
          try {
            return (response['data'] != null);
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
  Future<Either<bool, Failure>> rejectForm(MapBody body) async {
    try {
      final response = await dioClient.makeRequest(
        method: RequestType.PUT,
        url: ApiConstants.rejectForm,
        data: body,
        converter: (response) {
          try {
            return (response['code'] == 200);
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
