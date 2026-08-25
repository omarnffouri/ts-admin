part of '../message_notification_view.dart';

class _MNVideoMessage extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;

  const _MNVideoMessage({required this.message});

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
            children: [
              //
              //
              //
              // building a forwarded indicator
              if (message.message?.forwardMessageId != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //
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

              //
              //
              //
              // building reply view
              if (message.message?.replyOn != null)
                _MNReplyMessageView(
                  message: message.message!.replyOn!,
                ).marginOnly(bottom: 5, right: 5, left: 5),
              //
              //
              //
              // actual video message view
              InkWell(
                onTap: () async {
                  try {
                    final chatVideosManager = ChatVideosManager();
                    final fileName = chatVideosManager.getFileName(
                      message.message?.attachments?[0].url ?? "",
                      withExtension: true,
                    );

                    final videoFile = await chatVideosManager.getFile(fileName);

                    Get.to(
                      ChatVideoPlayer(
                        videoUrl: message.message?.attachments![0].url ?? "",
                        title: "",
                        videoFile: videoFile,
                      ),
                    );
                  } catch (_) {}
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      //
                      //
                      //
                      // video thumbnail builder
                      FutureBuilder<Uint8List?>(
                        future: controller.chatVideosThumbnailManager
                            .getVideoThumbnail(
                          url: message.message?.attachments?[0].url ?? "",
                          file: message.message?.attachments?[0].file,
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<Uint8List?> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const Icon(
                                Icons.video_file,
                                size: 200,
                                color: AppColorsLight.mainColor,
                              );
                            }
                          } else if (snapshot.hasError) {
                            return const Icon(
                              Icons.video_file,
                              size: 200,
                              color: AppColorsLight.mainColor,
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(85),
                              child: const SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      //
                      //
                      //
                      ///  play button
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //
              //
              //
              // text message
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

          //
          //
          //
          // recipt view
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
