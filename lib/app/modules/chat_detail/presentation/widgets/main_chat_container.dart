import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

class MainChatContainer extends StatelessWidget {
  final Widget child;
  final bool isSender;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? senderColor;
  final Color? receiverColor;
  final BorderRadius? borderRadius;
  final bool? withConstraints;

  const MainChatContainer({
    super.key,
    required this.child,
    required this.isSender,
    this.margin = const EdgeInsets.only(top: 10),
    this.padding = const EdgeInsets.all(10),
    this.senderColor,
    this.receiverColor,
    this.borderRadius,
    this.withConstraints = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.8),
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: isSender
            ? Get.isDarkMode
                ? AppColorsDark.chatSenderColor
                : AppColorsLight.chatSenderColor
            : Get.isDarkMode
                ? AppColorsDark.chatReciverColor
                : AppColorsLight.chatReciverColor,
        borderRadius: borderRadius ??
            BorderRadius.only(
              bottomLeft: const Radius.circular(10),
              bottomRight: const Radius.circular(10),
              topLeft: Radius.circular(isSender ? 12 : 0),
              topRight: Radius.circular(isSender ? 0 : 12),
            ),
      ),
      child: child,
    );
  }
}
