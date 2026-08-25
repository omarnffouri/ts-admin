import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_audios_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_videos_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/helpers/sound/sound_player.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/read_more_text.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/message_notifications/controllers/message_notifications_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_video_player.dart';

part './message_components/deleted_message.dart';
part './message_components/message_time_view.dart';
part './message_components/image_message.dart';
part './message_components/reply_message_view.dart';
part './message_components/text_message_receiver.dart';
part './message_components/voice_message.dart';
part './message_components/video_message.dart';
part './message_components/document_message.dart';

class MessageNotificationItemView
    extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;
  final int index;

  const MessageNotificationItemView(
      {super.key, required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    return (message.message!.deletedAt != null)
        ? _MNDeletedMessage(message: message)
        : (message.message!.attachments?.isNotEmpty ?? false)
            ? ((message.message!.type == MessageTypes.image))
                ? _MNImageMessage(message: message)
                : (message.message!.type == "audio" ||
                        message.message!.type == "recorded")
                    ? _MNVoiceMessage(message: message)
                    : controller.fileExtensionHelper.isVideoFile(
                            message.message!.attachments![0].mimeType ?? "")
                        ? _MNVideoMessage(message: message)
                        : _MNDocumentMessage(message: message)
            : _MNTextMessageReceiver(message: message);
  }
}
