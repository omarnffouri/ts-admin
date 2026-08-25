import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/supplier_entity.dart';
import '../repositories/shop_repository.dart';

class GetAllSuppliersUsecase
    extends BaseUseCase<List<SupplierEntity>, Map<String, dynamic>> {
  final IShopRepository repository;

  GetAllSuppliersUsecase({required this.repository});

  @override
  Future<Either<List<SupplierEntity>, Failure>> call(
      Map<String, dynamic> params) async {
    return await repository.getAllSuppliers();
  }
}
