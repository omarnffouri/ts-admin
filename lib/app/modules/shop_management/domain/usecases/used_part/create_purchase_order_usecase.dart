import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../repositories/shop_repository.dart';

typedef Body = Map<String, dynamic>;

class CreatePurchaseOrderUsecase extends BaseUseCase<bool, Body> {
  final IShopRepository repository;

  CreatePurchaseOrderUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Body params) {
    return repository.createPurchaseOrder(params);
  }
}
