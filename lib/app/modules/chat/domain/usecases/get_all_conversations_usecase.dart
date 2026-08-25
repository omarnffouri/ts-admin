import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class GetAllConversationsUseCase
    extends BaseUseCase<List<ConversationEntity>, NoParams> {
  final IConversationRepository conversationRepository;

  GetAllConversationsUseCase({required this.conversationRepository});

  @override
  Future<Either<List<ConversationEntity>, Failure>> call(
      NoParams params) async {
    return await conversationRepository.getAllConversations();
  }
}
