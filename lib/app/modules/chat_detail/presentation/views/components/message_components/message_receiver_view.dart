import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/swiper.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/buzz_components/conversation_buzz_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/audio_message_options_button.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/call_log_view.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/deleted_message.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/document_message.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/gif_message.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/image_message.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/location_message.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/text_message_receiver.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/video_message.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/message_components/voice_message.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/reaction_components/widgets/flat_reactions_view.dart';

class MessageReciverView extends GetView<ChatDetailController> {
  final ConversationMessageEntity message;
  final int index;

  const MessageReciverView(
      {super.key, required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    controller.markMessageAsRead(message);

    return GestureDetector(
      onLongPress: () {
        if (message.type != MessageTypes.callLog) {
          controller.selectMessage(message);
        }
      },
      onTap: () {
        if ((message.type != MessageTypes.callLog) &&
            controller.isMessageSelectionEnabled) {
          controller.selectMessage(message);
        }
      },
      child: Swiper(
        iconColor: AppColorsLight.mainColor,
        onRightSwipe: message.deletedAt != null
            ? null
            : (details) {
                controller.selectedMessageForReply.value =
                    controller.messages[index];
              },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            //
            // message view
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                //
                // user image
                Container(
                  margin: const EdgeInsets.only(top: 5, right: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: CachedNetworkImageProvider(
                        message.model?.image ??
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                      ),
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Image(
                        image: CachedNetworkImageProvider(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                        ),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),

                //
                //
                //  message view
                Builder(
                  builder: (context) {
                    RenderBox? box;
                    try {
                      box = context.findRenderObject() as RenderBox?;
                    } catch (_) {}
                    double? widgetWidth;
                    try {
                      widgetWidth = box?.size.width;
                    } catch (_) {}

                    return Stack(
                      children: [
                        //
                        //
                        // actual message content view
                        Container(
                          margin: EdgeInsets.only(
                            bottom: (message.reactions?.isNotEmpty ?? false)
                                ? 22
                                : 0,
                          ),
                          child: (message.deletedAt != null)
                              ? DeletedMessage(message: message)
                              : (message.type == MessageTypes.location)
                                  ? LocationMessage(
                                      message: message,
                                    )
                                  : (message.type == MessageTypes.gif)
                                      ? GifMessage(
                                          message: message,
                                        )
                                      : (message.attachments?.isNotEmpty ??
                                              false)
                                          ? ((message.type ==
                                                  MessageTypes.image))
                                              ? ImageMessage(message: message)
                                              : (message.type == "audio" ||
                                                      message.type ==
                                                          "recorded")
                                                  ? VoiceMessage(
                                                      message: message)
                                                  : controller
                                                          .fileExtensionHelper
                                                          .isVideoFile(message
                                                                  .attachments![
                                                                      0]
                                                                  .mimeType ??
                                                              "")
                                                      ? VideoMessage(
                                                          message: message)
                                                      : DocumentMessage(
                                                          message: message)
                                          : message.type == MessageTypes.callLog
                                              ? CallLogMessage(message: message)
                                              : TextMessageReceiver(
                                                  message: message),
                        ),

                        //
                        //
                        // message reactions
                        Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              controller
                                  .showMessageReactionBottomSheet(message);
                            },
                            child: FlatReactionsView(
                              size: 20,
                              maxWidth: ((widgetWidth ?? 0) < 50)
                                  ? 50
                                  : widgetWidth ?? 50,
                              reactions: message.reactions
                                      ?.map((e) => e.reaction!)
                                      .toList() ??
                                  [],
                              backgroundColor: Get.isDarkMode
                                  ? AppColorsDark.reactionsReceiverColor
                                  : AppColorsLight.reactionsReceiverColor,
                              borderColor: Get.isDarkMode
                                  ? const Color.fromARGB(255, 172, 160, 160)
                                  : AppColorsLight.scaffoldBackroundColor,
                              emojiCounterTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),

            //
            //
            // download audio button
            AudioMessageOptionsButton(message: message),

            //
            //
            const Spacer(),

            //
            //
            // buzz view
            Obx(
              () => Visibility(
                visible: (controller.receivedBuzz &&
                    ((message.id == controller.buzzOnMessageId.value) &&
                        (message.id != null))),
                child: const ConversationBuzzView(
                  size: 40,
                  inMessageView: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
