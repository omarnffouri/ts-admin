import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';

class SubmitLeaveRequestUsecase extends BaseUseCase<bool, FormData> {
  ILeaveManagementRepository repository;
  SubmitLeaveRequestUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(FormData params) async {
    return await repository.sumbitLeaveRequest(params);
  }
}
