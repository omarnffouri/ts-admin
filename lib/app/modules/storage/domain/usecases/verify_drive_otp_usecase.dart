import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class VerifyDriveOtpUsecase extends BaseUseCase<bool, int> {
  final IStorageRespository respository;

  VerifyDriveOtpUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(int params) async {
    return await respository.verifyOtp(params);
  }
}
