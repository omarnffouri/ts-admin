import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';

class UpdateTaskUsecase extends BaseUseCase<BaseResponse<bool>, FormData> {
  final TasksRepository repository;

  UpdateTaskUsecase({required this.repository});
  @override
  Future<Either<BaseResponse<bool>, Failure>> call(FormData params) async {
    return await repository.createTask(params);
  }
}
