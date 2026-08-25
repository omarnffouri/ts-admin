import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/constants.dart';

abstract class ISettingsDataSource {
  Future<Either<bool, Failure>> updateOtp(MapBody body);
}

class SettingsDataSourceImp extends ISettingsDataSource {
  final DioClient dioClient;
  SettingsDataSourceImp({required this.dioClient});

  @override
  Future<Either<bool, Failure>> updateOtp(MapBody body) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateOtpValue,
        method: RequestType.PUT,
        data: body,
        converter: (response) {
          try {
            return true;
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
