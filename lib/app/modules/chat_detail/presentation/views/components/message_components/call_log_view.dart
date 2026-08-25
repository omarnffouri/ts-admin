import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/call_log_icon.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_time_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/reply_message_view.dart';

class CallLogMessage extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  const CallLogMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
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

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CallLogIcon(message: message, width: 25, height: 25),

                  // caller or reciver name
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.callType == "video"
                              ? "Video Call"
                              : "Audio Call",
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: message.modelId.toString() == controller.myId
                                ? Get.isDarkMode
                                    ? AppColorsDark.chatSenderTextColor
                                    : AppColorsLight.chatSenderTextColor
                                : AppColorsLight.chatReciverTextColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          controller.getCallText(
                              message.modelId,
                              message.message ?? AgoraCallEvents.incommingCall,
                              message.duration),
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
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MessageTimeView(
                message: message,
              ),
            ],
          )
        ],
      ),
    );
  }
}
