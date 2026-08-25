import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../controllers/user_detail_view_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class UserDetailViewView extends GetView<UserDetailViewController> {
  const UserDetailViewView({super.key});
  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            //
            //
            // back icon
            Positioned(
              left: 14,
              right: 14,
              top: 10,
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                ),

                //
                //
                const Spacer(),

                //
                //
                // options menu
                if (controller.authController.userPermissionHelper
                    .canUpdateUsers())
                  Obx(
                    () =>

                        //
                        //
                        // if updating user status then show loading indicator

                        controller.isUpdatingUserStatus.value
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeCap: StrokeCap.round,
                                  strokeWidth: 4,
                                ),
                              ).marginAll(12)

                            //
                            //
                            // else show options menu
                            : PopupMenuButton<String>(
                                onSelected: (item) {
                                  //
                                  //
                                  // check and make action
                                  if (item == "update") {
                                    Get.toNamed(
                                      Routes.UPDATE_USER_DETAILS,
                                      arguments: controller.userDetails.value,
                                    );
                                  } else if (item == "reset_password") {
                                    Get.toNamed(
                                      Routes.RESET_USER_PASSWORD,
                                      arguments: controller.userDetails.value,
                                    );
                                  } else if (item == "suspend_user") {
                                    controller.suspendUser();
                                  } else if (item == "active_user") {
                                    controller.activateUser();
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                                shadowColor: Colors.grey,
                                elevation: 10,
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    //
                                    //
                                    // update user option
                                    if (controller
                                        .authController.userPermissionHelper
                                        .canUpdateUsers())
                                      PopupMenuItem<String>(
                                        value: 'update',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                            const Text('Update')
                                                .marginOnly(left: 10),
                                          ],
                                        ),
                                      ),

                                    //
                                    //
                                    // reset user password option
                                    if (controller
                                        .authController.userPermissionHelper
                                        .canUpdateUsers())
                                      PopupMenuItem<String>(
                                        value: 'reset_password',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.lock_person_rounded,
                                              size: 20,
                                            ),
                                            const Text('Reset Password')
                                                .marginOnly(left: 10),
                                          ],
                                        ),
                                      ),

                                    //
                                    //
                                    // suspend user option
                                    if (controller
                                            .authController.userPermissionHelper
                                            .isSuperAdmin() &&
                                        (!(controller.userDetails.value
                                                ?.isSuspended ??
                                            true)))
                                      PopupMenuItem<String>(
                                        value: 'suspend_user',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person_off_rounded,
                                              size: 20,
                                            ),
                                            const Text('Suspend Account')
                                                .marginOnly(left: 10),
                                          ],
                                        ),
                                      ),

                                    //
                                    //
                                    // active user option
                                    if (controller
                                            .authController.userPermissionHelper
                                            .isSuperAdmin() &&
                                        ((controller.userDetails.value
                                                ?.isSuspended ??
                                            false)))
                                      PopupMenuItem<String>(
                                        value: 'active_user',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person_add_alt_rounded,
                                              size: 20,
                                            ),
                                            const Text('Active Account')
                                                .marginOnly(left: 10),
                                          ],
                                        ),
                                      ),
                                  ];
                                },
                              ),
                  ),

                //
                // delete icon
                // GestureDetector(
                //   onTap: () {
                //     Get.toNamed(
                //       Routes.DELETE_USER,
                //       arguments: controller.userDetails.value,
                //     );
                //   },
                //   child: const Icon(
                //     Icons.delete_forever_rounded,
                //     size: 25,
                //     color: Colors.white,
                //   ),
                // )
              ]),
            ),

            //
            //
            // data container
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? theme.scaffoldBackgroundColor
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Obx(
                  () => controller.currentTab.value == ProfileTabs.personal
                      ? const _PersonalTab()
                      : const _WorkTab(),
                ),
              ),
            ),

            //
            //
            // profile header card
            Positioned(
              top: 75,
              right: 20,
              left: 20,
              child: Container(
                constraints: const BoxConstraints(minHeight: 150),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? theme.scaffoldBackgroundColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Get.isDarkMode
                        ? Colors.white.applyOpacity(0.2)
                        : Colors.grey.applyOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    //
                    //
                    // status
                    Row(
                      children: [
                        const Spacer(),
                        //
                        //
                        // status view
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:
                                  controller.userDetails.value?.isSuspended ??
                                          false
                                      ? Colors.orange
                                      : Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "${controller.userDetails.value?.status?.capitalizeFirst}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ).marginOnly(bottom: 20),

                    //
                    // name
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (controller.userDetails.value?.name ?? ""),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),

                    //
                    // phone
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (controller.userDetails.value?.phone ?? ""),
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),

                    Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Get.isDarkMode
                          ? Colors.white.applyOpacity(0.2)
                          : Colors.grey.applyOpacity(0.2),
                    ),

                    //
                    // buttons
                    Row(
                      children: [
                        Obx(
                          () => Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.currentTab.value =
                                    ProfileTabs.personal;
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: !Get.isDarkMode
                                      ? controller.currentTab.value ==
                                              ProfileTabs.personal
                                          ? Colors.black12
                                          : Colors.white10
                                      : controller.currentTab.value ==
                                              ProfileTabs.personal
                                          ? Colors.white24
                                          : Colors.black12,
                                ),
                                child: Center(
                                  child: Text(
                                    "Personal",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: controller.currentTab.value ==
                                              ProfileTabs.personal
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            color: Get.isDarkMode
                                ? Colors.white.applyOpacity(0.2)
                                : Colors.grey.applyOpacity(0.2),
                          ),
                        ),
                        Obx(
                          () => Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.currentTab.value = ProfileTabs.work;
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: !Get.isDarkMode
                                      ? controller.currentTab.value ==
                                              ProfileTabs.work
                                          ? Colors.black12
                                          : Colors.white10
                                      : controller.currentTab.value ==
                                              ProfileTabs.work
                                          ? Colors.white24
                                          : Colors.black12,
                                ),
                                child: Center(
                                  child: Text(
                                    "Work",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: controller.currentTab.value ==
                                              ProfileTabs.work
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //
            //
            // profile image
            Positioned(
              top: 25,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: Get.isDarkMode
                          ? Colors.white.applyOpacity(0.2)
                          : Colors.white,
                    ),
                  ),
                  child: ProfileImage.network(
                    url: controller.userDetails.value?.image,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalTab extends GetView<UserDetailViewController> {
  const _PersonalTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          const SizedBox(
            height: 120,
          ),

          _InfoCard(
            icon: Icon(
              Icons.label,
              size: 20,
              color: Get.isDarkMode ? Colors.white : Colors.grey,
            ),
            title: "Name",
            text: controller.userDetails.value?.name ?? "",
          ).marginOnly(left: 14, right: 14, top: 15),

          _InfoCard(
            icon: Icon(
              Icons.email_rounded,
              size: 20,
              color: Get.isDarkMode ? Colors.white : Colors.grey,
            ),
            title: "Email",
            text: controller.userDetails.value?.email ?? "",
          ).marginOnly(left: 14, right: 14, top: 15),

          _InfoCard(
            icon: Icon(
              Icons.phone_android_rounded,
              size: 20,
              color: Get.isDarkMode ? Colors.white : Colors.grey,
            ),
            title: "Phone",
            text: controller.userDetails.value?.phone ?? "",
          ).marginOnly(left: 14, right: 14, top: 15),

          _InfoCard(
            icon: Icon(
              Icons.date_range_rounded,
              size: 20,
              color: Get.isDarkMode ? Colors.white : Colors.grey,
            ),
            title: "DOB",
            text: controller.userDetails.value?.birthDate ?? "",
          ).marginOnly(left: 14, right: 14, top: 15),

          _InfoCard(
            icon: Icon(
              Icons.location_city_rounded,
              size: 20,
              color: Get.isDarkMode ? Colors.white : Colors.grey,
            ),
            title: "Address",
            text: controller.userDetails.value?.address ?? "",
          ).marginOnly(left: 14, right: 14, top: 15),
          //
        ],
      ),
    );
  }
}

class _WorkTab extends GetView<UserDetailViewController> {
  const _WorkTab();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          const SizedBox(
            height: 120,
          ),

          if (controller.userDetails.value?.department != null)
            _InfoCard(
              icon: Icon(
                Icons.account_tree_rounded,
                size: 20,
                color: Get.isDarkMode ? Colors.white : Colors.grey,
              ),
              title: "Department",
              text: controller.userDetails.value?.department?.name ?? "",
            ).marginOnly(left: 14, right: 14, top: 20),

          //
          //
          //
          if (controller.userDetails.value?.designation != null)
            _InfoCard(
              icon: Icon(
                Icons.badge_rounded,
                size: 20,
                color: Get.isDarkMode ? Colors.white : Colors.grey,
              ),
              title: "Designation",
              text: controller.userDetails.value?.designation?.name ?? "",
            ).marginOnly(left: 14, right: 14, top: 20),

          //
          //
          // roles
          if (controller.userDetails.value?.roles?.isNotEmpty ?? false)
            Container(
              margin: const EdgeInsets.only(left: 14, right: 14, top: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? theme.scaffoldBackgroundColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Get.isDarkMode
                      ? Colors.white.applyOpacity(0.2)
                      : Colors.grey.applyOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //
                  Image.asset(
                    Assets.icons.roles.path,
                    width: 20,
                    height: 20,
                    color: Get.isDarkMode ? Colors.white : Colors.grey,
                  ),

                  //
                  //
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Roles",
                              style: theme.textTheme.titleMedium,
                            )
                          ],
                        ),
                        GridView.builder(
                          primary: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                            mainAxisExtent: 50,
                            crossAxisSpacing: 20,
                          ),
                          shrinkWrap: true,
                          itemCount:
                              controller.userDetails.value?.roles?.length ?? 0,
                          itemBuilder: (context, index) {
                            final role =
                                controller.userDetails.value?.roles![index];

                            //
                            // list item
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                role?.name?.capitalizeFirst ?? "",
                                style: theme.textTheme.bodyMedium,
                              ),
                              activeColor: AppColorsLight.mainColor,
                              checkColor: Colors.white,
                              value: true,
                              controlAffinity: ListTileControlAffinity.platform,
                              onChanged: (value) {},
                            );
                          },
                        )
                      ],
                    ).marginOnly(left: 5),
                  ),
                ],
              ),
            ),

          //
          //
          // permissions
          if (controller.userDetails.value?.permissions?.isNotEmpty ?? false)
            Container(
              margin: const EdgeInsets.only(left: 14, right: 14, top: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? theme.scaffoldBackgroundColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Get.isDarkMode
                        ? Colors.white.applyOpacity(0.2)
                        : Colors.grey.applyOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //
                  Icon(
                    Icons.key,
                    size: 20,
                    color: Get.isDarkMode ? Colors.white : Colors.grey,
                  ),

                  //
                  //
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Permisions",
                              style: theme.textTheme.titleMedium,
                            )
                          ],
                        ),
                        GridView.builder(
                          primary: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                            mainAxisExtent: 50,
                            crossAxisSpacing: 20,
                          ),
                          shrinkWrap: true,
                          itemCount: controller
                                  .userDetails.value?.permissions?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final permission = controller
                                .userDetails.value?.permissions![index];

                            //
                            // list item
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                permission?.name?.capitalizeFirst ?? "",
                                style: theme.textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              activeColor: AppColorsLight.mainColor,
                              checkColor: Colors.white,
                              value: true,
                              controlAffinity: ListTileControlAffinity.platform,
                              onChanged: (value) {},
                            );
                          },
                        )
                      ],
                    ).marginOnly(left: 5),
                  ),
                ],
              ),
            ),

          //
          //
          //
          //
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String text;
  const _InfoCard(
      {required this.title, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? theme.scaffoldBackgroundColor : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Get.isDarkMode
              ? Colors.white.applyOpacity(0.2)
              : Colors.grey.applyOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) icon!,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          text,
                          style: theme.textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                ],
              ).marginOnly(left: icon != null ? 5 : 0),
            ),
          ],
        ),
      ),
    );
  }
}
