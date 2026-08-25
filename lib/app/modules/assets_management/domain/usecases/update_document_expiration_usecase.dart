import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class UpdateDocumentExpirationUsecase extends BaseUseCase<bool, Body> {
  IAssetsRepository repository;
  UpdateDocumentExpirationUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Body params) async {
    return await repository.updateDocumentExpiration(params);
  }
}
