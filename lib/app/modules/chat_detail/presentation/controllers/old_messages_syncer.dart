import 'package:ts_admin/app/modules/chat_detail/data/repositories/messages_db_manager.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/get_previous_messages_params.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/get_previous_messages_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class OldMessagesSyncer {
  final _getPreviousMessagesUseCase = sl<GetPreviousMessagesUseCase>();
  final _messagesDatabase = sl<MessagesDatabase>();
  final int _conversationId;

  bool _disposeSyncing = false;

  OldMessagesSyncer(this._conversationId);

  Future<void> syncMessages(
      {int? lastMessageId,
      List<ConversationMessageEntity>? messages,
      int recurringCount = 1}) async {
    //
    // if recurring count exceds the limit then return
    if (recurringCount > 5) {
      return;
    }

    //
    //
    _disposeSyncing = false;
    if (messages != null && messages.isNotEmpty) {
      final lastMessage = messages.last;

      //
      // checking last exist must be before inserting new messages into DB
      final lastExistInDB =
          await _messagesDatabase.getMessage(lastMessage.id) != null;

      await _messagesDatabase.insertMessages(messages);

      if (_disposeSyncing) return;

      if (lastExistInDB) {
        await _syncOldMessages(
          await _messagesDatabase.getMessageId(
            _conversationId,
            MessageSort.oldest,
          ),
        );
      } else {
        await syncMessages(
            lastMessageId: lastMessage.id, recurringCount: recurringCount + 1);
      }
    } else if (lastMessageId != null) {
      if (_disposeSyncing) return;

      final oldMessages = await _getOldMessagesFromApi(lastMessageId);

      if (oldMessages.isNotEmpty) {
        //
        // checking last exist must be before inserting new messages into DB
        final lastExistInDB =
            await _messagesDatabase.getMessage(oldMessages.last.id) != null;

        await _messagesDatabase.insertMessages(oldMessages);

        if (_disposeSyncing) return;

        if (lastExistInDB) {
          await _syncOldMessages(
            await _messagesDatabase.getMessageId(
              _conversationId,
              MessageSort.oldest,
            ),
          );
        } else {
          await syncMessages(
              lastMessageId: oldMessages.last.id,
              recurringCount: recurringCount + 1);
        }
      }
    } else {
      await _syncOldMessages(
        await _messagesDatabase.getMessageId(
          _conversationId,
          MessageSort.oldest,
        ),
      );
    }
  }

  /// this function will keep syncing the old message from lastMessageId backward
  /// and call it self recursively in order to keep syncing untill all messages synced.
  Future<void> _syncOldMessages(int? lastMessageId) async {
    if (lastMessageId == null) return;

    if (_disposeSyncing) return;

    try {
      bool hasMoreMessages = true;
      int? currentLastMessageId = lastMessageId;
      int requestCount = 1;

      while (hasMoreMessages && (!_disposeSyncing) && requestCount <= 5) {
        final oldMessages = await _getOldMessagesFromApi(currentLastMessageId);
        if (oldMessages.isNotEmpty) {
          await _messagesDatabase.insertMessages(oldMessages);
          currentLastMessageId = oldMessages.last.id;
          requestCount = requestCount + 1;
        } else {
          hasMoreMessages = false;
        }
      }
    } catch (_) {}
  }

  /// funtion will call the api to get the old messages from lastMessageId backward
  /// if lastMessageId == null or any error occures function will return empty list.
  Future<List<ConversationMessageEntity>> _getOldMessagesFromApi(
      int? lastMessageId) async {
    if (lastMessageId == null) return [];

    try {
      // calling api and getting previous messages response
      final result = await _getPreviousMessagesUseCase.call(
        GetPreviousMessagesParams(
          conversationId: _conversationId.toString(),
          lastMessageId: lastMessageId.toString(),
          perPage: 500,
        ),
      );

      return result.fold(
        (messages) => messages,
        (_) => [],
      );
    } catch (_) {}

    return [];
  }

  void dispose() {
    _disposeSyncing = true;
  }
}
