import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/domain/repositories/settings_repository.dart';

class UpdateOtpUsecase extends BaseUseCase<bool, Map<String, dynamic>> {
  final ISettingsRepository repository;

  UpdateOtpUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(Map<String, dynamic> params) async {
    return repository.updateOtp(params);
  }
}
