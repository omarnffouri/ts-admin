// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';

class MessageTimeView extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;

  const MessageTimeView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if ((message.isEdited ?? false) &&
            (message.type != MessageTypes.callLog))
          Text(
            "Edited",
            style: TextStyle(
              color: message.modelId.toString() == controller.myId
                  ? Get.isDarkMode
                      ? AppColorsDark.chatSenderTimeColor
                      : AppColorsLight.chatSenderTimeColor
                  : AppColorsLight.chatReciverTimeColor,
              fontSize: 10,
            ),
          ).marginOnly(right: 5),

        //
        //
        Text(
          DateFormat('h:mm a').format(message.createdAt ?? DateTime.now()),
          style: TextStyle(
            color: message.modelId.toString() == controller.myId
                ? Get.isDarkMode
                    ? AppColorsDark.chatSenderTimeColor
                    : AppColorsLight.chatSenderTimeColor
                : AppColorsLight.chatReciverTimeColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
