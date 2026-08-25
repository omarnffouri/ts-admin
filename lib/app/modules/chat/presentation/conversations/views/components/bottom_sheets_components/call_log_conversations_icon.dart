import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/oto_conversations/controllers/oto_conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

class CallLogConversationsIcon extends GetView<OtoConversationsController> {
  final ConversationMessageEntity message;
  final double width;
  final double height;

  const CallLogConversationsIcon(
      {super.key,
      required this.message,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.isDarkMode
            ? message.modelId.toString() == controller.myId
                ? AppColorsDark.senderCallBackgroundColor
                : AppColorsDark.reciverCallBackgroundColor
            : message.modelId.toString() == controller.myId
                ? AppColorsLight.senderCallBackgroundColor
                : AppColorsLight.reciverCallBackgroundColor,
      ),
      // set icons on the bases of model or call placed by and received by
      child: message.modelId.toString() == controller.myId
          ? SvgPicture.asset(
              Assets.icons.callOutGoing,
              width: width,
              height: height,
              colorFilter: ColorFilter.mode(
                Get.isDarkMode
                    ? AppColorsDark.senderCallColor
                    : AppColorsLight.senderCallColor,
                BlendMode.srcIn,
              ),
            )
          : SvgPicture.asset(
              message.message == AgoraCallEvents.incommingCall
                  ? Assets.icons.callMissed
                  : message.message == AgoraCallEvents.callDeclined
                      ? Assets.icons.callDeclined
                      : message.message == AgoraCallEvents.callDeclined
                          ? Assets.icons.callIncomming
                          : message.message == AgoraCallEvents.noAnswer
                              ? Assets.icons.callNotAnswered
                              : message.message == AgoraCallEvents.callEnded
                                  ? Assets.icons.callIncomming
                                  : Assets.icons.callMissed,
              width: width,
              height: height,
              colorFilter: ColorFilter.mode(
                Get.isDarkMode
                    ? AppColorsDark.reciverCallColor
                    : AppColorsLight.reciverCallColor,
                BlendMode.srcIn,
              ),
            ),
    );
  }
}
