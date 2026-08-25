import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';

class UpdateTaskStatusUsecase
    extends BaseUseCase<BaseResponse<TaskEntity?>, Object> {
  final TasksRepository repository;

  UpdateTaskStatusUsecase({required this.repository});
  @override
  Future<Either<BaseResponse<TaskEntity?>, Failure>> call(Object params) async {
    return await repository.updateTaskStatus(params);
  }
}
