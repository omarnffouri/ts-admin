import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';

class AudioMessageOptionsButton extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  const AudioMessageOptionsButton({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ((message.attachments?.isNotEmpty ?? false) &&
          (message.type == MessageTypes.audio ||
              message.type == MessageTypes.recorded)),
      child: PopupMenuButton<String>(
        onSelected: (item) {
          controller.shareAndExportAudioMessage(message, item);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        shadowColor: Colors.grey,
        elevation: 10,
        icon: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Get.isDarkMode ? Colors.grey : Colors.white,
          ),
          child: Icon(
            Icons.more_vert_rounded,
            size: 25,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
          ),
        ),
        itemBuilder: (BuildContext context) {
          return [
            //
            //
            // share option
            PopupMenuItem<String>(
              value: 'share',
              child: Row(
                children: [
                  const Icon(
                    Icons.share_rounded,
                    size: 20,
                  ),
                  const Text('Share').marginOnly(left: 10),
                ],
              ),
            ),

            //
            //
            // download option
            PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  const Icon(
                    Icons.download_rounded,
                    size: 20,
                  ),
                  const Text('Download').marginOnly(left: 10),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
