import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/shop_repository.dart';

class CompleteServiceOrderUsecase extends BaseUseCase<bool, FormData> {
  final IShopRepository repository;

  CompleteServiceOrderUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(FormData params) async {
    return await repository.completeServiceOrder(params);
  }
}
