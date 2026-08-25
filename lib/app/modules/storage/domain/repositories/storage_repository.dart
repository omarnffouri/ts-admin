import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/download_resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/storage_users_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/params/delete_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/get_resources_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/rename_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/revoke_resource_permission_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/create_folder_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/share_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/params/upload_file_resource_params.dart';

abstract class IStorageRespository {
  Future<Either<BaseResponse<List<ResourceEntity>?>, Failure>> getResources(
      GetResourcesParams params);
  Future<Either<BaseResponse<DownloadResourceEntity?>, Failure>>
      downloadResource(int resourceId);
  Future<Either<bool, Failure>> revokeResourcePermission(
      RevokeResourcePermissionParams params);
  Future<Either<bool, Failure>> revokeAllResourcePermission(String params);
  Future<Either<bool, Failure>> shareResource(ShareResourceParams params);
  Future<Either<bool, Failure>> deleteResources(DeleteResourcesParams params);
  Future<Either<BaseResponse<StorageUsersEntity?>, Failure>> getStorageUsers();
  Future<Either<bool, Failure>> createFolderResource(CreateFolderParams params);
  Future<Either<bool, Failure>> renameResource(RenameResourceParams params);
  Future<Either<bool, Failure>> uploadFileResource(
      UploadFileResourceParams params);
  Future<Either<bool, Failure>> sendOtp();
  Future<Either<bool, Failure>> verifyOtp(int params);
}
