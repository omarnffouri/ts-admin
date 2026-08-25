import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/connection/network_info.dart';
import 'package:ts_admin/app/core/network/error/exceptions.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/data/data_sources/tasks_remote_data_source.dart';
import 'package:ts_admin/app/modules/task_management/data/models/task_dropdown_model.dart';
import 'package:ts_admin/app/modules/task_management/data/models/task_model.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_listing_data_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class TasksRepositoryImp extends TasksRepository {
  NetworkInfoImpl networkInfo = NetworkInfoImpl(dataConnectionChecker: sl());

  final TasksRemoteDataSource dataSource;

  TasksRepositoryImp({required this.dataSource});

  @override
  Future<Either<BaseResponse<bool>, Failure>> createTask(
      FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.createTask(params);
        return response.fold(
          (resposne) => Left(resposne),
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
  Future<Either<BaseResponse<bool>, Failure>> updateTask(
      FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateTask(params);
        return response.fold(
          (resposne) => Left(resposne),
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
  Future<Either<BaseResponse<TaskListingDataEntity>, Failure>> getTasksListing(
      NoParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getTaskListing(params);
        return response.fold(
          (resposne) => Left(resposne),
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
  Future<Either<BaseResponse<List<TaskModel>>, Failure>> getAllTasks(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getAllTasks(params);
        return response.fold(
          (resposne) => Left(resposne),
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
  Future<Either<BaseResponse<List<TaskModel>>, Failure>> refreshTasksListing(
      String params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.refreshTaskListing(params);
        return response.fold(
          (resposne) => Left(resposne),
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
  Future<Either<BaseResponse<List<TaskDropdownsModel>>, Failure>>
      getTaskDropdowns(NoParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getTaskDropdowns(params);
        return response.fold(
          (resposne) => Left(resposne),
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
  Future<Either<BaseResponse<bool>, Failure>> updateTaskProgress(
      Object params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateTaskProgress(params);
        return response.fold(
          (resposne) => Left(resposne),
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
  Future<Either<BaseResponse<TaskModel?>, Failure>> updateTaskStatus(
      Object params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.updateTaskStatus(params);
        return response.fold(
          (resposne) => Left(resposne),
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
