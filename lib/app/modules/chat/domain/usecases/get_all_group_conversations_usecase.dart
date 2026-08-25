import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class GetAllGroupConversationsUseCase
    extends BaseUseCase<List<GroupConversationEntity>, NoParams> {
  final IConversationRepository conversationRepository;

  GetAllGroupConversationsUseCase({required this.conversationRepository});

  @override
  Future<Either<List<GroupConversationEntity>, Failure>> call(
      NoParams params) async {
    return await conversationRepository.getAllGroupConversations();
  }
}
