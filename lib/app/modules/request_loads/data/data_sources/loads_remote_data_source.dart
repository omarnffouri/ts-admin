import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';

import '../../../../core/network/connection/api_constants.dart';
import '../../../../core/network/connection/dio_client.dart';
import '../../../../core/network/error/failures.dart';

abstract class ILoadsRemoteDataSource {
  Future<Either<BaseResponse<bool>, Failure>> requestLoads(
      Map<String, dynamic> body);
}

class LoadsRemoteDataSourceImp extends ILoadsRemoteDataSource {
  final DioClient dioClient;
  LoadsRemoteDataSourceImp({required this.dioClient});
  @override
  Future<Either<BaseResponse<bool>, Failure>> requestLoads(
      Map<String, dynamic> body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.requestLoads,
        method: RequestType.POST,
        data: body,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return response['code'] == 200;
            },
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
