import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class GetGroupContactsUseCase
    extends BaseUseCase<GroupContactsEntity, NoParams> {
  final IConversationRepository conversationRepository;

  GetGroupContactsUseCase({required this.conversationRepository});

  @override
  Future<Either<GroupContactsEntity, Failure>> call(NoParams params) async {
    return await conversationRepository.getGroupContacts();
  }
}
