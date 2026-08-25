import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_listing_data_entity.dart';

import '../entities/task_dropdown_entity.dart';

abstract class TasksRepository {
  Future<Either<BaseResponse<TaskListingDataEntity>, Failure>> getTasksListing(
    NoParams params,
  );

  Future<Either<BaseResponse<List<TaskEntity>>, Failure>> getAllTasks(
    Map<String, dynamic> params,
  );

  Future<Either<BaseResponse<List<TaskEntity>>, Failure>> refreshTasksListing(
    String params,
  );

  Future<Either<BaseResponse<List<TaskDropdownsEntity>>, Failure>>
      getTaskDropdowns(
    NoParams params,
  );

  Future<Either<BaseResponse<bool>, Failure>> createTask(FormData params);

  Future<Either<BaseResponse<bool>, Failure>> updateTask(FormData params);

  Future<Either<BaseResponse<bool>, Failure>> updateTaskProgress(Object params);

  Future<Either<BaseResponse<TaskEntity?>, Failure>> updateTaskStatus(
      Object params);
}
