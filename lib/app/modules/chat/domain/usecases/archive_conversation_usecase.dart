import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/archive_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/archive_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class ArchiveConversationUseCase
    extends BaseUseCase<ArchiveConversationEntity, ArchiveConversationParams> {
  final IConversationRepository conversationRepository;

  ArchiveConversationUseCase({required this.conversationRepository});

  @override
  Future<Either<ArchiveConversationEntity, Failure>> call(
      ArchiveConversationParams params) async {
    return await conversationRepository.archiveConversation(params);
  }
}
