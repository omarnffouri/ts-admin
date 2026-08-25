import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/inspection_dropdown_entity.dart';
import '../repositories/inspection_management_repository.dart';

class GetInspectionDropdownUsecase
    extends BaseUseCase<InspectionDropdownEntity, NoParams> {
  final IInspectionManagementRepository repository;

  GetInspectionDropdownUsecase({required this.repository});

  @override
  Future<Either<InspectionDropdownEntity, Failure>> call(
      NoParams params) async {
    return await repository.getInspectionDropdown();
  }
}
