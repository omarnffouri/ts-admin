import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/read_more_text.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/delivered_recipt.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_time_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/pending_recipt.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/reply_message_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_video_player.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

class VideoMessage extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;

  const VideoMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(1),
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
            children: [
              //
              //
              //
              // if message in group and message sender id not == my if then show sender name
              if (controller.type == "group" &&
                  message.modelId.toString() != controller.myId)
                Text(
                  message.model?.name ?? "",
                  style: const TextStyle(
                      color: AppColorsLight.chatReciverNameColor, fontSize: 12),
                ).marginOnly(bottom: 2, left: 5, top: 5),

              //
              //
              //
              // building a forwarded indicator
              if (message.forwardMessageId != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //
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

              //
              //
              //
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

              //
              //
              //
              // actual video message view
              InkWell(
                onLongPress: () {
                  controller.selectMessage(message);
                },
                onTap: () async {
                  try {
                    // if message selection enabled then make message selected
                    // else do actions as required
                    if (controller.isMessageSelectionEnabled) {
                      controller.selectMessage(message);
                      return;
                    }

                    if (message.sendedNow) {
                      if (message.attachments?.isNotEmpty ?? false) {
                        if (message.attachments![0].sendedNow &&
                            message.attachments![0].file != null) {
                          Get.to(
                            ChatVideoPlayer(
                              videoUrl: "",
                              title: "",
                              videoFile: message.attachments![0].file!,
                            ),
                          );
                        } else {
                          Get.to(
                            ChatVideoPlayer(
                              videoUrl: message.attachments![0].url ?? "",
                              title: "",
                            ),
                          );
                        }
                      }
                    } else {
                      final fileName = controller.chatVideosManager.getFileName(
                        message.attachments?[0].url ?? "",
                        withExtension: true,
                      );

                      final videoFile =
                          await controller.chatVideosManager.getFile(fileName);

                      Get.to(
                        ChatVideoPlayer(
                          videoUrl: message.attachments![0].url ?? "",
                          title: "",
                          videoFile: videoFile,
                        ),
                      );
                    }
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
                          url: message.attachments?[0].url ?? "",
                          file: message.attachments?[0].file,
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

          //
          //
          //
          // recipt view
          Container(
            margin: const EdgeInsets.only(top: 2, right: 5, bottom: 5),
            child: Row(
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
            ),
          )
        ],
      ),
    );
  }
}
