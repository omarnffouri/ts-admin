import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/assets_repository.dart';

typedef Body = Map<String, dynamic>;

class UploadPicturesUsecase extends BaseUseCase<bool, FormData> {
  IAssetsRepository repository;
  UploadPicturesUsecase({required this.repository});

  @override
  Future<Either<bool, Failure>> call(FormData params) async {
    return await repository.uploadPictures(params);
  }
}
