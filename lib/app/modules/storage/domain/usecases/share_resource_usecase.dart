import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/storage/domain/params/share_resource_params.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';

class ShareResourceUsecase extends BaseUseCase<bool, ShareResourceParams> {
  final IStorageRespository respository;

  ShareResourceUsecase({required this.respository});

  @override
  Future<Either<bool, Failure>> call(ShareResourceParams params) async {
    return await respository.shareResource(params);
  }
}
