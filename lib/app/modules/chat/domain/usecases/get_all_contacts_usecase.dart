import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class GetAllContactsUseCase extends BaseUseCase<List<ContactEntity>, NoParams> {
  final IConversationRepository conversationRepository;

  GetAllContactsUseCase({required this.conversationRepository});

  @override
  Future<Either<List<ContactEntity>, Failure>> call(NoParams params) async {
    return await conversationRepository.getAllContacts();
  }
}
