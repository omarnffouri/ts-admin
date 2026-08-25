import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/service_dropdown_entity.dart';

import '../repositories/shop_repository.dart';

class GetCarrierVehiclesUsecase
    extends BaseUseCase<List<ItemEntity>, Map<String, dynamic>> {
  final IShopRepository repository;

  GetCarrierVehiclesUsecase({required this.repository});

  @override
  Future<Either<List<ItemEntity>, Failure>> call(
      Map<String, dynamic> params) async {
    return await repository.getCarrierVehicles(params);
  }
}
