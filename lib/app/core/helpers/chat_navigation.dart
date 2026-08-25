import 'package:get/get.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

/// The only door into [Routes.CHAT_DETAIL].
///
/// `ChatDetailBinding` registers `ChatDetailController` untagged, so at most one
/// chat detail route may be alive. Removing a live one in the same navigator
/// pass as the push (`Get.offAllNamed`) marks the key dirty, and the old route's
/// disposal then deletes the NEW controller — killing the realtime subscriptions
/// of the chat on screen. Popping first avoids it: `didPop` never dirties the key.
class ChatNavigation {
  ChatNavigation._();

  static const _pollInterval = Duration(milliseconds: 32); // ~2 frames
  static const _pollBudget = Duration(seconds: 2);
  static final _pollAttempts =
      _pollBudget.inMilliseconds ~/ _pollInterval.inMilliseconds;

  static Future<void> open(Map<String, dynamic> arguments) async {
    if (Get.isRegistered<ChatDetailController>()) {
      if (Get.find<ChatDetailController>().conversationId ==
          arguments['conversation_id']) {
        return;
      }

      Get.until((route) => route.settings.name == Routes.MAIN_SCREEN);

      for (var i = 0;
          i < _pollAttempts && Get.isRegistered<ChatDetailController>();
          i++) {
        await Future.delayed(_pollInterval);
      }

      // Key never freed. Force it: pushing onto a live key makes the binding's
      // Get.put a no-op, which renders the previous conversation.
      if (Get.isRegistered<ChatDetailController>()) {
        await Get.delete<ChatDetailController>(force: true);
      }
    }

    Get.toNamed(Routes.CHAT_DETAIL, arguments: arguments);
  }

  static Map<String, dynamic> otoArguments(ConversationEntity conversation) => {
        'type': "oto",
        'userId': conversation.user?.id,
        'userPhone': conversation.user?.phone ?? "",
        'userImage': conversation.user?.image ?? "",
        'userName': conversation.user?.name ?? "",
        'modelType': conversation.user?.modelType ?? "",
        'chatable': conversation.chatAble,
        'conversation_id': conversation.id,
        'messages': null,
        'groupId': null,
      };
}
