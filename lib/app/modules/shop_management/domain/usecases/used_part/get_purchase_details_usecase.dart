import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../entities/purchase_order_entity.dart';
import '../../repositories/shop_repository.dart';

typedef Body = Map<String, dynamic>;

class GetPurchaseDetailsUsecase extends BaseUseCase<PurchaseOrderEntity, Body> {
  final IShopRepository repository;

  GetPurchaseDetailsUsecase({required this.repository});

  @override
  Future<Either<PurchaseOrderEntity, Failure>> call(Body params) {
    return repository.getPurchaseDetails(params);
  }
}
