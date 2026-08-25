import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/service_order_entity.dart';
import '../repositories/shop_repository.dart';

class GetAllServiceOrdersUsecase
    extends BaseUseCase<List<ServiceOrderEntity>, NoParams> {
  final IShopRepository repository;

  GetAllServiceOrdersUsecase({required this.repository});

  @override
  Future<Either<List<ServiceOrderEntity>, Failure>> call(
      NoParams params) async {
    return await repository.getAllServiceOrders();
  }
}
