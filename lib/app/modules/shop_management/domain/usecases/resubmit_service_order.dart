import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/shop_repository.dart';

class ResubmitServiceOrderUsecase
    extends BaseUseCase<bool, Map<String, dynamic>> {
  final IShopRepository repository;

  ResubmitServiceOrderUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Map<String, dynamic> params) async {
    return await repository.resubmitServiceOrder(params);
  }
}
