part of '../message_notification_view.dart';

class _MNReplyMessageView extends GetView<MessageNotificationsController> {
  final ConversationMessageEntity message;

  const _MNReplyMessageView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.80,
        minHeight: 50,
        maxHeight: 66,
      ),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade700,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.model?.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ).marginOnly(bottom: 5),
                Row(
                  children: [
                    // text view
                    Expanded(
                        child: Text.rich(
                      TextSpan(
                          children: _replaceUserMentions(
                        message.message != "null" && message.message != null
                            ? message.message!
                            : "",
                        const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ).children),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )),
                  ],
                ),
              ],
            ).marginAll(5),
          ),
          if (message.attachments?.isNotEmpty ?? false)
            (message.type == MessageTypes.image)
                ? message.sendedNow
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          message.attachments![0].file!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ).marginOnly(right: 5)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: CachedNetworkImageProvider(
                            message.attachments?[0].url ?? "",
                          ),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.image,
                            size: 50,
                          ),
                        ),
                      ).marginOnly(right: 5)
                : (message.type == MessageTypes.audio ||
                        message.type == MessageTypes.recorded)
                    ? Row(
                        children: [
                          const Icon(
                            Icons.mic,
                            color: Colors.white70,
                            size: 25,
                          ),
                          Text(
                            formatTime(message.duration ?? 0),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ).marginOnly(right: 5)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            controller.fileExtensionHelper.getFileIcon(
                              controller.fileExtensionHelper.getFileType(
                                message.attachments![0].url ?? "",
                              ),
                            ),
                            width: 25,
                            height: 25,
                          ),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 70),
                            child: Text(
                              controller.fileExtensionHelper.getFileName(
                                message.attachments?[0].url ??
                                    "/some_file.jhghj",
                                withExtension: true,
                              ),
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ).marginOnly(right: 5),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '$hours:${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
    } else {
      return '${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
    }
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  TextSpan _replaceUserMentions(String text, TextStyle? effectiveTextStyle) {
    RegExp userIdRegex = RegExp(r'\[~(\d+)\]');
    Iterable<Match> matches = userIdRegex.allMatches(text);

    final myId = GetStorage().read(UserPrefKeys.userId).toString();

    List<InlineSpan> spans = [];

    int lastIndex = 0;
    for (Match match in matches) {
      // Add text before the mention and also call a bold text spans function
      spans.addAll(_makeBoldTextSpansBetweenStars(
                  text.substring(lastIndex, match.start), effectiveTextStyle)
              .children ??
          []);

      int userId = int.parse(match.group(1)!); // Extract user id from the match
      ConversationMentionEntity? user = message.mentions
          ?.firstWhereOrNull((user) => user.participantId == userId);

      // Replace [~userId] with the user name
      if (user != null) {
        spans.add(TextSpan(
          text: user.user?.name ?? "Unknown",
          style: effectiveTextStyle?.copyWith(
              color: message.modelId.toString() == myId
                  ? Get.isDarkMode
                      ? AppColorsDark.chatSenderMentionColor
                      : AppColorsLight.chatSenderMentionColor
                  : Get.isDarkMode
                      ? AppColorsDark.chatReciverMentionColor
                      : AppColorsLight.chatReciverMentionColor),
        ));
      }

      lastIndex = match.end;
    }

    // Add the remaining text after the last mention and also call a bold text spans function
    if (lastIndex < text.length) {
      String remainingText = text.substring(lastIndex);
      spans.addAll(
          _makeBoldTextSpansBetweenStars(remainingText, effectiveTextStyle)
                  .children ??
              []);
    }

    return TextSpan(children: spans);
  }

  TextSpan _makeBoldTextSpansBetweenStars(
      String text, TextStyle? effectiveTextStyle) {
    List<InlineSpan> spans = [];
    RegExp boldRegex = RegExp(r'\*(.*?)\*');

    Iterable<Match> boldMatches = boldRegex.allMatches(text);

    int lastIndex = 0;
    for (Match boldMatch in boldMatches) {
      // Add text before the bold section
      spans.add(TextSpan(
        text: text.substring(lastIndex, boldMatch.start),
        style: effectiveTextStyle,
      ));

      // Add bold text
      spans.add(TextSpan(
        text: boldMatch.group(1),
        style: effectiveTextStyle?.copyWith(fontWeight: FontWeight.bold),
      ));

      lastIndex = boldMatch.end;
    }

    // Add the remaining text after the last bold section
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: effectiveTextStyle,
      ));
    }

    return TextSpan(children: spans);
  }
}
