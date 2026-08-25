import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/service_dropdown_entity.dart';

import '../repositories/shop_repository.dart';

class GetServiceDropdownUsecase
    extends BaseUseCase<ServiceDropdownEntity, NoParams> {
  final IShopRepository repository;

  GetServiceDropdownUsecase({required this.repository});

  @override
  Future<Either<ServiceDropdownEntity, Failure>> call(NoParams params) async {
    return await repository.getServiceDropdown();
  }
}
