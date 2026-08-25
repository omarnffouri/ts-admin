part of '../message_notification_view.dart';

class _MNMessageTimeView extends GetView<MessageNotificationsController> {
  final ConversationMessageEntity? message;

  const _MNMessageTimeView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if ((message?.isEdited ?? false) &&
            (message?.type != MessageTypes.callLog))
          const Text(
            "Edited",
            style: TextStyle(
              color: AppColorsLight.chatReciverTimeColor,
              fontSize: 10,
            ),
          ).marginOnly(right: 5),

        //
        //
        Text(
          DateFormat('h:mm a').format(message?.createdAt ?? DateTime.now()),
          style: const TextStyle(
            color: AppColorsLight.chatReciverTimeColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
