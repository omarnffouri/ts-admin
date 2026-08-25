import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../entities/purchase_order_entity.dart';
import '../../repositories/shop_repository.dart';

class GetAllPurchaseOrdersUsecase
    extends BaseUseCase<List<PurchaseOrderEntity>, NoParams> {
  final IShopRepository repository;

  GetAllPurchaseOrdersUsecase({required this.repository});

  @override
  Future<Either<List<PurchaseOrderEntity>, Failure>> call(NoParams params) {
    return repository.getAllPurchaseOrders();
  }
}
