import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/add_participants_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/params/add_participants_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class AddParticipantsUseCase
    extends BaseUseCase<AddParticipantsEntity, AddParticipantsParams> {
  final IConversationRepository conversationRepository;

  AddParticipantsUseCase({required this.conversationRepository});

  @override
  Future<Either<AddParticipantsEntity, Failure>> call(
      AddParticipantsParams params) async {
    return await conversationRepository.addParticipants(params);
  }
}
