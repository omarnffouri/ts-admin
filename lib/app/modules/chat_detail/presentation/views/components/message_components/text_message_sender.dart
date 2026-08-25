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
import 'package:ts_admin/app/core/gen/assets.gen.dart';

class TextMessageSender extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;

  const TextMessageSender({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppColorsDark.chatSenderColor
            : AppColorsLight.chatSenderColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    isSenderView: true,
                  ).marginOnly(bottom: 5),
                ),

              Container(
                constraints: BoxConstraints(minWidth: Get.width * 0.13),
                child: ReadMoreText(
                  message.message ?? "",
                  trimLines: 10, // Number of lines to initially display
                  colorClickableText: Colors.blue, // Customize link color
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '... Read more',
                  trimExpandedText: ' Read less',
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? AppColorsDark.chatSenderTextColor
                        : AppColorsLight.chatSenderTextColor,
                    fontSize: 17,
                    fontFamily: 'Helvetica',
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
