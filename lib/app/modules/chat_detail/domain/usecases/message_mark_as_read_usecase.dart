import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/message_mark_as_read_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/repositories/send_message_repository.dart';

class MessageMarkAsReadUseCase
    extends BaseUseCase<MessageMarkAsReadEntity, String> {
  final ISendMessageRepository sendMessageRepository;

  MessageMarkAsReadUseCase({required this.sendMessageRepository});

  @override
  Future<Either<MessageMarkAsReadEntity, Failure>> call(String params) async {
    return await sendMessageRepository.markMessageAsRead(params);
  }
}
