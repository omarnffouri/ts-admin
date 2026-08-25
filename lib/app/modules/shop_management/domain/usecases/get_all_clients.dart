import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/client_entity.dart';
import '../repositories/shop_repository.dart';

class GetAllClientsUsecase
    extends BaseUseCase<List<ClientEntity>, Map<String, dynamic>> {
  final IShopRepository repository;

  GetAllClientsUsecase({required this.repository});

  @override
  Future<Either<List<ClientEntity>, Failure>> call(
      Map<String, dynamic> params) async {
    return await repository.getAllClients();
  }
}
