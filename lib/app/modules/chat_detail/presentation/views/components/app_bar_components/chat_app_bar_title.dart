part of '../../chat_detail_view.dart';

class _ChatAppBarTitle extends GetView<ChatDetailController> {
  const _ChatAppBarTitle();

  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);

    return Obx(
      () => controller.isSearchEnabled.value
          //
          // search field
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode
                    ? Colors.white10
                    : Colors.grey[300], // Background color
              ),
              child: TextField(
                controller: controller.searchController,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.all(0),
                  hintText: "Enter text",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffix: Obx(
                    () => Visibility(
                      visible: controller.isLoadingPreviousMessagesFromDB ||
                          controller.isLoadingPreviousMessagesFromApi,
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )

          //
          // group or user name
          : GestureDetector(
              onTap: () {
                if (controller.type == "group") {
                  controller.showParticipantsBottomSheet();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (Get.width > 500) addHorizontalSpace(10.w),
                  Obx(
                    () => ProfileImage.network(
                      url: controller.type == "group" &&
                              controller.groupImage.value.isNotEmpty
                          ? controller.groupImage.value
                          : controller.userImage.value,
                      width: 45,
                      height: 45,
                      showLetterOnError: true,
                      letter: controller.type == "group"
                          ? controller.groupName.isNotEmpty
                              ? controller.groupName[0].capitalize
                              : "G"
                          : controller.userName.value.isNotEmpty
                              ? controller.userName.value[0].capitalize
                              : "",
                    ),
                  ),
                  addHorizontalSpace(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.type == "group"
                              ? controller.groupName
                              : controller.userName.value,
                          maxLines: 1,
                          style: theme.textTheme.bodyLarge,
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Visibility(
                                visible: (!controller.isTyping) &&
                                    (controller.type != "group"),
                                child: Icon(
                                  Icons.circle,
                                  color: Get.put<ConversationsController>(
                                              ConversationsController())
                                          .isUserOnline(controller.receiverId,
                                              controller.receiverModelType)
                                      ? AppColorsLight.onlineColor
                                      : AppColorsLight.offlineColor,
                                  size: 10,
                                ),
                              ),
                            ),
                            Obx(
                              () => Expanded(
                                child: Text(
                                  controller.isTyping
                                      ? controller.typingMessage
                                      : controller.type != "group"
                                          ? (Get.find<ConversationsController>()
                                                  .isUserOnline(
                                                      controller.receiverId,
                                                      controller
                                                          .receiverModelType))
                                              ? "Online"
                                              : "Offline"
                                          : (controller.userName.value !=
                                                  controller.groupName)
                                              ? controller.userName.value
                                              : "",
                                  style: TextStyle(
                                    color: controller.isTyping
                                        ? AppColorsLight.mainColor
                                        : theme.textTheme.bodyLarge?.color,
                                    fontSize: 14,
                                  ),
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
    );
  }
}
