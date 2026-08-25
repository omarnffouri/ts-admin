part of '../message_notifications_view.dart';

class _MessageNotificationsHeader
    extends GetView<MessageNotificationsController> {
  const _MessageNotificationsHeader();

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      padding: EdgeInsets.fromLTRB(12, topInset + 10, 12, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () {
                  Get.back();
                },
              ).marginOnly(right: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Message Notifications",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () {
                        final unreadCount = controller.messagesNotifications
                            .where((item) => !item.read.value)
                            .length;
                        return Text(
                          unreadCount == 0
                              ? 'All messages are up to date'
                              : '$unreadCount unread alert${unreadCount == 1 ? '' : 's'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.applyOpacity(0.82),
                            fontWeight: FontWeight.w500,
                            height: 1.15,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Obx(
                () => _HeaderIconButton(
                  icon: controller.isSearchEnabled
                      ? Icons.close_rounded
                      : Icons.search_rounded,
                  isActive: controller.isSearchEnabled,
                  onTap: () {
                    if (controller.isSearchEnabled) {
                      controller.txtSearchController.clear();
                    }
                    controller.toggleSearch();
                  },
                ),
              ),
            ],
          ),
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              child: controller.isSearchEnabled
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _buildSearchPanel(),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPanel() {
    final theme = Get.theme;

    return GlassPanel(
      radius: 18,
      blur: 14,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 42,
            child: Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColorsLight.white.applyOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: AppColorsLight.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller.txtSearchController,
                    cursorColor: AppColorsLight.mainColor,
                    maxLines: 1,
                    onChanged: controller.handleSearchChange,
                    onTapOutside: (_) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Search notifications",
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.5, color: Colors.white54),
                      ),
                      errorBorder: InputBorder.none,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.5, color: Colors.white54),
                      ),
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _SearchTypeSegmentedControl(),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white.applyOpacity(isActive ? 0.22 : 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.applyOpacity(isActive ? 0.34 : 0.08),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _SearchTypeSegmentedControl
    extends GetView<MessageNotificationsController> {
  const _SearchTypeSegmentedControl();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 34,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColorsLight.white.applyOpacity(0.50)),
        ),
        child: Row(
          children: [
            _SearchTypeSegment(
              label: "One to One",
              icon: Icons.person_rounded,
              selected: controller.selectedSearchType.value ==
                  MessageNotificationSearchTypes.oto,
              onTap: () {
                controller.selectedSearchType.value =
                    MessageNotificationSearchTypes.oto;
              },
            ),
            _SearchTypeSegment(
              label: "Groups",
              icon: Icons.groups_2_rounded,
              selected: controller.selectedSearchType.value ==
                  MessageNotificationSearchTypes.group,
              onTap: () {
                controller.selectedSearchType.value =
                    MessageNotificationSearchTypes.group;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchTypeSegment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SearchTypeSegment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected
                ? Get.isDarkMode
                    ? Colors.transparent
                    : AppColorsLight.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: selected
                  ? AppColorsLight.senderCallColor.applyOpacity(0.35)
                  : Colors.transparent,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: selected
                      ? Get.isDarkMode
                          ? Colors.white
                          : AppColorsLight.mainColor
                      : Get.isDarkMode
                          ? Colors.grey
                          : Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0,
                      color: selected
                          ? Get.isDarkMode
                              ? Colors.white
                              : AppColorsLight.mainColor
                          : Get.isDarkMode
                              ? Colors.grey
                              : Colors.white,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      height: 1,
                    ),
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
