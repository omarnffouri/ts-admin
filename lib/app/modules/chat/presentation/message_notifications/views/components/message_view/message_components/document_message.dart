part of '../message_notification_view.dart';

class _MNDocumentMessage extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;
  const _MNDocumentMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final attachment = message.message!.attachments![0];

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

              GestureDetector(
                onTap: () async {
                  try {
                    final filePath =
                        await controller.chatDocumentsManager.getDocumentFile(
                      message.message?.attachments?[0].url ?? "",
                      onReceiveProgress: (received, total) {
                        attachment.isDownloading.value = true;
                        attachment.downloadProgress.value = (received / total);
                      },
                    );

                    attachment.isDownloading.value = false;
                    if (filePath != null) {
                      attachment.file = File(filePath);
                      await FileOpener.openFile(filePath);
                    }
                  } catch (_) {}
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //
                    //
                    // progress and download icon
                    Stack(
                      children: [
                        //
                        //
                        // file icon
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorsLight.chatReciverTextColor
                                .applyOpacity(0.3),
                          ),
                          child: Image.asset(
                            controller.chatDocumentsManager.getFileIcon(
                              controller.chatDocumentsManager.getFileType(
                                message.message!.attachments![0].url ?? "",
                              ),
                            ),
                            width: 25,
                            height: 25,
                          ),
                        ),

                        //
                        //
                        //
                        Obx(
                          () => Visibility(
                            visible: ((!attachment.isDownloading.value) ||
                                (attachment.file == null)),
                            child: FutureBuilder<bool>(
                              future: controller.chatDocumentsManager.fileExist(
                                controller.fileExtensionHelper.getFileName(
                                  message.message?.attachments?[0].url ?? "",
                                  withExtension: true,
                                ),
                              ),
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.connectionState !=
                                        ConnectionState.waiting &&
                                    snapshot.hasData) {
                                  return Visibility(
                                    visible: !(snapshot.data ?? false),
                                    child: GestureDetector(
                                      onTap: () async {
                                        //
                                        // getting doc file
                                        final filePath = await controller
                                            .chatDocumentsManager
                                            .getDocumentFile(
                                          message.message?.attachments?[0]
                                                  .url ??
                                              "",
                                          onReceiveProgress: (received, total) {
                                            attachment.isDownloading.value =
                                                true;
                                            attachment.downloadProgress.value =
                                                (received / total);
                                          },
                                        );

                                        attachment.isDownloading.value = false;
                                        if (filePath != null) {
                                          attachment.file = File(filePath);
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black38,
                                        ),
                                        child: const Icon(
                                          Icons.download,
                                          size: 25,
                                          color: AppColorsLight
                                              .chatReciverTextColor,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color:
                                          AppColorsLight.chatReciverTextColor,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        //
                        //
                        // download progress indicator
                        Obx(
                          () => attachment.isDownloading.value
                              ? CircularProgressIndicator(
                                  value: attachment.downloadProgress.value,
                                  strokeCap: StrokeCap.round,
                                  color: AppColorsLight.chatReciverTextColor,
                                )
                              : const SizedBox(),
                        )
                      ],
                    ),

                    //
                    //
                    // file name
                    Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.40),
                      child: Text(
                        controller.fileExtensionHelper.getFileName(
                          message.message!.attachments![0].url ?? "",
                          withExtension: true,
                        ),
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColorsLight.chatReciverTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
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
          _MNMessageTimeView(
            message: message.message,
          ),
        ],
      ),
    );
  }
}
