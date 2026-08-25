import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/enum/http_request_type.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/network/connection/dio_client.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/data/models/task_dropdown_model.dart';
import 'package:ts_admin/app/modules/task_management/data/models/task_listing_data_model.dart';
import 'package:ts_admin/app/modules/task_management/data/models/task_model.dart';

abstract class TasksRemoteDataSource {
  Future<Either<BaseResponse<TaskListingDataModel>, Failure>> getTaskListing(
    NoParams params,
  );

  Future<Either<BaseResponse<List<TaskModel>>, Failure>> getAllTasks(
    Map<String, dynamic> params,
  );

  Future<Either<BaseResponse<List<TaskModel>>, Failure>> refreshTaskListing(
      String params);

  Future<Either<BaseResponse<List<TaskDropdownsModel>>, Failure>>
      getTaskDropdowns(NoParams params);

  Future<Either<BaseResponse<bool>, Failure>> createTask(FormData params);

  Future<Either<BaseResponse<bool>, Failure>> updateTask(FormData params);

  Future<Either<BaseResponse<TaskModel?>, Failure>> updateTaskStatus(
      Object params);

  Future<Either<BaseResponse<bool>, Failure>> updateTaskProgress(Object params);
}

class TasksRemoteDataSourceImp extends TasksRemoteDataSource {
  final DioClient dioClient;
  TasksRemoteDataSourceImp({required this.dioClient});
  @override
  Future<Either<BaseResponse<TaskListingDataModel>, Failure>> getTaskListing(
      NoParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getTasksListing,
        method: RequestType.GET,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return TaskListingDataModel.fromJson(json ?? {});
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
  Future<Either<BaseResponse<List<TaskModel>>, Failure>> getAllTasks(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getAllTasks,
        data: params,
        method: RequestType.GET,
        converter: (response) {
          final int pageSize = (params['pageSize'] as num?)?.toInt() ?? 0;
          return BaseResponse.listFromJson(
            response,
            (e) => TaskModel.fromJson(e),
            hasMoreWhenOmitted: (data) =>
                pageSize > 0 && data.length >= pageSize,
          );
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<List<TaskModel>>, Failure>> refreshTaskListing(
      String params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getTasksListing,
        method: RequestType.GET,
        data: {
          "status": [params]
        },
        converter: (response) => BaseResponse.listFromJson(
          response,
          (x) => TaskModel.fromJson(x),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<List<TaskDropdownsModel>>, Failure>>
      getTaskDropdowns(NoParams params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.getTasksDropdowns,
        method: RequestType.GET,
        converter: (response) => BaseResponse.listFromJson(
          response,
          (e) => TaskDropdownsModel.fromJson(e),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<BaseResponse<bool>, Failure>> createTask(
      FormData params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.createTask,
        method: RequestType.POST,
        data: params,
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

  @override
  Future<Either<BaseResponse<bool>, Failure>> updateTask(
      FormData params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateTask,
        method: RequestType.POST,
        data: params,
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

  @override
  Future<Either<BaseResponse<bool>, Failure>> updateTaskProgress(
      Object params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateTaskProgress,
        method: RequestType.PUT,
        data: params,
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

  @override
  Future<Either<BaseResponse<TaskModel?>, Failure>> updateTaskStatus(
      Object params) async {
    try {
      final response = await dioClient.makeRequest(
        url: ApiConstants.updateTaskStatus,
        method: RequestType.PUT,
        data: params,
        converter: (response) {
          return BaseResponse.fromJson(
            response,
            (json) {
              return json == null ? null : TaskModel.fromJson(json);
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
