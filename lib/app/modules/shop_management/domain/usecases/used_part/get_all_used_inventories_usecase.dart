import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../entities/shop_inventory_entity.dart';
import '../../repositories/shop_repository.dart';

class GetAllUsedInventoriesUsecase
    extends BaseUseCase<List<ShopInventoryEntity>, NoParams> {
  final IShopRepository repository;

  GetAllUsedInventoriesUsecase({required this.repository});

  @override
  Future<Either<List<ShopInventoryEntity>, Failure>> call(NoParams params) {
    return repository.getAllUsedInventories();
  }
}
