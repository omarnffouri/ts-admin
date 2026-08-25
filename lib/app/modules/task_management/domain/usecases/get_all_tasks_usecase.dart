import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';

import '../entities/task_entity.dart';

class GetAllTasksUsecase
    extends BaseUseCase<BaseResponse<List<TaskEntity>>, Map<String, dynamic>> {
  final TasksRepository repository;

  GetAllTasksUsecase({required this.repository});
  @override
  Future<Either<BaseResponse<List<TaskEntity>>, Failure>> call(
      Map<String, dynamic> params) async {
    return await repository.getAllTasks(params);
  }
}
