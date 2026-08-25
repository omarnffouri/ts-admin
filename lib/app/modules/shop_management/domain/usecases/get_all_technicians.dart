import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';

import '../repositories/shop_repository.dart';

class GetAllTechniciansUsecase
    extends BaseUseCase<List<TechnicianEntity>, NoParams> {
  final IShopRepository repository;

  GetAllTechniciansUsecase({required this.repository});

  @override
  Future<Either<List<TechnicianEntity>, Failure>> call(NoParams params) async {
    return await repository.getAllTechnicians();
  }
}
