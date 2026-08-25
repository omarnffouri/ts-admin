import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../repositories/shop_repository.dart';

typedef Body = Map<String, dynamic>;

class DeleteUsedInventoryUsecase extends BaseUseCase<bool, Body> {
  final IShopRepository repository;

  DeleteUsedInventoryUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Body params) {
    return repository.deleteUsedInventory(params);
  }
}
