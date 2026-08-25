import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/update_group_logo_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_logo_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class UpdateGroupLogoUseCase
    extends BaseUseCase<UpdateGroupLogoEntity, UpdateGroupLogoParams> {
  final IConversationRepository conversationRepository;

  UpdateGroupLogoUseCase({required this.conversationRepository});

  @override
  Future<Either<UpdateGroupLogoEntity, Failure>> call(
      UpdateGroupLogoParams params) async {
    return await conversationRepository.updateGroupLogo(params);
  }
}
