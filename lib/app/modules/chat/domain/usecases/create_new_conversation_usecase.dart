import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/create_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/create_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class CreateNewConversationUseCase
    extends BaseUseCase<CreateConversationEntity, CreateConversationParams> {
  final IConversationRepository conversationRepository;

  CreateNewConversationUseCase({required this.conversationRepository});

  @override
  Future<Either<CreateConversationEntity, Failure>> call(
      CreateConversationParams params) async {
    return await conversationRepository.createNewConversation(params);
  }
}
