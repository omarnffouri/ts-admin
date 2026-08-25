part of '../message_notification_view.dart';

class _MNImageMessage extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;

  const _MNImageMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.all(1),
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
                ).marginOnly(bottom: 5, right: 5, left: 5),

              SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: CachedNetworkImageProvider(
                      message.message?.attachments?.firstOrNull?.thumbUrl ??
                          message.message?.attachments?.firstOrNull?.url ??
                          "",
                    ),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image,
                      size: 200,
                    ),
                  ),
                ),
              ),

              if ((message.message?.message?.isNotEmpty ?? false) &&
                  message.message?.message != "null")
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(8),
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
                ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 2, right: 5, bottom: 5),
            child: _MNMessageTimeView(
              message: message.message,
            ),
          )
        ],
      ),
    );
  }
}
