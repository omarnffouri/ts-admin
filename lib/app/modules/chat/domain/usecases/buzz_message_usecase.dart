import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/params/buzz_message_params.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class BuzzMessageUsecase
    extends BaseUseCase<BaseResponse<bool>, BuzzMessageParams> {
  final IConversationRepository conversationRepository;

  BuzzMessageUsecase({required this.conversationRepository});

  @override
  Future<Either<BaseResponse<bool>, Failure>> call(
      BuzzMessageParams params) async {
    return await conversationRepository.buzzMessage(params);
  }
}
