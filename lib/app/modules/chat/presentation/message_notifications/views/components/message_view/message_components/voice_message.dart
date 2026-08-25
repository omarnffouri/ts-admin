part of '../message_notification_view.dart';

class _MNVoiceMessage extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;

  const _MNVoiceMessage({required this.message});

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
                ).marginOnly(bottom: 5, right: 5, left: 5),

              _ChatAudioPlayerView(
                message: message.message!,
              ),

              if ((message.message?.message?.isNotEmpty ?? false) &&
                  message.message?.message != "null")
                Container(
                  constraints: BoxConstraints(maxWidth: Get.width * 0.55),
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
          const SizedBox(
            height: 2,
          ),
          _MNMessageTimeView(
            message: message.message,
          ),
        ],
      ),
    );
  }
}

class _ChatAudioPlayerView extends GetView<MessageNotificationsController> {
  final ConversationMessageEntity message;

  final chatAudiosManager = Get.find<ChatAudiosManager>();

  _ChatAudioPlayerView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachments![0];

    return (message.sendedNow || (attachment.file != null))
        ? SoundPlayer(
            message: message,
            myId: "",
            speed: controller.audioPlayerSpeed,
            currentAudioPlayer: controller.currentAudioPlayer,
          )
        : Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.57),
            child: FutureBuilder<String?>(
              future: chatAudiosManager.getAudioFile(
                message.attachments![0].url ?? "",
                onReceiveProgress: (received, total) {
                  attachment.isDownloading.value = true;
                  attachment.downloadProgress.value = (received / total);
                },
              ),
              builder: (context, snapshot) {
                attachment.isDownloading.value = false;

                if (snapshot.data != null) {
                  attachment.file = File(snapshot.data!);
                  return SoundPlayer(
                    message: message,
                    myId: "",
                    speed: controller.audioPlayerSpeed,
                    currentAudioPlayer: controller.currentAudioPlayer,
                  );
                }

                return Row(
                  children: [
                    //
                    //
                    // process or progress indicator
                    Obx(
                      () => SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          value: attachment.isDownloading.value
                              ? attachment.downloadProgress.value
                              : null,
                          color: AppColorsLight.chatReciverTextColor,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ).marginOnly(right: 10),

                    //
                    //
                    // player line
                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  ],
                ).marginAll(10);
              },
            ),
          );
  }
}
