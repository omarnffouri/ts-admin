import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/inspection_management_repository.dart';

class SubmitInspectionUsecase extends BaseUseCase<bool, Map<String, dynamic>> {
  IInspectionManagementRepository repository;
  SubmitInspectionUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.sumbitRequest(params);
  }
}
