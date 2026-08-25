import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/service_order_entity.dart';

import '../repositories/shop_repository.dart';

class GetCustomerDetailsUsecase
    extends BaseUseCase<CustomerEntity, Map<String, dynamic>> {
  final IShopRepository repository;

  GetCustomerDetailsUsecase({required this.repository});

  @override
  Future<Either<CustomerEntity, Failure>> call(
      Map<String, dynamic> params) async {
    return await repository.getCustomerDetails(params);
  }
}
