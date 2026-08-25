import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/helpers/chat_navigation.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/controllers/conversations_controller.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/views/components/chat_empty_state.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/views/components/bottom_sheets_components/call_log_conversations_icon.dart';

import '../controllers/oto_conversations_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class OtoConversationsView extends GetView<OtoConversationsController> {
  const OtoConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ((controller.isLoadingConversations &&
                  controller.isConversationsListEmptyFromDatabase) ||
              controller.isLoadingConversationsFromDatabase)
          ? buildLoadingView()
          : LayoutBuilder(
              builder: (
                BuildContext context,
                BoxConstraints constraints,
              ) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    // archived toggle
                    Obx(
                      () => Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            controller.isViewingArchivedChats.toggle();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(
                                left: 14.w, top: 12.h, bottom: 4.h),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: controller.isViewingArchivedChats.value
                                  ? Colors.blue.applyOpacity(0.10)
                                  : (Get.isDarkMode
                                      ? Colors.white.applyOpacity(0.05)
                                      : Colors.black.applyOpacity(0.035)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  controller.isViewingArchivedChats.value
                                      ? Icons.arrow_back_rounded
                                      : Icons.archive_outlined,
                                  size: 16,
                                  color: controller.isViewingArchivedChats.value
                                      ? Colors.blue
                                      : (Get.isDarkMode
                                          ? Colors.white70
                                          : AppColorsLight.textColor),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  controller.isViewingArchivedChats.value
                                      ? "Back to chats"
                                      : "Archived",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: controller
                                                .isViewingArchivedChats.value
                                            ? Colors.blue
                                            : (Get.isDarkMode
                                                ? Colors.white70
                                                : AppColorsLight.textColor),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SlidableAutoCloseBehavior(
                        child: Obx(
                          () => SmartRefresher(
                            controller: controller.refreshController,
                            header: const WaterDropMaterialHeader(),
                            onRefresh: () async {
                              await controller.getAllConversations();
                              controller.refreshController.refreshCompleted();
                            },
                            child: controller.conversations.isEmpty
                                ? const ChatEmptyState(
                                    icon: Icons.chat_bubble_outline_rounded,
                                    title: "No conversations yet",
                                    subtitle:
                                        "Start a new chat from your contacts",
                                  )
                                : controller.isSearchEnabled.value
                                    ? _buildSearchListView()
                                    : controller.isViewingArchivedChats.value
                                        ? _buildArchivedListView()
                                        : _buildNormalListView(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSearchListView() {
    return ListView.separated(
      itemCount: controller.filteredConversations.length,
      itemBuilder: (BuildContext context, int index) {
        final ConversationEntity conversation =
            controller.filteredConversations.elementAt(index);
        return _ConversationTile(
          index: index,
          conversation: conversation,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
          thickness: 1,
          indent: 80.w,
          endIndent: 16.w,
          color: Colors.grey.applyOpacity(0.12),
        );
      },
    );
  }

  Widget _buildNormalListView() {
    return ListView.separated(
      itemCount: controller.normalConversations.length,
      itemBuilder: (BuildContext context, int index) {
        final ConversationEntity conversation =
            controller.normalConversations.elementAt(index);
        return _ConversationTile(
          index: index,
          conversation: conversation,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
          thickness: 1,
          indent: 80.w,
          endIndent: 16.w,
          color: Colors.grey.applyOpacity(0.12),
        );
      },
    );
  }

  Widget _buildArchivedListView() {
    return ListView.separated(
      itemCount: controller.archiveConversations.length,
      itemBuilder: (BuildContext context, int index) {
        final ConversationEntity conversation =
            controller.archiveConversations.elementAt(index);
        return _ConversationTile(
          index: index,
          conversation: conversation,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
          thickness: 1,
          indent: 80.w,
          endIndent: 16.w,
          color: Colors.grey.applyOpacity(0.12),
        );
      },
    );
  }

  Widget buildLoadingView() {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white30,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(top: index == 0 ? 14 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 100.w,
                        height: 15,
                        decoration: BoxDecoration(
                            color: AppColorsLight.white,
                            borderRadius: BorderRadius.circular(5)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            const SizedBox(
              width: 62,
            ),
            Expanded(
              child: Divider(
                height: 10.h,
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ConversationTile extends GetView<OtoConversationsController> {
  final int index;
  final ConversationEntity conversation;

  const _ConversationTile({
    required this.index,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    // Retrieve specific theme colors
    // Color primaryColor = theme.primaryColor;
    // Color primaryColorDark = theme.primaryColorDark;
    // Color primaryColorLight = theme.primaryColorLight;
    // Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    // Color cardColor = theme.cardColor;

    //
    //
    final myId = controller.myId;

    // building message string
    String messageString = "";
    bool isMediaMessage = false;
    String? mediaIcon;

    ConversationMessageEntity? messageEntity;

    if (conversation.message?.deletedAt != null) {
      messageString = "🚫 This message was deleted.";
    } else if (conversation.message?.type == MessageTypes.callLog) {
      messageString = controller.getCallText(0, 'oto',
          conversation.message?.message ?? "", conversation.message?.duration);
      try {
        if (conversation.message != null) {
          messageEntity = ConversationMessageModel.fromJson(
              conversation.message?.toJson() ?? {});
        }
      } catch (_) {}
    } else {
      // if message was sent by me then add a you at the start of the string
      if (conversation.message?.modelId.toString() == myId) {
        messageString += "You: ";
      }

      // if message contains a media then show that last message is media
      if (conversation.message?.attachments?.isNotEmpty ?? false) {
        final media = conversation.message!.attachments![0];
        if (media.fileName != null) {
          isMediaMessage = true;
          final fileType =
              controller.fileExtensionHelper.getFileType(media.fileName!);
          mediaIcon = controller.fileExtensionHelper.getFileIcon(fileType);

          if ((fileType != FileTypes.none) &&
              (conversation.message!.duration != null) &&
              (conversation.message!.type == MessageTypes.audio ||
                  conversation.message!.type == MessageTypes.recorded)) {
            messageString +=
                " ${controller.formatAudioMessageDuration(conversation.message!.duration ?? 0)} ";
          }
        } else {
          messageString += "media 📎";
        }
      }
      // else if last message is not null concat the message string
      else if ((conversation.message?.message != null) &&
          (conversation.message?.message != "null")) {
        messageString += (conversation.message?.message ?? "");
      }
    }

    ConversationsController? conversationsController;

    if (Get.isRegistered<ConversationsController>()) {
      try {
        conversationsController = Get.find<ConversationsController>();
      } catch (_) {}
    }

    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      groupTag: "one_to_one_conversations_slide_group",
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (conversation.status == "archive") {
                controller.removeConversationFromArchive(conversation);
              } else {
                controller.moveConversationToArchive(conversation);
              }
            },
            backgroundColor: AppColorsLight.mainColor,
            foregroundColor: Colors.white,
            icon: conversation.status == "archive"
                ? Icons.unarchive_rounded
                : Icons.archive_rounded,
            label: conversation.status == "archive" ? 'Unarchive' : 'Archive',
          ),
          SlidableAction(
            onPressed: (context) {
              if (conversation.notificationMuted == true) {
                controller.unmuteConversation(conversation, index);
              } else {
                controller.muteConversation(conversation, index);
              }
            },
            backgroundColor: AppColorsLight.mainColor,
            foregroundColor: Colors.white,
            icon: conversation.notificationMuted == true
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            label: conversation.notificationMuted == true ? 'Unmute' : 'Mute',
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColorsLight.mainColor.applyOpacity(0.06),
          highlightColor: AppColorsLight.mainColor.applyOpacity(0.03),
          onTap: () async {
            await ChatNavigation.open(
                ChatNavigation.otoArguments(conversation));
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                //
                // avatar + online indicator
                GestureDetector(
                  onTap: () {
                    showImageDialog(
                      context,
                      conversation.user?.image ?? "",
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ProfileImage.network(
                        url: conversation.user?.image ?? "",
                        width: 52,
                        height: 52,
                      ),
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: Obx(
                          () => Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (conversationsController?.isUserOnline(
                                          conversation.user?.id,
                                          conversation.user?.modelType) ??
                                      false)
                                  ? AppColorsLight.onlineColor
                                  : Colors.grey.shade400,
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                //
                // name + time + preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.user?.name ?? "",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: (conversation.unreadCount ?? 0) > 0
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            conversation.dateTimeInHumans ?? "",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: (conversation.unreadCount ?? 0) > 0
                                  ? AppColorsLight.mainColor
                                  : (Get.isDarkMode
                                      ? Colors.white54
                                      : AppColorsLight.textColor
                                          .applyOpacity(0.7)),
                              fontWeight: (conversation.unreadCount ?? 0) > 0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          // archived tag
                          if (conversation.status == "archive")
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.grey.applyOpacity(0.25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'archived',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Get.isDarkMode
                                      ? Colors.white70
                                      : AppColorsLight.textColor,
                                ),
                              ),
                            ),

                          // call-log icon
                          if (conversation.message?.type ==
                                  MessageTypes.callLog &&
                              messageEntity != null)
                            CallLogConversationsIcon(
                                message: messageEntity, width: 10, height: 10),

                          // last message preview
                          Expanded(
                            child: isMediaMessage && mediaIcon != null
                                ? Row(
                                    children: [
                                      conversation.message?.type ==
                                              MessageTypes.recorded
                                          ? const Icon(Icons.mic, size: 16)
                                          : Image.asset(
                                              mediaIcon,
                                              width: 16,
                                              height: 16,
                                            ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          messageString,
                                          style: theme.textTheme.bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    messageString,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight:
                                          (conversation.unreadCount ?? 0) > 0
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          const SizedBox(width: 8),
                          // mute icon / loading
                          Obx(
                            () => controller.isMutingConversation &&
                                    (controller.mutingAtIndex.value == index)
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      color: AppColorsLight.mainColor,
                                      strokeCap: StrokeCap.round,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : (conversation.notificationMuted == true)
                                    ? Icon(
                                        Icons.volume_off_rounded,
                                        size: 16,
                                        color: Get.isDarkMode
                                            ? Colors.white54
                                            : AppColorsLight.textColor
                                                .applyOpacity(0.7),
                                      )
                                    : const SizedBox.shrink(),
                          ),
                          // unread badge
                          if ((conversation.unreadCount ?? 0) > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              constraints: const BoxConstraints(
                                  minWidth: 20, minHeight: 20),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: AppColorsLight.mainColor,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Center(
                                child: Text(
                                  (conversation.unreadCount ?? 0) > 99
                                      ? "99+"
                                      : conversation.unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
