import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/params/mute_conversation_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class MuteConversationUseCase
    extends BaseUseCase<BaseResponse<bool>, MuteConversationParams> {
  final IConversationRepository conversationRepository;

  MuteConversationUseCase({required this.conversationRepository});

  @override
  Future<Either<BaseResponse<bool>, Failure>> call(
      MuteConversationParams params) async {
    return await conversationRepository.muteConversation(params);
  }
}
