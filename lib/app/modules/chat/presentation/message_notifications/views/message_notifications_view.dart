import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/widgets/glass_panel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/message_notification_response_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/message_notifications/views/components/message_view/message_notification_view.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';

import '../controllers/message_notifications_controller.dart';

part 'components/message_notifications_error_view.dart';
part 'components/message_notifications_header.dart';
part 'components/loading_more_notifications_view.dart';

class MessageNotificationsView extends GetView<MessageNotificationsController> {
  const MessageNotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.markAllMessagesNotificationsAsViewed();
      },
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        body: Container(
          width: double.infinity,
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              const _MessageNotificationsHeader(),
              Expanded(
                child: Obx(
                  () => SmartRefresher(
                    controller: controller.refreshController,
                    header: WaterDropMaterialHeader(
                      color: Get.isDarkMode
                          ? Colors.white
                          : AppColorsLight.mainColor,
                      backgroundColor: theme.cardColor,
                      distance: 58,
                    ),
                    onRefresh: () async {
                      await controller.loadInitialData();
                      controller.refreshController.refreshCompleted();
                    },
                    child: _buildRefreshChild(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshChild(BuildContext context) {
    if (controller.isLoading) {
      return const _MessageNotificationsLoadingView();
    }

    if (controller.errorWhileLoading) {
      return const _MessageNotificationsErrorView();
    }

    if (controller.messagesNotifications.isEmpty) {
      return const _MessageNotificationsEmptyView();
    }

    final rows = _buildRows(controller.messagesNotifications);
    final showLoadingMore = controller.isLaodingMore;

    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      itemCount: rows.length + (showLoadingMore ? 1 : 0),
      itemBuilder: (context, position) {
        // trailing "loading more" indicator
        if (position >= rows.length) {
          return const _LoadingMoreNotificationsView();
        }

        final row = rows[position];

        // load the next page once the last notification is reached
        if (row is _NotificationItemRow && row.isLast) {
          controller.loadPaginatedData();
        }

        if (row is _DateGroupRow) {
          return _DateGroupHeader(label: row.label).marginOnly(
            top: row.isFirst ? 4 : 14,
            bottom: 10,
          );
        }

        row as _NotificationItemRow;
        return _NotificationTile(
          message: row.notification,
          index: row.index,
        ).marginOnly(bottom: 12);
      },
    );
  }

  /// Flattens the notifications into an ordered list of rows (date headers +
  /// items) so the list can be rendered lazily with [ListView.builder].
  List<_NotificationRow> _buildRows(
    List<MessageNotificationEntity> notifications,
  ) {
    final rows = <_NotificationRow>[];
    String? previousGroupKey;

    for (var index = 0; index < notifications.length; index++) {
      final createdAt = notifications[index].message?.createdAt;
      final groupKey = _dateGroupKey(createdAt);

      if (previousGroupKey != groupKey) {
        rows.add(_DateGroupRow(_dateGroupLabel(createdAt), rows.isEmpty));
        previousGroupKey = groupKey;
      }

      rows.add(
        _NotificationItemRow(
          notification: notifications[index],
          index: index,
          isLast: index == notifications.length - 1,
        ),
      );
    }

    return rows;
  }

  String _dateGroupKey(DateTime? date) {
    if (date == null) {
      return 'unknown';
    }
    return '${date.year}-${date.month}-${date.day}';
  }

  String _dateGroupLabel(DateTime? date) {
    if (date == null) {
      return 'Unknown date';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);
    final daysAgo = today.difference(itemDate).inDays;

    if (daysAgo == 0) {
      return 'Today';
    }
    if (daysAgo == 1) {
      return 'Yesterday';
    }
    if (daysAgo > 1 && daysAgo < 7) {
      return DateFormat('EEEE').format(date);
    }

    return DateFormat('MMM d, yyyy').format(date);
  }
}

/// Row descriptors used to render the grouped notifications list lazily.
sealed class _NotificationRow {
  const _NotificationRow();
}

class _DateGroupRow extends _NotificationRow {
  final String label;
  final bool isFirst;

  const _DateGroupRow(this.label, this.isFirst);
}

class _NotificationItemRow extends _NotificationRow {
  final MessageNotificationEntity notification;
  final int index;
  final bool isLast;

  const _NotificationItemRow({
    required this.notification,
    required this.index,
    required this.isLast,
  });
}

class _MessageNotificationsLoadingView extends StatelessWidget {
  const _MessageNotificationsLoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.58,
          child: Center(
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.dividerColor),
                boxShadow: Get.isDarkMode
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.applyOpacity(0.1),
                          blurRadius: 28,
                          offset: const Offset(0, 18),
                        ),
                      ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(17),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  strokeCap: StrokeCap.round,
                  color: AppColorsLight.mainColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageNotificationsEmptyView extends StatelessWidget {
  const _MessageNotificationsEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: theme.dividerColor),
            boxShadow: Get.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 18),
                    ),
                  ],
          ),
          child: Column(
            children: [
              Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColorsLight.mainColor.applyOpacity(0.12),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColorsLight.mainColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'No notifications yet',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'New message alerts will appear here.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateGroupHeader extends StatelessWidget {
  final String label;

  const _DateGroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? theme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: Get.isDarkMode ? Colors.grey : Colors.black38),
          ),
          child: Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              letterSpacing: 0,
              color: Get.isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.only(left: 10),
            color: Get.isDarkMode ? Colors.grey : Colors.black38,
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends GetView<MessageNotificationsController> {
  final MessageNotificationEntity message;
  final int index;

  final RxBool isExpanded = false.obs;

  _NotificationTile({
    required this.message,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final preview = _buildPreviewData();
    final senderName = _senderName;
    final subtitle = _subtitle;
    final createdAt = message.message?.createdAt;

    return Obx(
      () {
        final expanded = isExpanded.value;
        final unread = !message.read.value;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Get.isDarkMode
                ? const Color(0xFF1C1C1C).applyOpacity(0.5)
                : Colors.white,
            border: Border.all(
              color: unread
                  ? AppColorsLight.mainColor.applyOpacity(0.36)
                  : Get.isDarkMode
                      ? Colors.white24
                      : const Color(0xFF1C1C1C).applyOpacity(0.3),
            ),
            boxShadow: Get.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.applyOpacity(0.1),
                      blurRadius: 28,
                      offset: const Offset(0, 18),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              if (unread)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 4,
                      margin: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColorsLight.mainColorLight,
                            AppColorsLight.mainColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      splashColor: AppColorsLight.mainColor.applyOpacity(0.08),
                      highlightColor:
                          AppColorsLight.mainColor.applyOpacity(0.03),
                      onTap: _toggleExpansion,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAvatar(senderName, unread)
                                .marginOnly(right: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          senderName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            height: 1.15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        createdAt.formatTime(),
                                        textAlign: TextAlign.end,
                                        style: context.textTheme.labelSmall
                                            ?.copyWith(
                                          letterSpacing: 0,
                                          color: theme.hintColor,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  _NotificationSubtitle(
                                    text: subtitle,
                                    isGroup: message.group != null,
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    switchInCurve: Curves.easeOutCubic,
                                    switchOutCurve: Curves.easeOutCubic,
                                    child: expanded
                                        ? const SizedBox(
                                            key: ValueKey('expanded-preview'),
                                            height: 8,
                                          )
                                        : Padding(
                                            key: const ValueKey(
                                                'collapsed-text'),
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: _buildPreview(
                                              context,
                                              preview,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 52,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: unread
                                        ? const _UnreadBadge(
                                            key: ValueKey('unread-badge'),
                                          )
                                        : const _ReadIndicator(
                                            key: ValueKey('read-dot'),
                                          ),
                                  ),
                                  const SizedBox(height: 16),
                                  AnimatedRotation(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeOutCubic,
                                    turns: expanded ? 0.5 : 0,
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: expanded
                                          ? context.textTheme.titleMedium?.color
                                          : theme.hintColor,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 220),
                    firstCurve: Curves.easeOutCubic,
                    secondCurve: Curves.easeOutCubic,
                    sizeCurve: Curves.easeOutCubic,
                    crossFadeState: expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: MessageNotificationItemView(
                          message: message,
                          index: index,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String get _senderName {
    final name = message.message?.model?.name?.trim();
    return (name == null || name.isEmpty) ? 'Unknown sender' : name;
  }

  String get _subtitle {
    if (message.group != null) {
      final groupName = message.group?.name?.trim();
      return (groupName == null || groupName.isEmpty)
          ? 'Group conversation'
          : groupName;
    }

    final designation = message.message?.model?.userDesignation?.trim();
    return (designation == null || designation.isEmpty)
        ? 'Direct message'
        : designation;
  }

  void _toggleExpansion() {
    final willExpand = !isExpanded.value;
    isExpanded.value = willExpand;
    if (willExpand && !message.read.value) {
      controller.markMessageNotificationAsRead(message);
    }
  }

  Widget _buildAvatar(String senderName, bool unread) {
    final imageUrl = message.message?.model?.image?.trim();
    final initial = senderName.characters.first.toUpperCase();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 54,
          width: 54,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: unread ? AppColorsLight.mainColor : Get.theme.dividerColor,
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              shape: BoxShape.circle,
            ),
            child: (imageUrl == null || imageUrl.isEmpty)
                ? _InitialsAvatar(initial: initial)
                : ProfileImage.network(
                    url: imageUrl,
                    width: 46,
                    height: 46,
                    showLetterOnError: true,
                    letter: initial,
                    letterBackgroundColor: AppColorsLight.mainColor,
                    letterColor: AppColorsLight.mainColor,
                  ),
          ),
        ),
        if (unread)
          Positioned(
            right: 1,
            bottom: 2,
            child: Container(
              height: 13,
              width: 13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorsLight.onlineColor,
                border: Border.all(
                  color: Get.theme.cardColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreview(
    BuildContext context,
    _NotificationPreviewData preview,
  ) {
    final previewStyle = context.textTheme.bodySmall?.copyWith(
      color: context.theme.hintColor,
      height: 1.25,
      fontWeight: FontWeight.w500,
    );

    if (preview.isMediaMessage && preview.mediaIcon != null) {
      return Row(
        children: [
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: message.message?.type == MessageTypes.recorded
                  ? Icon(
                      Icons.mic_rounded,
                      size: 16,
                      color: context.theme.hintColor,
                    )
                  : Image.asset(
                      preview.mediaIcon!,
                      width: 16,
                      height: 16,
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              preview.text,
              style: previewStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text.rich(
      _replaceUserMentions(preview.text, previewStyle),
      style: previewStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  _NotificationPreviewData _buildPreviewData() {
    var messageString = '';
    var isMediaMessage = false;
    String? mediaIcon;

    if (message.message?.deletedAt != null) {
      messageString = 'This message was deleted.';
    } else if (message.message?.attachments?.isNotEmpty ?? false) {
      final media = message.message!.attachments![0];
      if (media.fileName != null) {
        isMediaMessage = true;
        final fileType =
            controller.fileExtensionHelper.getFileType(media.fileName!);
        mediaIcon = controller.fileExtensionHelper.getFileIcon(fileType);
        messageString = _mediaPreviewLabel(fileType);

        if ((fileType != FileTypes.none) &&
            (message.message!.duration != null) &&
            (message.message!.type == MessageTypes.audio ||
                message.message!.type == MessageTypes.recorded)) {
          messageString = controller.formatAudioMessageDuration(
            message.message!.duration ?? 0,
          );
        }
      } else {
        messageString = 'Media attachment';
      }
    } else if ((message.message?.message != null) &&
        (message.message?.message != 'null')) {
      messageString = message.message?.message ?? '';
    }

    if (messageString.trim().isEmpty) {
      messageString = 'Message';
    }

    return _NotificationPreviewData(
      text: messageString.trim(),
      isMediaMessage: isMediaMessage,
      mediaIcon: mediaIcon,
    );
  }

  String _mediaPreviewLabel(FileTypes fileType) {
    switch (fileType) {
      case FileTypes.png:
      case FileTypes.jpg:
      case FileTypes.jpeg:
        return 'Image attachment';
      case FileTypes.mp4:
      case FileTypes.mpeg:
      case FileTypes.webm:
        return 'Video attachment';
      case FileTypes.audio:
      case FileTypes.voice:
      case FileTypes.m4a:
      case FileTypes.wav:
      case FileTypes.mp3:
        return 'Voice message';
      case FileTypes.none:
        return 'Media attachment';
      default:
        return 'Document attachment';
    }
  }

  TextSpan _replaceUserMentions(String text, TextStyle? effectiveTextStyle) {
    RegExp userIdRegex = RegExp(r'\[~(\d+)\]');
    Iterable<Match> matches = userIdRegex.allMatches(text);

    List<InlineSpan> spans = [];

    final myId = GetStorage().read(UserPrefKeys.userId).toString();

    int lastIndex = 0;
    for (Match match in matches) {
      // Add text before the mention
      spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: effectiveTextStyle));

      int userId = int.parse(match.group(1)!); // Extract user id from the match
      ConversationMentionEntity? user = message.message?.mentions
          ?.firstWhereOrNull((user) => user.participantId == userId);

      // Replace [~userId] with the user name
      if (user != null) {
        spans.add(TextSpan(
          text: user.user?.name ?? "Unknown",
          style: effectiveTextStyle?.copyWith(
            color: message.message?.modelId.toString() == myId
                ? AppColorsLight.mainColor
                : AppColorsLight.mainColorLight,
            fontWeight: FontWeight.w700,
          ),
        ));
      }

      lastIndex = match.end;
    }

    // Add the remaining text after the last mention
    if (lastIndex < text.length) {
      spans.add(
          TextSpan(text: text.substring(lastIndex), style: effectiveTextStyle));
    }

    return TextSpan(children: spans);
  }
}

class _NotificationPreviewData {
  final String text;
  final bool isMediaMessage;
  final String? mediaIcon;

  const _NotificationPreviewData({
    required this.text,
    required this.isMediaMessage,
    required this.mediaIcon,
  });
}

class _NotificationSubtitle extends StatelessWidget {
  final String text;
  final bool isGroup;

  const _NotificationSubtitle({
    required this.text,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Icon(
          isGroup ? Icons.groups_2_rounded : Icons.person_outline_rounded,
          color: theme.hintColor,
          size: 14,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initial;

  const _InitialsAvatar({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorsLight.mainColor.applyOpacity(0.12),
      ),
      child: Center(
        child: Text(
          initial,
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColorsLight.mainColor,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: AppColorsLight.mainColor.applyOpacity(0.16),
          borderRadius: BorderRadius.circular(999),
          border:
              Border.all(color: AppColorsLight.mainColor.applyOpacity(0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 5,
              decoration: const BoxDecoration(
                color: AppColorsLight.mainColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'New',
              style: context.textTheme.labelSmall?.copyWith(
                letterSpacing: 0,
                color: Get.isDarkMode ? Colors.white : AppColorsLight.mainColor,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadIndicator extends StatelessWidget {
  const _ReadIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(top: 6, right: 4),
      decoration: BoxDecoration(
        color: context.theme.dividerColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
