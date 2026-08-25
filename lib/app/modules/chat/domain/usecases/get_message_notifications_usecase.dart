import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';

class GetMessageNotificationsUseCase extends BaseUseCase<
    MessageNotificationResponseEntity, Map<String, dynamic>> {
  final IConversationRepository conversationRepository;

  GetMessageNotificationsUseCase({required this.conversationRepository});

  @override
  Future<Either<MessageNotificationResponseEntity, Failure>> call(
      Map<String, dynamic> params) async {
    return await conversationRepository.getMesssageNotifications(params);
  }
}
