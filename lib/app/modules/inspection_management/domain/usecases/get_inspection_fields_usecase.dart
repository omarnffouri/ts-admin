import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/inspection_entity.dart';
import '../repositories/inspection_management_repository.dart';

class GetInspectionFieldsUsecase
    extends BaseUseCase<List<InspectionEntity>, Map<String, dynamic>> {
  IInspectionManagementRepository repository;
  GetInspectionFieldsUsecase({required this.repository});

  @override
  Future<Either<List<InspectionEntity>, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.getInspectionFields(params);
  }
}
