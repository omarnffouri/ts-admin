// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

import 'package:ts_admin/app/modules/chat/domain/entities/conversation_entity.dart';
import 'package:ts_admin/app/modules/forward_message/controllers/forward_message_controller.dart';

class ForwardMessageChatsTabView extends GetView<ForwardMessageController> {
  const ForwardMessageChatsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(
              () => controller.conversations.isEmpty
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Conversation Yet...!"),
                      ],
                    ).paddingOnly(top: 150)
                  : controller.isSearchEnabled.value
                      ? _buildSearchListView()
                      : _buildNormalListView(),
            ),
          ),
        ],
      );
    });
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

  Widget _buildNormalListView() {
    return ListView.separated(
      itemCount: controller.conversations.length,
      itemBuilder: (BuildContext context, int index) {
        final ConversationEntity conversation =
            controller.conversations.elementAt(index);
        return _ConversationTile(
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
    );
  }
}

class _ConversationTile extends GetView<ForwardMessageController> {
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
        controller.onConversationTap(conversation.id);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: CachedNetworkImageProvider(
                    conversation.user?.image ??
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                  ),
                  width: 45,
                  height: 45,
                  errorBuilder: (context, error, stackTrace) => const Image(
                    image: CachedNetworkImageProvider(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                    ),
                    width: 45,
                    height: 45,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.user?.name ?? "",
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                          // messageString,
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
                visible:
                    controller.selectedConversations.contains(conversation.id),
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
