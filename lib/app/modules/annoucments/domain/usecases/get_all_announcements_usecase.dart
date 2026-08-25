import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/annoucments/domain/entities/annoucement_entity.dart';

import '../repositories/annoucements_repository.dart';

class GetAllAnnouncementsUsecase
    extends BaseUseCase<List<AnnoucementEntity>, NoParams> {
  IAnnoucementsRepository annoucementsRepository;
  GetAllAnnouncementsUsecase({required this.annoucementsRepository});

  @override
  Future<Either<List<AnnoucementEntity>, Failure>> call(NoParams params) async {
    return await annoucementsRepository.getAllAnnoucements();
  }
}
