// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/widgets/bubble_menu/app_bubble_menu.dart';
import 'package:ts_admin/app/core/widgets/bubble_menu/bubble.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/views/components/group_settings_tab_bar_item.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/views/tabs/admin_members_tab.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/views/tabs/driver_members_tab.dart';
import 'package:ts_admin/app/modules/chat/presentation/group_settings/views/update_group_name_view.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/group_settings_controller.dart';

class GroupSettingsView extends GetView<GroupSettingsController> {
  const GroupSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Obx(
            () => Visibility(
              visible: controller.iAmAdmin(),
              child: FloatingActionBubble(
                // Menu items
                items: [
                  AppBubbleMenu(
                    Bubble(
                      title: "Add Admin",
                      iconColor: Colors.white,
                      bubbleColor: AppColors.mainColor,
                      icon: Icons.add_rounded,
                      titleStyle:
                          TextStyle(fontSize: 15.sp, color: Colors.white),
                      onPress: () {
                        Get.toNamed(
                          Routes.ADD_ADMIN_PARTICIPANTS,
                          arguments: controller.groupId.value,
                        );
                      },
                    ),
                  ),
                  AppBubbleMenu(
                    Bubble(
                      title: "Add Driver",
                      iconColor: Colors.white,
                      bubbleColor: AppColors.mainColor,
                      icon: Icons.add_rounded,
                      titleStyle:
                          TextStyle(fontSize: 15.sp, color: Colors.white),
                      onPress: () {
                        Get.toNamed(
                          Routes.ADD_DRIVER_PARTICIPANTS,
                          arguments: controller.groupId.value,
                        );
                      },
                    ),
                  ),
                ],
                animation: controller.animation!,
                onPressed: () {
                  controller.onFabButtonClicked();
                },
                iconColor: Colors.white,
                iconData: controller.fabMenuOpened
                    ? Icons.close_rounded
                    : Icons.add_rounded,
                backgroundColor: AppColors.mainColor,
                shape: const CircleBorder(),
              ),
            ),
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowIndicator();
              return true;
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  //
                  //
                  // haeder
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverPersistentHeader(
                      delegate: _GroupProfileHeader(),
                      pinned: true,
                    ),
                  ),

                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    forceElevated: true,
                    title: TabBar(
                      indicator: BoxDecoration(
                        color: AppColors.tabBarIndicatorColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      dividerHeight: 0,
                      controller: controller.tabController,
                      tabs: const [
                        GroupSettingsTabBarItem(tab: GroupSettingsTabs.admins),
                        GroupSettingsTabBarItem(tab: GroupSettingsTabs.drivers),
                      ],
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size(Get.width, 70),
                      child: _buildSearchField(),
                    ),
                  ),
                ];
              },
              body:

                  //
                  //
                  // body
                  TabBarView(
                controller: controller.tabController,
                children: const [
                  AdminMembersTab(),
                  DriverMembersTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            Get.isDarkMode ? Colors.white24 : Colors.white, // Background color
      ),
      child: TextField(
          controller: controller.searchController,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
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

class _GroupProfileHeader extends SliverPersistentHeaderDelegate {
  final controller = Get.find<GroupSettingsController>();

  Tween<double> profilePicTranslateTween =
      Tween<double>(begin: (Get.width / 2) - 45 - 40 + 15, end: 40.0);

  final appBarColorTween = ColorTween(
      begin:
          Get.isDarkMode ? AppColorsDark.scaffoldBackroundColor : Colors.white,
      end: AppColors.mainColor);

  final appbarIconColorTween =
      ColorTween(begin: Colors.black, end: Colors.white);

  final groupNameTranslateYTween = Tween<double>(begin: 20.0, end: 0.0);

  final groupNameTranslateXTween = Tween<double>(begin: 15.0, end: 90.0);

  final groupNameFontSizeTween = Tween<double>(begin: 20.0, end: 18.0);

  final profileImageRadiusTween = Tween<double>(begin: 3.5, end: 1.0);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final relativeScroll = min(shrinkOffset, 145) / 145;

    controller.setHeaderExpantionState(relativeScroll < 0.1);

    return Container(
      color: appBarColorTween.transform(relativeScroll),
      child: Stack(
        children: [
          //
          //
          // back icon
          Positioned(
            left: 0,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 25,
              ),
              color: Get.isDarkMode
                  ? Colors.white
                  : appbarIconColorTween.transform(relativeScroll),
            ),
          ),

          //
          //
          //
          Positioned(
            top: 15,
            left: groupNameTranslateXTween.transform(relativeScroll),
            child: Obx(
              () => SizedBox(
                width: Get.width * (controller.isHeaderExpanded ? 0.93 : 0.70),
                child: displayGroupName(relativeScroll),
              ),
            ),
          ),

          Positioned(
            top: 8,
            left: profilePicTranslateTween.transform(relativeScroll),
            child: displayGroupLogo(relativeScroll),
          ),

          Positioned(
            top: 100,
            left: (Get.width * 0.65) - 25,
            child: Visibility(
              visible:
                  controller.isHeaderExpanded && controller.iAmGroupCreator(),
              child: GestureDetector(
                onTap: () {
                  controller.onUpdateLogoClicked();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.mainColor,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 20,
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ),
          ),

          //
          //
          // ediut group name icons
          Positioned(
            bottom: 15,
            right: 15,
            child: Visibility(
              visible: controller.iAmGroupCreator(),
              child: InkWell(
                onTap: () {
                  Get.to(() => const UpdateGroupNameView());
                },
                child: Icon(
                  Icons.edit,
                  color: Get.isDarkMode
                      ? Colors.white
                      : appbarIconColorTween.transform(relativeScroll),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget displayGroupLogo(double relativeFullScrollOffset) {
    final double scale =
        profileImageRadiusTween.transform(relativeFullScrollOffset);
    return Transform(
      transform: Matrix4.identity()..scaleByDouble(scale, scale, scale, 1),
      child: Obx(
        () => ProfileImage.network(
          url: controller.groupLogo.value,
          width: 40,
          height: 40,
          showLetterOnError: true,
          letter: (controller.groupName.value.isNotEmpty
              ? controller.groupName.value[0].capitalize ?? "G"
              : "G"),
        ),
      ),
    );
  }

  Widget displayGroupName(double relativeFullScrollOffset) {
    final double translateY = groupNameTranslateYTween
        .transform((relativeFullScrollOffset - 0.85) * 7);
    return Transform(
      transform: Matrix4.identity()..translateByDouble(0, translateY, 0, 1),
      child: Obx(
        () => Text(
          controller.groupName.value,
          overflow: TextOverflow.ellipsis,
          maxLines: controller.isHeaderExpanded ? 2 : 1,
          style: TextStyle(
            fontSize:
                groupNameFontSizeTween.transform((relativeFullScrollOffset)),
            color: Get.isDarkMode
                ? Colors.white
                : appbarIconColorTween.transform(relativeFullScrollOffset),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(_GroupProfileHeader oldDelegate) {
    return true;
  }
}
