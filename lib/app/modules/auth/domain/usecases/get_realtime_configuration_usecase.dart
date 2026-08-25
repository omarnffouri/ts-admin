import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';

class GetRealtimeConfigurationUseCase
    extends BaseUseCase<BaseResponse<RealtimeConfiguration>, NoParams> {
  final IAuthRepository authRepository;

  GetRealtimeConfigurationUseCase({required this.authRepository});

  @override
  Future<Either<BaseResponse<RealtimeConfiguration>, Failure>> call(
      NoParams params) async {
    return await authRepository.getRealtimeConfiguration();
  }
}
