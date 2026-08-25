part of '../message_notification_view.dart';

class _MNTextMessageReceiver extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;

  const _MNTextMessageReceiver({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.all(8),
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
              // building a forwarded indicator
              if (message.message?.forwardMessageId != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //
                    // forward icon
                    Transform.flip(
                      flipX: true,
                      child: const Icon(
                        Icons.reply_rounded,
                        color: AppColorsLight.chatReciverTextColor,
                        size: 20,
                      ),
                    ),

                    //
                    // forward text
                    const Text(
                      "Forwarded",
                      style: TextStyle(
                        color: AppColorsLight.chatReciverTextColor,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),

              // building reply view
              if (message.message?.replyOn != null)
                _MNReplyMessageView(
                  message: message.message!.replyOn!,
                ).marginOnly(bottom: 5),

              // building message text
              Container(
                constraints: BoxConstraints(minWidth: Get.width * 0.10),
                child: ReadMoreText(
                  message.message?.message ?? "",
                  trimLines: 10, // Number of lines to initially display
                  colorClickableText: Colors.blue, // Customize link color
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '... Read more',
                  trimExpandedText: ' Read less',
                  style: const TextStyle(
                    color: AppColorsLight.chatReciverTextColor,
                    fontSize: 17,
                  ),
                  mention: message.message?.mentions,
                  messageSenderId: message.message?.modelId ?? 0,
                ),
              )
            ],
          ),
          _MNMessageTimeView(
            message: message.message,
          )
        ],
      ),
    );
  }
}
