import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/read_more_text.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/delivered_recipt.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_time_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/pending_recipt.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/reply_message_view.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../../../../domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DocumentMessage extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  const DocumentMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachments![0];

    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: message.modelId.toString() == controller.myId
            ? Get.isDarkMode
                ? AppColorsDark.chatSenderColor
                : AppColorsLight.chatSenderColor
            : Get.isDarkMode
                ? AppColorsDark.chatReciverColor
                : AppColorsLight.chatReciverColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
              message.modelId.toString() == controller.myId ? 0 : 10),
          topLeft: Radius.circular(
              message.modelId.toString() == controller.myId ? 10 : 0),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.type == "group" &&
                  message.modelId.toString() != controller.myId)
                Text(
                  message.model?.name ?? "",
                  style: const TextStyle(
                      color: AppColorsLight.chatReciverNameColor, fontSize: 12),
                ).marginOnly(bottom: 2),

              // building a forwarded indicator
              if (message.forwardMessageId != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //
                    // forward icon
                    Transform.flip(
                      flipX: true,
                      child: Icon(
                        Icons.reply_rounded,
                        color: message.modelId.toString() == controller.myId
                            ? Get.isDarkMode
                                ? AppColorsDark.chatSenderTextColor
                                : AppColorsLight.chatSenderTextColor
                            : AppColorsLight.chatReciverTextColor,
                        size: 20,
                      ),
                    ),

                    //
                    // forward text
                    Text(
                      "Forwarded",
                      style: TextStyle(
                        color: message.modelId.toString() == controller.myId
                            ? Get.isDarkMode
                                ? AppColorsDark.chatSenderTextColor
                                : AppColorsLight.chatSenderTextColor
                            : AppColorsLight.chatReciverTextColor,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),

              // building reply view
              if (message.replyOn != null)
                InkWell(
                  onTap: () {
                    controller.scrollToRepliedMessage(message.replyOn?.id);
                  },
                  child: ReplyMessageView(
                    message: message.replyOn!,
                    isSenderView: message.modelId.toString() == controller.myId,
                  ).marginOnly(bottom: 5, right: 5, left: 5),
                ),

              GestureDetector(
                onLongPress: () {
                  controller.selectMessage(message);
                },
                onTap: () async {
                  // if message selection enabled then make message selected
                  // else do actions as required
                  if (controller.isMessageSelectionEnabled) {
                    controller.selectMessage(message);
                    return;
                  }
                  try {
                    if (message.sendedNow) {
                      if (message.attachments?.isNotEmpty ?? false) {
                        if (attachment.sendedNow && attachment.file != null) {
                          await FileOpener.openFile(
                              message.attachments![0].file!.path);
                        }
                      }
                    } else {
                      final filePath =
                          await controller.chatDocumentsManager.getDocumentFile(
                        message.attachments?[0].url ?? "",
                        onReceiveProgress: (received, total) {
                          attachment.isDownloading.value = true;
                          attachment.downloadProgress.value =
                              (received / total);
                        },
                      );

                      attachment.isDownloading.value = false;
                      if (filePath != null) {
                        attachment.file = File(filePath);
                        await FileOpener.openFile(filePath);
                      }
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
                            color: message.modelId.toString() == controller.myId
                                ? AppColorsLight.chatSenderTextColor
                                    .applyOpacity(0.3)
                                : AppColorsLight.chatReciverTextColor
                                    .applyOpacity(0.3),
                          ),
                          child: Image.asset(
                            controller.chatDocumentsManager.getFileIcon(
                              controller.chatDocumentsManager.getFileType(
                                message.attachments![0].url ?? "",
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
                                !message.sendedNow ||
                                (attachment.file == null)),
                            child: FutureBuilder<bool>(
                              future: controller.chatDocumentsManager.fileExist(
                                controller.fileExtensionHelper.getFileName(
                                  message.attachments?[0].url ?? "",
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
                                          message.attachments?[0].url ?? "",
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
                                        child: Icon(
                                          Icons.download,
                                          size: 25,
                                          color: message.modelId.toString() ==
                                                  controller.myId
                                              ? Get.isDarkMode
                                                  ? AppColorsDark
                                                      .chatSenderTextColor
                                                  : AppColorsLight
                                                      .chatSenderTextColor
                                              : AppColorsLight
                                                  .chatReciverTextColor,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: message.modelId.toString() ==
                                              controller.myId
                                          ? AppColorsLight.chatSenderTextColor
                                          : AppColorsLight.chatReciverTextColor,
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
                                  color: message.modelId.toString() ==
                                          controller.myId
                                      ? Get.isDarkMode
                                          ? AppColorsDark.chatSenderTextColor
                                          : AppColorsLight.chatSenderTextColor
                                      : AppColorsLight.chatReciverTextColor,
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
                          message.attachments![0].url ?? "",
                          withExtension: true,
                        ),
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 14,
                          color: message.modelId.toString() == controller.myId
                              ? Get.isDarkMode
                                  ? AppColorsDark.chatSenderTextColor
                                  : AppColorsLight.chatSenderTextColor
                              : AppColorsLight.chatReciverTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if ((message.message?.isNotEmpty ?? false) &&
                  message.message != "null")
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(8),
                  child: ReadMoreText(
                    message.message ?? "",
                    trimLines: 10, // Number of lines to initially display
                    colorClickableText: Colors.blue, // Customize link color
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '... Read more',
                    trimExpandedText: ' Read less',
                    style: TextStyle(
                      color: message.modelId.toString() == controller.myId
                          ? Get.isDarkMode
                              ? AppColorsDark.chatSenderTextColor
                              : AppColorsLight.chatSenderTextColor
                          : AppColorsLight.chatReciverTextColor,
                      fontSize: 17,
                    ),
                    mention: message.mentions,
                    messageSenderId: message.modelId ?? 0,
                  ),
                ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MessageTimeView(
                message: message,
              ),
              const SizedBox(
                width: 2,
              ),
              if (message.modelId.toString() == controller.myId)
                (message.readAt != null && message.readAt != "null")
                    ? Image.asset(
                        Assets.chatIcons.readIcon.path,
                        width: 15,
                        height: 15,
                      )
                    : message.sendedNow
                        ? message.sentSuccessfully
                            ? MessageDeliveredReciptView(message: message)
                            : MessagePendingReciptView(message: message)
                        : MessageDeliveredReciptView(message: message)
            ],
          )
        ],
      ),
    );
  }
}
