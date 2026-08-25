import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/params/update_participant_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class UpdateParticipantUsecase
    extends BaseUseCase<BaseResponse<bool>, UpdateParticipantParams> {
  final IConversationRepository conversationRepository;

  UpdateParticipantUsecase({required this.conversationRepository});
  @override
  Future<Either<BaseResponse<bool>, Failure>> call(
      UpdateParticipantParams params) async {
    return await conversationRepository.updateParticipant(params);
  }
}
