import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/edit_message_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/params/edit_text_message_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/repositories/send_message_repository.dart';

class EditTextMessageUseCase
    extends BaseUseCase<EditMessageEntity, EditTextMessageParams> {
  final ISendMessageRepository repository;

  EditTextMessageUseCase({required this.repository});

  @override
  Future<Either<EditMessageEntity, Failure>> call(
      EditTextMessageParams params) async {
    return await repository.editTextMessage(params);
  }
}
