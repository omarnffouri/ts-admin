import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/service_order_entity.dart';

import '../repositories/shop_repository.dart';

class GetServiceOrderDetailsUsecase
    extends BaseUseCase<ServiceOrderEntity, Map<String, dynamic>> {
  final IShopRepository repository;

  GetServiceOrderDetailsUsecase({required this.repository});

  @override
  Future<Either<ServiceOrderEntity, Failure>> call(
      Map<String, dynamic> params) async {
    return await repository.getServiceOrderDetails(params);
  }
}
