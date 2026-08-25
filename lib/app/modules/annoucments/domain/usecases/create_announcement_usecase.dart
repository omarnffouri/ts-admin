import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';

import '../repositories/annoucements_repository.dart';

class CreateAnnouncementUsecase extends BaseUseCase<bool, FormData> {
  final IAnnoucementsRepository annoucementsRepository;

  CreateAnnouncementUsecase({required this.annoucementsRepository});

  @override
  Future<Either<bool, Failure>> call(FormData params) async {
    return await annoucementsRepository.createAnnoucement(params);
  }
}
