import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/modules/chat/presentation/contacts/views/contacts_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/views/components/chat_tab_bar_item.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_conversations/views/group_conversations_view.dart';
import 'package:ts_admin/app/modules/chat/presentation/oto_conversations/views/oto_conversations_view.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/conversations_controller.dart';

class ConversationsView extends GetView<ConversationsController> {
  const ConversationsView({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Color primaryColor = theme.primaryColor;
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    final double topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            AppRedHeader(
              padding: EdgeInsets.fromLTRB(16.w, topInset, 16.w, 14.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Messages",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Obx(
                              () => Text(
                                controller.authController.user.value
                                        ?.designation?.name ??
                                    "Stay connected with your team",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.applyOpacity(0.82),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    height: 48.h,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.white.applyOpacity(0.15),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: Colors.white.applyOpacity(0.20),
                      ),
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      dividerHeight: 0,
                      labelPadding: EdgeInsets.zero,
                      splashBorderRadius: BorderRadius.circular(14.r),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: !Get.isDarkMode ? Colors.white : null,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .applyOpacity(!Get.isDarkMode ? 0.12 : 0.14),
                            blurRadius: !Get.isDarkMode ? 8 : 18,
                            offset: Offset(0, !Get.isDarkMode ? 3 : 8),
                          ),
                        ],
                      ),
                      labelColor: !Get.isDarkMode
                          ? AppColorsLight.mainColor
                          : AppColorsLight.white,
                      unselectedLabelColor: !Get.isDarkMode
                          ? Colors.white.applyOpacity(0.9)
                          : Colors.grey.applyOpacity(0.9),
                      labelStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        ChatTabBarItem(
                            tab: ConversationTabs.chat, label: "Chat"),
                        ChatTabBarItem(
                            tab: ConversationTabs.group, label: "Groups"),
                        ChatTabBarItem(
                            tab: ConversationTabs.contacts, label: "Contacts"),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  const _ChatSearchField(),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.r),
                  bottomRight: Radius.circular(25.r),
                ),
                child: TabBarView(
                  controller: controller.tabController,
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    OtoConversationsView(),
                    GroupConversationsView(),
                    ContactsView(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        final bool show =
            controller.currentTab.value == ConversationTabs.group &&
                controller.authController.userPermissionHelper.canCreateGroup();
        return Padding(
          padding: const EdgeInsets.only(bottom: 65),
          child: AnimatedScale(
            scale: show ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: show ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 160),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColorsLight.mainColorDark,
                      AppColorsLight.mainColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsLight.mainColor.applyOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Get.toNamed(Routes.CREATE_GROUP),
                    child: const Center(
                      child: Icon(Icons.add_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

//! Search field
class _ChatSearchField extends GetView<ConversationsController> {
  const _ChatSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.applyOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.applyOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColorsLight.white.applyOpacity(0.7),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColorsLight.mainColor,
              style: const TextStyle(
                color: AppColorsLight.textColor,
                fontSize: 14,
              ),
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "Search by name",
                hintStyle: TextStyle(
                  color: AppColorsLight.white.applyOpacity(0.7),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.searchTextController,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () => controller.searchTextController.clear(),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColorsLight.textColor.applyOpacity(0.7),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
