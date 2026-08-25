import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/hr/data/models/application_data_model.dart';
import 'package:ts_admin/app/modules/hr/data/models/application_model.dart';
import 'package:ts_admin/app/modules/hr/domain/params/get_applications_params.dart';

abstract class HrRemoteDataSource {
  Future<Either<BaseResponse<List<ApplicationModel>>, Failure>> getApplications(
      GetApplicationsParams params);
  Future<Either<BaseResponse<ApplicationDataModel>, Failure>>
      getApplicationDetails(int params);
}

class HrRemoteDataSourceImp extends HrRemoteDataSource {
  final DioClient dioClient;
  HrRemoteDataSourceImp({required this.dioClient});
  @override
  Future<Either<BaseResponse<List<ApplicationModel>>, Failure>> getApplications(
    GetApplicationsParams params,
  ) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getApplications,
        method: RequestType.GET,
        data: params.toJson(),
        converter: (response) => BaseResponse.listFromJson(
          response,
          (x) => ApplicationModel.fromJson(x),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<ApplicationDataModel>, Failure>>
      getApplicationDetails(int params) async {
    try {
      final response = await dioClient.makeRequest(
        url: "${ApiConstants.getApplicationDetails}/$params/details",
        method: RequestType.GET,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return ApplicationDataModel.fromJson(json);
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
