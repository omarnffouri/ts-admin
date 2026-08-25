import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/pending_driver_entity.dart';
import '../repositories/inspection_management_repository.dart';

class GetInspectedDriverUsecase
    extends BaseUseCase<List<InspectionDriverEntity>, Map<String, dynamic>> {
  IInspectionManagementRepository repository;
  GetInspectedDriverUsecase({required this.repository});

  @override
  Future<Either<List<InspectionDriverEntity>, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.getInspectedDriver(params);
  }
}
