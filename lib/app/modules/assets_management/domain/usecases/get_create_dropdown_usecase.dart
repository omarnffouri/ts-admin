import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/create_dropdown_entity.dart';
import '../repositories/assets_repository.dart';

class GetCreateDropdownUsecase extends BaseUseCase<CreateDropdownEntity, Body> {
  IAssetsRepository repository;
  GetCreateDropdownUsecase({required this.repository});

  @override
  Future<Either<CreateDropdownEntity, Failure>> call(Body params) async {
    return await repository.getCreateDropdown(params);
  }
}
