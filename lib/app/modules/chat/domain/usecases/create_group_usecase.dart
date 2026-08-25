import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_group_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_group_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class CreateGroupUseCase
    extends BaseUseCase<CreateGroupEntity, CreateGroupParams> {
  final IConversationRepository conversationRepository;

  CreateGroupUseCase({required this.conversationRepository});

  @override
  Future<Either<CreateGroupEntity, Failure>> call(
      CreateGroupParams params) async {
    return await conversationRepository.createGroup(params);
  }
}
