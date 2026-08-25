import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/inspection_details_entity.dart';
import '../repositories/inspection_management_repository.dart';

class GetInspectionDetailsUsecase
    extends BaseUseCase<InspectionDetailsEntity, Map<String, dynamic>> {
  IInspectionManagementRepository repository;
  GetInspectionDetailsUsecase({required this.repository});

  @override
  Future<Either<InspectionDetailsEntity, Failure>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.getInspectionDetails(params);
  }
}
