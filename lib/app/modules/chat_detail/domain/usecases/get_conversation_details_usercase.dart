import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/repositories/conversation_details_repository.dart';

class GetConversationDetailsUseCase
    extends BaseUseCase<ConversationDetailsEntity, String> {
  final IConversationDetailsRepository _conversationDetailsRepository;

  GetConversationDetailsUseCase(this._conversationDetailsRepository);

  @override
  Future<Either<ConversationDetailsEntity, Failure>> call(String params) async {
    return await _conversationDetailsRepository.getConversationDetails(params);
  }
}
