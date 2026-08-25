import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class GetGroupConversationDetailsUseCase
    extends BaseUseCase<GroupConversationEntity, int> {
  final IConversationRepository conversationRepository;

  GetGroupConversationDetailsUseCase({required this.conversationRepository});

  @override
  Future<Either<GroupConversationEntity, Failure>> call(int params) async {
    return await conversationRepository.getGroupConversationDetails(params);
  }
}
