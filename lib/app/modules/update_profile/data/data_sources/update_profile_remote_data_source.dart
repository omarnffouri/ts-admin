import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/update_profile/data/models/update_profile_data_model.dart';

abstract class IUpdateProfileDataSource {
  Future<Either<BaseResponse<UpdateProfileDataModel>, Failure>> updateProfile(
      Object params);
}

class UpdateProfileDataSourceImp extends IUpdateProfileDataSource {
  final DioClient dioClient;
  UpdateProfileDataSourceImp({required this.dioClient});
  @override
  Future<Either<BaseResponse<UpdateProfileDataModel>, Failure>> updateProfile(
      Object params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateProfile,
        method: RequestType.POST,
        data: params,
        converter: (response) {
          try {
            return BaseResponse.fromJson(
                response, (p0) => UpdateProfileDataModel.fromJson(p0));
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
