import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_dropdown_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';

class GetTaskDropdownUsecase
    extends BaseUseCase<BaseResponse<List<TaskDropdownsEntity>>, NoParams> {
  final TasksRepository repository;

  GetTaskDropdownUsecase({required this.repository});
  @override
  Future<Either<BaseResponse<List<TaskDropdownsEntity>>, Failure>> call(
      NoParams params) async {
    return await repository.getTaskDropdowns(params);
  }
}
