import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_audios_manager.dart';
import 'package:ts_admin/app/core/helpers/sound/sound_player.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/read_more_text.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/delivered_recipt.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_time_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/pending_recipt.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/reply_message_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/widgets/main_chat_container.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

class VoiceMessage extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;

  const VoiceMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MainChatContainer(
      isSender: message.modelId.toString() == controller.myId,
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
                ).marginOnly(
                  bottom: 2,
                ),

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

              // SoundPlayer(
              //   message: message,
              //   myId: controller.myId,
              // ),

              ChatAudioPlayerView(
                message: message,
                myId: controller.myId,
              ),

              if ((message.message?.isNotEmpty ?? false) &&
                  message.message != "null")
                Container(
                  constraints: BoxConstraints(maxWidth: Get.width * 0.55),
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
          const SizedBox(
            height: 2,
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

class ChatAudioPlayerView extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  final String myId;

  final chatAudiosManager = Get.find<ChatAudiosManager>();

  ChatAudioPlayerView({super.key, required this.message, required this.myId});

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachments![0];

    return (message.sendedNow || (attachment.file != null))
        ? SoundPlayer(
            message: message,
            myId: controller.myId,
            speed: controller.audioPlayerSpeed,
            currentAudioPlayer: controller.currentAudioPlayer,
          )
        : FutureBuilder<String?>(
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
                  myId: controller.myId,
                  speed: controller.audioPlayerSpeed,
                  currentAudioPlayer: controller.currentAudioPlayer,
                );
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
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
                        color: message.modelId.toString() == controller.myId
                            ? Get.isDarkMode
                                ? AppColorsDark.chatSenderTextColor
                                : AppColorsLight.chatSenderTextColor
                            : AppColorsLight.chatReciverTextColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ).marginOnly(right: 10),

                  //
                  //
                  // player line
                  Container(
                    width: Get.width * 0.45,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              ).marginAll(10);
            },
          );
  }
}
