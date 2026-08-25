import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:ts_admin/app/core/helpers/chat_navigation.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/screens/base_screen.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/message_types.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/conversation_details_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/views/components/bottom_sheets_components/call_log_conversations_icon.dart';

import '../controllers/group_inner_conversations_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class GroupInnerConversationsView
    extends GetView<GroupInnerConversationsController> {
  const GroupInnerConversationsView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: BaseScreen(
        child: Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final closed = constraints.scrollOffset > 185;
                  return SliverAppBar.medium(
                    backgroundColor: AppColors.mainColor,
                    stretch: true,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarContrastEnforced: true,
                    ),
                    expandedHeight: 250.0,
                    foregroundColor: Colors.white,
                    leading: Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: closed ? null : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 25,
                            color: closed ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      //
                      // serach icon
                      Obx(
                        () => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            color: closed ? null : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width:
                              controller.searchEnabled ? Get.width * 0.70 : 35,
                          height: controller.searchEnabled ? 45 : 35,
                          child: Obx(
                            () => controller.searchEnabled
                                ? Container(
                                    constraints: BoxConstraints(
                                      maxWidth: Get.width * 0.70,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: Get.width * 0.70,
                                            ),
                                            child: _buildSearchField(closed),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      controller.toggleSearch();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.search_rounded,
                                        size: 25,
                                        color: closed
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      // if (controller.authController.userPermissionHelper
                      //         .canManageGroups() &&
                      //     controller.isParticipant())
                      //
                      // group settings icon
                      Visibility(
                        visible: (controller.authController.userPermissionHelper
                                .canManageGroups() &&
                            controller.iAmAdmin()),
                        child: GestureDetector(
                          onTap: () {
                            controller.openGroupSettings();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 14),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: closed ? null : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.settings_rounded,
                              size: 25,
                              color: closed ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const <StretchMode>[
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      collapseMode: CollapseMode.pin,
                      title: Obx(
                        () => Visibility(
                          visible: !closed,
                          child: Text(
                            controller.groupName.value,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          //
                          //
                          // group logo
                          Obx(
                            () => CachedNetworkImage(
                              imageUrl: controller.groupLogo.value,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.mainColor.applyOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.groupName.value.isNotEmpty
                                          ? (controller.groupName.value[0]
                                                  .capitalize ??
                                              "")
                                          : "",
                                      style: theme.textTheme.displayMedium
                                          ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0.0, 1),
                                end: Alignment.topCenter,
                                colors: <Color>[
                                  AppColors.mainColor.applyOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Obx(
                      () => Visibility(
                        visible: (!controller.searchEnabled),
                        child: Text(
                          controller.groupName.value,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              //
              //
              // archived and back icon
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //
                    GestureDetector(
                      onTap: () {
                        controller.toggleArchive();
                      },
                      child: Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.isViewingArchiveConversations
                                  ? Icons.unarchive_rounded
                                  : Icons.archive_rounded,
                              size: 25,
                              color: controller.isViewingArchiveConversations
                                  ? Colors.blue
                                  : AppColors.archiveLableColor,
                            ),
                            Text(
                              controller.isViewingArchiveConversations
                                  ? 'Back'
                                  : 'Archived',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: controller.isViewingArchiveConversations
                                    ? Colors.blue
                                    : AppColors.archiveLableColor,
                              ),
                            ).marginOnly(left: 5)
                          ],
                        ),
                      ),
                    ).marginOnly(left: 14, top: 14)
                  ],
                ),
              ),

              //
              //
              // innner conversations list view
              Obx(
                () => controller.getConversationsList().isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            controller.searchEnabled ? "No Results" : "No Data",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColors.mainColor,
                            ),
                          ),
                        ).marginOnly(top: 150),
                      )
                    : SlidableAutoCloseBehavior(
                        child: Obx(
                          () => SliverList.separated(
                            itemCount: controller.getConversationsList().length,
                            itemBuilder: (context, index) {
                              final conversation =
                                  controller.getConversationsList()[index];
                              return _InnerConversationTile(
                                index: index,
                                conversation: conversation,
                                groupName: controller.groupName.value,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 62,
                                  ),
                                  Expanded(
                                    child: Divider(
                                      height: 5,
                                      color: Colors.grey.applyOpacity(0.2),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(bool appBarClosed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white, // Background color
      ),
      child: TextField(
          controller: controller.searchTextController,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.all(0),
            hintText: "Search by name",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none, // Remove the default border
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                controller.clearSearch();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.grey,
              ),
            ),
          ) // Optional icon
          ),
    );
  }
}

class _InnerConversationTile
    extends GetView<GroupInnerConversationsController> {
  final int index;

  final GroupConversationConversationEntity conversation;
  final String groupName;

  const _InnerConversationTile({
    required this.index,
    required this.conversation,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    final myId = GetStorage().read(UserPrefKeys.userId).toString();

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

    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      groupTag: "group_inner_conversations_slide_group",
      endActionPane: ActionPane(
        extentRatio: (conversation.chatAble ?? false) ? 0.5 : 0.3,
        motion: const BehindMotion(),
        children: [
          if (conversation.chatAble ?? false)
            SlidableAction(
              onPressed: (context) {
                if (conversation.status == "archive") {
                  controller.removeConversationFromArchiveInGroup(conversation);
                } else {
                  controller.moveConversationToArchiveInGroup(conversation);
                }
              },
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              icon: conversation.status == "archive"
                  ? Icons.unarchive_rounded
                  : Icons.archive_rounded,
              label: conversation.status == "archive" ? 'Unarchive' : 'Archive',
            ),

          //
          //
          // mute option
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
      child: InkWell(
        onTap: () async {
          await ChatNavigation.open({
            'type': "group",
            'userPhone': (conversation.participants
                        ?.map((e) =>
                            e.id.toString() == myId.toString() ? "You" : e.name)
                        .toString() ??
                    "")
                .replaceAll("(", "")
                .replaceAll(")", ""),
            'userImage': "",
            'userName': conversation.name ?? "",
            'group_name': groupName,
            'modelType': "",
            'conversation_id': conversation.id,
            'chatable': conversation.chatAble,
            'i_am_participant':
                conversation.participants?.firstWhereOrNull((element) {
                      return element.id.toString() == myId;
                    }) !=
                    null,
            'messages': null,
            'groupId': controller.getGroupId(),
          });

          // controller.loadGroupDetails();
        },
        child: Container(
          margin: index == 0
              ? const EdgeInsets.only(left: 1, right: 1, top: 5)
              : const EdgeInsets.symmetric(horizontal: 1),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          foregroundDecoration: (conversation.chatAble ?? false)
              ? null
              : RotatedCornerDecoration.withColor(
                  color: AppColors.mainColor,
                  spanBaselineShift: 1,
                  badgeSize: const Size(20, 20),
                  badgeCornerRadius: const Radius.circular(8),
                  badgePosition: BadgePosition.topStart,
                ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              // user image
              ProfileImage.network(
                url: conversation.image,
                width: 45,
                height: 45,
                showLetterOnError: true,
                letter: conversation.name?[0].toUpperCase(),
                letterBackgroundColor:
                    AppColors.converstionsImageLetterBackgroundColor,
                letterColor: AppColors.converstionsImageLetterColor,
              ),

              //
              // space
              const SizedBox(width: 12),

              //
              // name and last message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    // user name
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name ?? "",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: (conversation.chatAble ?? false)
                                  ? null
                                  : AppColors.mainColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    //
                    //
                    // archive icon, call-log icon and message
                    Row(
                      children: [
                        //
                        //
                        // archive icon
                        Visibility(
                          visible: conversation.status == "archive",
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(2)),
                            child: Center(
                              child: Text(
                                'archived',
                                style: TextStyle(
                                        fontSize: 10,
                                        color: Get.isDarkMode
                                            ? Colors.black
                                            : Colors.white)
                                    .copyWith(
                                  color: (conversation.chatAble ?? false)
                                      ? null
                                      : AppColors.mainColor,
                                ),
                              ),
                            ),
                          ),
                        ),

                        //
                        //
                        // ongoing call icon, text, and join button
                        if (conversation.haveOngoingCall)
                          Row(
                            children: [
                              //
                              // ongoing call icon
                              const Icon(
                                Icons.call,
                                size: 15,
                                color: Colors.green,
                              ),

                              //
                              // ongoing call text
                              const Text(
                                "Ongoing Call...",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ).marginOnly(left: 5),
                            ],
                          ),

                        //
                        // call log icon, message view
                        if (!conversation.haveOngoingCall)
                          Expanded(
                            child: Row(
                              children: [
                                //
                                //
                                // call-log icon
                                if (conversation.message?.type ==
                                        MessageTypes.callLog &&
                                    messageEntity != null)
                                  CallLogConversationsIcon(
                                    message: messageEntity,
                                    width: 10,
                                    height: 10,
                                  ),

                                //
                                //
                                // text message
                                Expanded(
                                  child: isMediaMessage && mediaIcon != null
                                      ? Row(
                                          children: [
                                            Text(
                                              messageString,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: (conversation.chatAble ??
                                                        false)
                                                    ? null
                                                    : AppColors.mainColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            conversation.message?.type ==
                                                    MessageTypes.recorded
                                                ? const Icon(
                                                    Icons.mic,
                                                    size: 20,
                                                  )
                                                : Image.asset(
                                                    mediaIcon,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                          ],
                                        )
                                      : Text.rich(
                                          _replaceUserMentions(messageString,
                                              theme.textTheme.bodySmall),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color:
                                                (conversation.chatAble ?? false)
                                                    ? null
                                                    : AppColors.mainColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),

              //
              //
              // ongoing call join icon
              if (conversation.haveOngoingCall &&
                  !(conversation.ongoingCall?.isAccepted.value ?? false))
                GestureDetector(
                  onTap: () {
                    try {
                      controller.joinOngoingCall(
                          conversation.ongoingCall!, conversation.name ?? "",
                          conversationId: conversation.id);
                    } catch (_) {}
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.call,
                          size: 15,
                          color: Colors.white,
                        ),
                        Text(
                          "Join",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              //
              //
              // mentioned sign and unread counts
              // and remove label and last seen
              if (!conversation.haveOngoingCall)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //
                    // mentioned sign and unread counts
                    Row(
                      children: [
                        //
                        //
                        // mention sign
                        if (conversation.mentioned?.isNotEmpty ?? false)
                          Text(
                            "@",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : AppColorsLight.mainColor,
                            ),
                          ).marginSymmetric(horizontal: 5),

                        //
                        //
                        // unread counts
                        if ((conversation.unreadCount != null) &&
                            (conversation.unreadCount != 0))
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppColorsLight.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (conversation.unreadCount ?? 0) > 99
                                    ? "99+"
                                    : conversation.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                        //
                        //
                        // muted icon and loading
                        Obx(
                          () => controller.isMutingConversation &&
                                  (controller.mutingAtIndex.value == index)
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: AppColorsLight.mainColor,
                                    strokeCap: StrokeCap.round,
                                    strokeWidth: 4,
                                  ),
                                ).marginOnly(left: 10)
                              : Visibility(
                                  visible:
                                      conversation.notificationMuted == true,
                                  child: const Icon(
                                    Icons.volume_off_rounded,
                                    size: 20,
                                    color: AppColorsLight.mainColor,
                                  ).marginOnly(left: 5),
                                ),
                        ),
                      ],
                    ),

                    //
                    //
                    // removed label
                    (!(conversation.chatAble ?? false))
                        ? Container(
                            margin: const EdgeInsets.only(left: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Removed',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          )

                        //
                        // last seen
                        : Text(
                            conversation.dateTimeInHumans ?? "",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: (conversation.chatAble ?? false)
                                  ? null
                                  : AppColors.mainColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
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
      ConversationMentionEntity? user = conversation.message?.mentions
          ?.firstWhereOrNull((user) => user.participantId == userId);

      // Replace [~userId] with the user name
      if (user != null) {
        spans.add(TextSpan(
          text: user.user?.name ?? "Unknown",
          style: effectiveTextStyle?.copyWith(
              color: Get.isDarkMode
                  ? Colors.blue
                  : conversation.message?.modelId.toString() == myId
                      ? AppColorsLight.mainColor
                      : Colors.blue), // Change color as needed
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
