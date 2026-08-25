import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/data/data_sources/storage_data_source.dart';
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
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class StorageRepositoryImp extends IStorageRespository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  final IStorageDataSource dataSource;

  StorageRepositoryImp({required this.dataSource});

  @override
  Future<Either<bool, Failure>> deleteResources(
      DeleteResourcesParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.deleteResources(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<BaseResponse<DownloadResourceEntity?>, Failure>>
      downloadResource(int resourceId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.downloadResource(resourceId);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<BaseResponse<List<ResourceEntity>?>, Failure>> getResources(
      GetResourcesParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getResources(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<BaseResponse<StorageUsersEntity?>, Failure>>
      getStorageUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getStorageUsers();
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> revokeResourcePermission(
      RevokeResourcePermissionParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.revokeResourcePermission(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> revokeAllResourcePermission(
      String params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.revokeAllResourcePermission(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> shareResource(
      ShareResourceParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.shareResource(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> createFolderResource(
      CreateFolderParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.createFolderResource(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> renameResource(
      RenameResourceParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.renameResource(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> uploadFileResource(
      UploadFileResourceParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.uploadFileResource(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> verifyOtp(int params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.verifyOtp(params);
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }

  @override
  Future<Either<bool, Failure>> sendOtp() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.sendOtp();
        return response.fold(
          (data) => Left(data),
          (failure) => Right(failure),
        );
      } on ServerException catch (e) {
        return Right(ServerFailure(title: '', message: e.message));
      }
    } else {
      return const Right(
        OfflineFailure(message: 'No Internet, try again later'),
      );
    }
  }
}
