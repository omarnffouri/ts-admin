// GifMessage.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/chat_icons.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/message_time_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/widgets/main_chat_container.dart';

class GifMessage extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  const GifMessage({super.key, required this.message});

  bool get isSender => message.modelId.toString() == controller.myId;

  @override
  Widget build(BuildContext context) {
    final att = (message.attachments?.isNotEmpty ?? false)
        ? message.attachments!.first
        : null;

    final url = att?.url?.trim().isNotEmpty == true
        ? att!.url!
        : (message.message ?? '');

    return MainChatContainer(
      isSender: isSender,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              memCacheWidth: 300,
              memCacheHeight: 300,
              maxHeightDiskCache: 300,
              maxWidthDiskCache: 300,
              placeholder: (context, url) => SizedBox(
                height: 150,
                child: Center(
                  child: CircularProgressIndicator(
                    color: isSender
                        ? AppColorsLight.mainColor
                        : AppColorsLight.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image),
            ),
          ),
          // Time + ticks (read receipts)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const Spacer(),
                MessageTimeView(message: message),
                const SizedBox(width: 2),
                if (isSender)
                  (message.readAt != null && message.readAt != "null")
                      ? Image.asset(
                          ChatIcons.readIcon,
                          width: 15,
                          height: 15,
                        )
                      : message.sendedNow
                          ? message.sentSuccessfully
                              ? const Stack(
                                  children: [
                                    Positioned.fill(
                                      left: 4,
                                      child: Icon(
                                        Icons.check,
                                        size: 12,
                                        color: chatReciptsColor,
                                      ),
                                    ),
                                    Icon(
                                      Icons.check,
                                      size: 12,
                                      color: chatReciptsColor,
                                    ),
                                  ],
                                )
                              : const Icon(
                                  Icons.timelapse_rounded,
                                  size: 12,
                                  color: chatReciptsColor,
                                )
                          : const Stack(
                              children: [
                                Positioned.fill(
                                  left: 4,
                                  child: Icon(
                                    Icons.check,
                                    size: 12,
                                    color: chatReciptsColor,
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  size: 12,
                                  color: chatReciptsColor,
                                ),
                              ],
                            ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
