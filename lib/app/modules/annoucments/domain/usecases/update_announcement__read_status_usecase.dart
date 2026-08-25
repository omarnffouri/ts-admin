import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';
import '../repositories/annoucements_repository.dart';

class UpdateAnnouncementReadStatusUsecase extends BaseUseCase<bool, int> {
  IAnnoucementsRepository annoucementsRepository;
  UpdateAnnouncementReadStatusUsecase({required this.annoucementsRepository});

  @override
  Future<Either<bool, Failure>> call(int params) async {
    return await annoucementsRepository.updateAnnoucementReadStatus(params);
  }
}
