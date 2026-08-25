// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';

class MessagePendingReciptView extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;

  const MessagePendingReciptView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.timelapse_rounded,
      size: 12,
      color: Get.isDarkMode
          ? AppColorsDark.chatSenderTimeColor
          : AppColorsLight.chatReciptsColor,
    );
  }
}
