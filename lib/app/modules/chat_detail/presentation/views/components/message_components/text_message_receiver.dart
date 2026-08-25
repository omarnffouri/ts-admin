import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/read_more_text.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_time_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/reply_message_view.dart';

class TextMessageReceiver extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;

  const TextMessageReceiver({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColorsDark.chatReciverColor
              : AppColorsLight.chatReciverColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.type == "group")
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
                    isSenderView: false,
                  ).marginOnly(bottom: 5),
                ),

              // building message text
              Container(
                constraints: BoxConstraints(minWidth: Get.width * 0.10),
                child: ReadMoreText(
                  message.message ?? "",
                  trimLines: 10, // Number of lines to initially display
                  colorClickableText: Colors.blue, // Customize link color
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '... Read more',
                  trimExpandedText: ' Read less',
                  style: const TextStyle(
                    color: AppColorsLight.chatReciverTextColor,
                    fontSize: 17,
                  ),
                  mention: message.mentions,
                  messageSenderId: message.modelId ?? 0,
                ),
              )
            ],
          ),
          MessageTimeView(
            message: message,
          )
        ],
      ),
    );
  }
}
