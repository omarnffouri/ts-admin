part of '../../chat_detail_view.dart';

class _MentionsSelectionListView extends GetView<ChatDetailController> {
  const _MentionsSelectionListView();

  @override
  Widget build(BuildContext context) {
    // getting theme data
    final ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 14),
      constraints: BoxConstraints(
        maxHeight: 250,
        maxWidth: Get.width * 0.805,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Obx(
        () => Visibility(
          visible: (controller.type == "group") &&
              controller.usersMentioned.isNotEmpty,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Colors.grey.applyOpacity(0.2)
                  : AppColorsLight.mainColor.applyOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            duration: const Duration(milliseconds: 300),
            height: controller.usersMentioned.length == 1
                ? 55
                : controller.usersMentioned.length == 2
                    ? 110
                    : controller.usersMentioned.length == 3
                        ? 165
                        : controller.usersMentioned.length == 4
                            ? 220
                            : 250,
            child: Obx(
              () => ListView.separated(
                shrinkWrap: true,
                itemCount: controller.usersMentioned.length,
                itemBuilder: (_, index) {
                  final user = controller.usersMentioned[index];

                  return GestureDetector(
                    onTap: () => controller.onUserTapped(user),
                    child: Row(
                      children: [
                        ProfileImage.network(
                          url: user.data?.image,
                          width: 30,
                          height: 30,
                        ).marginOnly(right: 10),
                        Expanded(
                          child: Text(
                            user.data?.name ?? "",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ).marginOnly(left: 8, right: 8, top: index == 0 ? 5 : 0),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
