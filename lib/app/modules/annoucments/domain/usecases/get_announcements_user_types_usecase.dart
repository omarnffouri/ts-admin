import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import '../../../../core/helpers/base_use_case.dart';
import '../entities/user_type_entity.dart';
import '../repositories/annoucements_repository.dart';

class GetAnnouncementUserTypeUsecase
    extends BaseUseCase<UserTypeEntity, NoParams> {
  IAnnoucementsRepository annoucementsRepository;
  GetAnnouncementUserTypeUsecase({required this.annoucementsRepository});

  @override
  Future<Either<UserTypeEntity, Failure>> call(NoParams params) async {
    return await annoucementsRepository.getAnnoucementUserTypes();
  }
}
