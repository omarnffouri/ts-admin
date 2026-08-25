import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';

class UpdateTaskProgressUsecase
    extends BaseUseCase<BaseResponse<bool>, Object> {
  final TasksRepository repository;

  UpdateTaskProgressUsecase({required this.repository});
  @override
  Future<Either<BaseResponse<bool>, Failure>> call(Object params) async {
    return await repository.updateTaskProgress(params);
  }
}
