import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/remove_participants_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class RemoveParticipantsUseCase
    extends BaseUseCase<RemoveParticipantsEntity, int> {
  final IConversationRepository conversationRepository;

  RemoveParticipantsUseCase({required this.conversationRepository});

  @override
  Future<Either<RemoveParticipantsEntity, Failure>> call(int params) async {
    return await conversationRepository.removeParticipants(params);
  }
}
