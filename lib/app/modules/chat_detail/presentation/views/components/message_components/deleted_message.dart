import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_time_view.dart';

import '../../../../domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DeletedMessage extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  const DeletedMessage({super.key, required this.message});

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
                    color: AppColorsLight.chatReciverNameColor,
                    fontSize: 12,
                  ),
                ).marginOnly(bottom: 2),

              //
              //
              // deleted text view
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.not_interested_rounded,
                    size: 24,
                    color: message.modelId.toString() != controller.myId
                        ? Colors.white.applyOpacity(0.8)
                        : Get.isDarkMode
                            ? Colors.white.applyOpacity(0.8)
                            : AppColorsLight.chatSenderTextColor
                                .applyOpacity(0.8),
                  ),
                  Text(
                    "This message was deleted.",
                    style: TextStyle(
                      color: message.modelId.toString() != controller.myId
                          ? Colors.white.applyOpacity(0.8)
                          : Get.isDarkMode
                              ? AppColorsDark.chatSenderTextColor
                                  .applyOpacity(0.8)
                              : AppColorsLight.chatSenderTextColor
                                  .applyOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ).marginOnly(left: 5)
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
              // const SizedBox(
              //   width: 2,
              // ),
              // if (message.modelId.toString() == controller.myId)
              //   (message.readAt != null && message.readAt != "null")
              //       ? Image.asset(
              //           Assets.chatIcons.readIcon.path,
              //           width: 15,
              //           height: 15,
              //         )
              //       : message.sendedNow
              //           ? message.sentSuccessfully
              //               ? MessageDeliveredReciptView(message: message)
              //               : MessagePendingReciptView(message: message)
              //           : MessageDeliveredReciptView(message: message)
            ],
          )
        ],
      ),
    );
  }
}
