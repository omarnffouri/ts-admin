import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/helpers/chat_navigation.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/views/components/chat_empty_state.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/group_conversations_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

// part 'components/group_conversation_tile.dart';
// part 'components/inner_conversation_tile.dart';

class GroupConversationsView extends GetView<GroupConversationsController> {
  const GroupConversationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ((controller.isLoadingGroupHeads &&
                  controller.isGroupConversationsListEmptyFromDatabase) ||
              controller.isLoadingGroupConversationsFromDatabase)
          ? const _LoadingView()
          : Column(
              children: [
                // search field
                // Container(
                //   margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                //   padding: const EdgeInsets.symmetric(horizontal: 8),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Get.isDarkMode
                //         ? Colors.black54
                //         : Colors.grey[300], // Background color
                //   ),
                //   child: TextField(
                //       controller: controller.searchTextController,
                //       maxLines: 1,
                //       decoration: InputDecoration(
                //         // contentPadding: EdgeInsets.all(0),
                //         hintText: "Search group by name",
                //         border: InputBorder.none,
                //         focusedBorder: InputBorder.none,
                //         errorBorder: InputBorder.none,
                //         enabledBorder: InputBorder.none,
                //         disabledBorder: InputBorder.none,
                //         focusedErrorBorder:
                //             InputBorder.none, // Remove the default border
                //         icon: const Icon(
                //           Icons.search,
                //           color: Colors.grey,
                //         ),
                //         suffixIcon: GestureDetector(
                //           onTap: () {
                //             controller.clearSearch();
                //           },
                //           child: const Icon(
                //             Icons.close_rounded,
                //             color: Colors.grey,
                //           ),
                //         ),
                //       ) // Optional icon
                //       ),
                // ),

                //
                //
                // body or list
                Expanded(
                  child: SlidableAutoCloseBehavior(
                    child: Obx(
                      () => SmartRefresher(
                        controller: controller.refreshController,
                        header: const WaterDropMaterialHeader(),
                        onRefresh: () async {
                          if (controller.isLoadingGroupHeads) {
                            return;
                          }
                          await controller.getGroupHeads();
                          controller.refreshController.refreshCompleted();
                        },
                        child: controller.groupConversations.isEmpty
                            ? const ChatEmptyState(
                                icon: Icons.groups_2_outlined,
                                title: "No groups yet",
                                subtitle:
                                    "Your group conversations will appear here",
                              )
                            : ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                itemCount: controller.isSearchEnabled.value
                                    ? controller
                                        .filteredGroupConversations.length
                                    : controller.groupConversations.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final GroupConversationEntity conversation =
                                      controller.isSearchEnabled.value
                                          ? controller
                                              .filteredGroupConversations
                                              .elementAt(index)
                                          : controller.groupConversations
                                              .elementAt(index);
                                  return _GroupConversationTile(
                                    index: index,
                                    conversation: conversation,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 80.w,
                                    endIndent: 16.w,
                                    color: Colors.grey.applyOpacity(0.12),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
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

class _GroupConversationTile extends GetView<GroupConversationsController> {
  final int index;

  final GroupConversationEntity conversation;

  final myId = GetStorage().read(UserPrefKeys.userId).toString();

  final isViewingArchive = false.obs;

  _GroupConversationTile({
    required this.index,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    bool iAmParticipant = true;
    bool iAmAdmin = false;
    //
    // check for mute state
    bool haveMutedConversation =
        conversation.conversations?.firstWhereOrNull((item) {
              return item.notificationMuted ?? false;
            }) !=
            null;

    if ((conversation.conversations ?? []).isNotEmpty) {
      iAmParticipant = conversation.conversations?.firstWhereOrNull((item) {
            //
            // participants list empty means i am not in participanst
            if ((item.participants ?? []).isEmpty) {
              return false;
            }

            //
            // find current user in participants
            final participant = item.participants!.firstWhereOrNull(
                (participant) =>
                    (participant.id?.toString() == controller.myId) &&
                    (participant.modelType == ModelType.USERS));

            if (participant != null) {
              iAmAdmin = participant.isGroupAdmin ?? false;
              return true;
            } else {
              return false;
            }
          }) !=
          null;
    }

    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      groupTag: "group_conversations_slide_group",
      endActionPane: ActionPane(
        extentRatio: iAmAdmin && iAmParticipant ? 0.5 : 0.3,
        motion: const BehindMotion(),
        children: [
          //
          //
          // group settings option
          if (iAmAdmin && iAmParticipant)
            SlidableAction(
              onPressed: (context) {
                if (conversation.groupSettings == null ||
                    (conversation.conversations ?? []).isEmpty) {
                  return;
                }
                Get.toNamed(
                  Routes.GROUP_SETTINGS,
                  arguments: conversation.id,
                );
              },
              backgroundColor: AppColorsLight.mainColor,
              foregroundColor: Colors.white,
              icon: Icons.settings_rounded,
              label: 'Settings',
            ),

          //
          //
          // mute option
          SlidableAction(
            onPressed: (context) {
              if (haveMutedConversation) {
                controller.unmuteGroup(conversation, index);
              } else {
                controller.muteGroup(conversation, index);
              }
            },
            backgroundColor: AppColorsLight.mainColor,
            foregroundColor: Colors.white,
            icon: haveMutedConversation
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            label: haveMutedConversation ? 'Unmute' : 'Mute',
          )
        ],
      ),
      child: InkWell(
        onTap: () async {
          //
          // if group details etc null then refesh group details
          if ((conversation.conversations == null) &&
              (conversation.id != null)) {
            controller.refreshGroupDetails(conversation.id!);
            return;
          }

          // by clearing inner search here makes to show full list when first
          // user click on search bar or icons for enabling search
          if (conversation.conversations?.length == 1 &&
              !conversation.haveOngoingCall) {
            await ChatNavigation.open({
              'type': "group",
              'userPhone': (conversation.conversations![0].participants
                          ?.map((e) => e.id.toString() == myId.toString()
                              ? "You"
                              : e.name)
                          .toString() ??
                      "")
                  .replaceAll("(", "")
                  .replaceAll(")", ""),
              'userImage': "",
              'userName': conversation.name ?? "",
              'group_name': conversation.name ?? "",
              'modelType': "",
              'conversation_id': conversation.conversations![0].id,
              'chatable': conversation.conversations![0].chatAble,
              'i_am_participant': conversation.conversations![0].participants
                      ?.firstWhereOrNull((element) {
                    return element.id.toString() == myId;
                  }) !=
                  null,
              'messages': null,
              'groupId': conversation.id,
            });
          } else {
            if ((conversation.name ?? "").isNotEmpty) {
              Get.toNamed(
                Routes.GROUP_INNER_CONVERSATIONS,
                arguments: conversation.id,
              );
            }
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          foregroundDecoration: iAmParticipant
              ? null
              : RotatedCornerDecoration.withColor(
                  color: AppColors.mainColor,
                  spanBaselineShift: 1,
                  badgeSize: const Size(20, 20),
                  badgeCornerRadius: const Radius.circular(8),
                  badgePosition: BadgePosition.topStart,
                ),
          child: Row(
            children: [
              //
              //
              // group logo
              GestureDetector(
                onTap: () {
                  if ((conversation.groupSettings?.logo ?? '').isNotEmpty) {
                    showImageDialog(
                      context,
                      conversation.groupSettings?.logo ?? "",
                    );
                  }
                },
                child: ProfileImage.network(
                  url: conversation.groupSettings?.logo,
                  width: 52,
                  height: 52,
                  showLetterOnError: true,
                  letter: ((conversation.name ?? "").isNotEmpty
                      ? conversation.name![0].capitalize ?? "G"
                      : "G"),
                ),
              ).marginOnly(right: 12),

              //
              //
              // group name etc
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //
                    //
                    // group name
                    Row(
                      children: [
                        //
                        // group name
                        Expanded(
                          child: Text(
                            conversation.name ?? "",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  iAmParticipant ? null : AppColors.mainColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    //
                    //
                    // no of conversations . and ongoig call indication
                    Row(
                      children: [
                        //
                        // ongoing call icon
                        if (conversation.haveOngoingCall)
                          const Icon(
                            Icons.call,
                            size: 15,
                            color: Colors.green,
                          ),

                        //
                        // ongoing call text
                        if (conversation.haveOngoingCall)
                          const Text(
                            "Ongoing Call...",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ).marginOnly(left: 5),

                        //
                        // conversations text
                        if (!conversation.haveOngoingCall)
                          Expanded(
                            child: Text(
                              "${conversation.conversationsCount ?? 0} Conversation${(conversation.conversations?.length ?? 0) > 1 ? 's' : ''}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    iAmParticipant ? null : AppColors.mainColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // progress bar indicating syncing
                  Obx(
                    () => Visibility(
                      visible: conversation.isLoadingSubGroups.value,
                      child: SizedBox(
                        width: 50,
                        child: LinearProgressIndicator(
                          color: AppColorsLight.mainColor,
                          backgroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Row(
                    children: [
                      //
                      // unread counts
                      if ((conversation.unreadCount != null) &&
                          (conversation.unreadCount != 0))
                        Container(
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
                                visible: haveMutedConversation,
                                child: const Icon(
                                  Icons.volume_off_rounded,
                                  size: 20,
                                  color: AppColorsLight.mainColor,
                                ).marginOnly(left: 10),
                              ),
                      ),
                    ],
                  ),

                  //
                  //
                  // removed tag
                  if (!iAmParticipant)
                    Container(
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
                    ),
                ],
              ),

              //
              // next icon
              ((conversation.conversations?.length ?? 0) > 1)
                  ? const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                    ).marginOnly(left: 5)
                  : const SizedBox(
                      width: 20,
                    ).marginOnly(left: 5)
            ],
          ),
        ),
      ),
    );
  }
}
