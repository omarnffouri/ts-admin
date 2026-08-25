// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/forward_message/controllers/forward_message_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ForwardMessageGroupsTabView extends GetView<ForwardMessageController> {
  const ForwardMessageGroupsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return Obx(
          () => controller.groupConversations.isEmpty
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Group Conversation Yet...!"),
                  ],
                ).paddingOnly(top: 150)
              : ListView.separated(
                  itemCount: controller.isSearchEnabled.value
                      ? controller.filteredGroupConversations.length
                      : controller.groupConversations.length,
                  itemBuilder: (BuildContext context, int index) {
                    final GroupConversationEntity conversation = controller
                            .isSearchEnabled.value
                        ? controller.filteredGroupConversations.elementAt(index)
                        : controller.groupConversations.elementAt(index);
                    return _GroupConversationTile(
                      index: index,
                      conversation: conversation,
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
                ),
        );
      },
    );
  }
}

class _GroupConversationTile extends GetView<ForwardMessageController> {
  final int index;

  final GroupConversationEntity conversation;

  final myId = GetStorage().read(UserPrefKeys.userId).toString();

  _GroupConversationTile({
    required this.index,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (conversation.conversations?.isNotEmpty ?? false) {
          if (conversation.conversations!.length == 1) {
            controller
                .onGroupConversationTap(conversation.conversations![0].id);
            return;
          }
          controller.clearInnerSearch(conversation.conversations ?? []);
          controller.isInnerSearchEnabled(false);
          if (controller.expandedGroupHead.value == index) {
            controller.expandedGroupHead.value = -1;
          } else {
            controller.expandedGroupHead.value = index;
          }
        }
      },
      child: Obx(
        () => AnimatedContainer(
          margin: index == 0
              ? const EdgeInsets.only(left: 1, right: 1, top: 14)
              : index == (controller.groupConversations.length - 1)
                  ? const EdgeInsets.only(left: 1, right: 1, bottom: 14)
                  : const EdgeInsets.symmetric(horizontal: 1),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
              color: controller.expandedGroupHead.value == index
                  ? Colors.grey.applyOpacity(0.2)
                  : null,
              borderRadius: BorderRadius.circular(20)),
          height: controller.expandedGroupHead.value == index ? 400 : 75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: CachedNetworkImageProvider(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                        ),
                        width: 45,
                        height: 45,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //
                          // group name and unread count row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  conversation.name ?? "",
                                  style: theme.textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Obx(
                                () => Visibility(
                                  visible: controller.isGroupSelected(
                                      conversation.conversations ?? []),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.done_rounded,
                                        color: AppColorsLight.mainColor,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            color: theme.primaryColor,
                                            shape: BoxShape.circle),
                                        child: Text(
                                          controller
                                              .groupInnerConversationsSelectedCount(
                                                  conversation.conversations ??
                                                      [])
                                              .toString(),
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ).marginOnly(left: 10, right: 5),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //
                          // no of conversations . add participant and options row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${conversation.conversations?.length ?? 0} Conversation${(conversation.conversations?.length ?? 0) > 1 ? 's' : ''}",
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              //
                              // search icon
                              if (controller.expandedGroupHead.value == index)
                                GestureDetector(
                                  onTap: () {
                                    controller.isInnerSearchEnabled.toggle();
                                    controller.clearInnerSearch(
                                        conversation.conversations ?? []);
                                  },
                                  child: Icon(
                                    controller.isInnerSearchEnabled.value
                                        ? Icons.search_off
                                        : Icons.search,
                                    size: 24,
                                  ),
                                ).paddingOnly(right: 20),

                              //
                              // drop down icon
                              if ((conversation.conversations?.length ?? 0) > 1)
                                Icon(controller.expandedGroupHead.value == index
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (controller.isInnerSearchEnabled.value &&
                  controller.expandedGroupHead.value == index)
                // search field
                Container(
                  margin: const EdgeInsets.only(left: 45, right: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode
                        ? Colors.black54
                        : Colors.grey[350], // Background color
                  ),
                  child: TextField(
                      controller: controller.innerSearchTextController,
                      maxLines: 1,
                      onChanged: (value) {
                        controller
                            .applyInnerSearch(conversation.conversations ?? []);
                      },
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.all(0),
                        hintText: "Search by name...",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder:
                            InputBorder.none, // Remove the default border
                        icon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.clearInnerSearch(
                                conversation.conversations ?? []);
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ) // Optional icon
                      ),
                ),

              //
              if (controller.expandedGroupHead.value == index &&
                  (conversation.conversations?.isNotEmpty ?? false))
                Expanded(
                  child: Obx(
                    () => controller.isInnerSearchEnabled.value
                        ? _buildSearchListView()
                        : _buildNormalListView(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalListView() {
    final normalInnerConversations =
        (conversation.conversations?.isNotEmpty ?? false)
            ? conversation.conversations!
            : [];

    return ListView.separated(
      itemCount: normalInnerConversations.length,
      itemBuilder: (BuildContext context, int index) {
        final GroupConversationConversationEntity conversationInner =
            normalInnerConversations.elementAt(index);
        return _InnerConversationTile(
            index: index,
            conversation: conversationInner,
            groupName: conversation.name ?? "Group");
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
    ).paddingOnly(left: 45);
  }

  Widget _buildSearchListView() {
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        itemCount: controller.filteredInnerConversations.length,
        itemBuilder: (BuildContext context, int index) {
          final GroupConversationConversationEntity conversationInner =
              controller.filteredInnerConversations.elementAt(index);
          return _InnerConversationTile(
              index: index,
              conversation: conversationInner,
              groupName: conversation.name ?? "Group");
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
      ).paddingOnly(left: 45),
    );
  }
}

class _InnerConversationTile extends GetView<ForwardMessageController> {
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

    // final myId = GetStorage().read(UserPrefKeys.userId).toString();

    // String messageString = "";
    // if (conversation.message?.modelId.toString() == myId) {
    //   messageString += "You: ";
    // }
    // if (conversation.message?.media?.isNotEmpty ?? false) {
    //   messageString += "media 📎";
    // } else if ((conversation.message?.message != null) &&
    //     (conversation.message?.message != "null")) {
    //   messageString += (conversation.message?.message ?? "");
    // }

    return InkWell(
      onTap: () async {
        controller.onGroupConversationTap(conversation.id);
      },
      child: Container(
        margin: index == 0
            ? const EdgeInsets.only(left: 1, right: 1, top: 14)
            : index == (controller.groupConversations.length - 1)
                ? const EdgeInsets.only(left: 1, right: 1, bottom: 14)
                : const EdgeInsets.symmetric(horizontal: 1),
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: theme.primaryColor
                      .applyOpacity(Get.isDarkMode ? 0.5 : 0.1),
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Text(
                  conversation.name?[0].toUpperCase() ?? "",
                  style: theme.textTheme.labelLarge?.copyWith(
                      color: Get.isDarkMode ? null : AppColorsLight.mainColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name ?? "",
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
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
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "",
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.selectedGroupConversations
                    .contains(conversation.id),
                child: const Icon(
                  Icons.done_rounded,
                  color: AppColorsLight.mainColor,
                ),
              ),
            ).marginOnly(left: 10, right: 5),
          ],
        ),
      ),
    );
  }
}
