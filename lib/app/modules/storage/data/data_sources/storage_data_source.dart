import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/data/models/download_resource_model.dart';
import 'package:ts_admin/app/modules/storage/data/models/resource_model.dart';
import 'package:ts_admin/app/modules/storage/data/models/storage_users_model.dart';
import 'package:ts_admin/app/modules/storage/domain/params/delete_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/get_resources_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/rename_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/revoke_resource_permission_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/create_folder_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/share_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/upload_file_resource_params.dart';

abstract class IStorageDataSource {
  Future<Either<BaseResponse<List<ResourceModel>?>, Failure>> getResources(
      GetResourcesParams params);
  Future<Either<BaseResponse<DownloadResourceModel?>, Failure>>
      downloadResource(int resourceId);
  Future<Either<bool, Failure>> revokeResourcePermission(
      RevokeResourcePermissionParams params);
  Future<Either<bool, Failure>> shareResource(ShareResourceParams params);
  Future<Either<bool, Failure>> deleteResources(DeleteResourcesParams params);
  Future<Either<BaseResponse<StorageUsersModel?>, Failure>> getStorageUsers();
  Future<Either<bool, Failure>> createFolderResource(CreateFolderParams params);
  Future<Either<bool, Failure>> renameResource(RenameResourceParams params);
  Future<Either<bool, Failure>> uploadFileResource(
      UploadFileResourceParams params);
  Future<Either<bool, Failure>> sendOtp();
  Future<Either<bool, Failure>> verifyOtp(int params);
  Future<Either<bool, Failure>> revokeAllResourcePermission(String params);
}

class StorageRemoteDataSource extends IStorageDataSource {
  final DioClient dioClient;
  StorageRemoteDataSource({required this.dioClient});
  @override
  Future<Either<bool, Failure>> deleteResources(
      DeleteResourcesParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.deleteResource,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          return response['code'] == 200 || response['code'] == 201;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<DownloadResourceModel?>, Failure>>
      downloadResource(int resourceId) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.downloadResource,
        method: RequestType.GET,
        queryParams: {"id": resourceId},
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return DownloadResourceModel.fromJson(json);
            },
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<List<ResourceModel>?>, Failure>> getResources(
      GetResourcesParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getResources,
        method: RequestType.GET,
        queryParams: params.toJson(),
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return (json as List?)
                  ?.map((e) => ResourceModel.fromJson(e))
                  .toList();
            },
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<StorageUsersModel?>, Failure>>
      getStorageUsers() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getUserForResourceShare,
        method: RequestType.POST,
        data: {
          "lookup": {
            "employees": {
              "admins": true,
            }
          }
        },
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return StorageUsersModel.fromJson(json);
            },
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> revokeResourcePermission(
      RevokeResourcePermissionParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.revokeResourcePermission,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          return response['code'] == 200 || response['code'] == 201;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> revokeAllResourcePermission(
      String params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.revokeAllResourcePermission,
        method: RequestType.POST,
        data: {"id": params},
        converter: (response) {
          return response['code'] == 200 || response['code'] == 201;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> shareResource(
      ShareResourceParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.shareResource,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          return response['code'] == 200 || response['code'] == 201;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> createFolderResource(
      CreateFolderParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.saveResource,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          return response['code'] == 200 || response['code'] == 201;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> renameResource(
      RenameResourceParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.saveResource,
        method: RequestType.POST,
        data: params.toJson(),
        converter: (response) {
          return response['code'] == 200 || response['code'] == 201;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> uploadFileResource(
      UploadFileResourceParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.saveResource,
        method: RequestType.POST,
        data: params.getFormData(),
        cancelToken: params.cancelToken,
        onSendProgress: params.onSendProgress,
        converter: (response) {
          return response['code'] == 200 || response['code'] == 201;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> sendOtp() async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.sendDriveOtp,
        method: RequestType.GET,
        converter: (response) {
          return response['code'] == 200;
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<bool, Failure>> verifyOtp(int params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.verifyDriveOtp,
        method: RequestType.POST,
        data: {"otpCode": params},
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
