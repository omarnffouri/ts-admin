import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/assets_management/domain/entities/selected_device_entity.dart';

import '../repositories/assets_repository.dart';

class GetDeviceTypeSerialsUsecase
    extends BaseUseCase<List<SelectedDeviceEntity>, Body> {
  IAssetsRepository repository;
  GetDeviceTypeSerialsUsecase({required this.repository});

  @override
  Future<Either<List<SelectedDeviceEntity>, Failure>> call(Body params) async {
    return await repository.getDeviceSerials(params);
  }
}
