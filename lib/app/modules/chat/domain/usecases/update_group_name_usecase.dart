import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/update_group_name_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_group_name_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class UpdateGroupNameUseCase
    extends BaseUseCase<UpdateGroupNameEntity, UpdateGroupNameParams> {
  final IConversationRepository conversationRepository;

  UpdateGroupNameUseCase({required this.conversationRepository});

  @override
  Future<Either<UpdateGroupNameEntity, Failure>> call(
      UpdateGroupNameParams params) async {
    return await conversationRepository.updateGroupName(params);
  }
}
