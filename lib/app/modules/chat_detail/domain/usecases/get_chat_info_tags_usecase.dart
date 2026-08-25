import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/chat_info_tags_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/repositories/conversation_details_repository.dart';

class GetChatInfoTagsUsecase extends BaseUseCase<ChatInfoTagsEntity, String> {
  final IConversationDetailsRepository repository;

  GetChatInfoTagsUsecase({required this.repository});

  @override
  Future<Either<ChatInfoTagsEntity, Failure>> call(String params) async {
    return await repository.getChatInfoTags(params);
  }
}
