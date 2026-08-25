part of '../message_notification_view.dart';

class _MNDeletedMessage extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;
  const _MNDeletedMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppColorsDark.chatReciverColor
            : AppColorsLight.chatReciverColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              //
              // deleted text view
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.not_interested_rounded,
                    size: 24,
                    color: Colors.white.applyOpacity(0.8),
                  ),
                  Text(
                    "This message was deleted.",
                    style: TextStyle(
                      color: Colors.white.applyOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ).marginOnly(left: 5)
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MNMessageTimeView(
                message: message.message,
              ),
            ],
          )
        ],
      ),
    );
  }
}
