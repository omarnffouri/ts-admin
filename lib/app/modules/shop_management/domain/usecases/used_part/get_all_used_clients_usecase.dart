import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../../entities/client_entity.dart';
import '../../repositories/shop_repository.dart';

class GetAllUsedClientsUsecase
    extends BaseUseCase<List<ClientEntity>, NoParams> {
  final IShopRepository repository;

  GetAllUsedClientsUsecase({required this.repository});

  @override
  Future<Either<List<ClientEntity>, Failure>> call(NoParams params) {
    return repository.getAllUsedClients();
  }
}
