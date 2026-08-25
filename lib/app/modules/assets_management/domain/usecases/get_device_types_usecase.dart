import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../entities/device_type_entity.dart';
import '../repositories/assets_repository.dart';

class GetDeviceTypesUsecase
    extends BaseUseCase<List<DeviceTypeEntity>, NoParams> {
  IAssetsRepository repository;
  GetDeviceTypesUsecase({required this.repository});

  @override
  Future<Either<List<DeviceTypeEntity>, Failure>> call(NoParams params) async {
    return await repository.getDeviceTypes();
  }
}
