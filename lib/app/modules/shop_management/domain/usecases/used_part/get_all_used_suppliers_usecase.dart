import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../entities/supplier_entity.dart';
import '../../repositories/shop_repository.dart';

class GetAllUsedSuppliersUsecase
    extends BaseUseCase<List<SupplierEntity>, NoParams> {
  final IShopRepository repository;

  GetAllUsedSuppliersUsecase({required this.repository});

  @override
  Future<Either<List<SupplierEntity>, Failure>> call(NoParams params) {
    return repository.getAllUsedSuppliers();
  }
}
