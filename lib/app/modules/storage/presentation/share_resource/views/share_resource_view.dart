import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/storage_users_entity.dart';

import '../controllers/share_resource_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ShareResourceView extends GetView<ShareResourceController> {
  const ShareResourceView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              //
              //
              // header
              const _Header(),

              //
              //
              // body
              Expanded(
                child: Obx(
                  () => SmartRefresher(
                    controller: controller.refreshController,
                    header: const WaterDropMaterialHeader(),
                    onRefresh: () async {
                      await controller.getUsers();
                      controller.refreshController.refreshCompleted();
                    },
                    child:

                        //
                        //
                        // if loading users from the api
                        controller.isLoadingUsersList
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeCap: StrokeCap.round,
                                  color: AppColors.mainColor,
                                  strokeWidth: 5,
                                ),
                              )

                            //
                            // if all users are already added then show this message
                            : controller.alreadySharedWithAllUsers
                                ? Center(
                                    child: Text(
                                      "Already shared with all users.",
                                      style: theme.textTheme.labelLarge,
                                    ),
                                  )
                                //
                                // if  users is empty then show this message
                                : controller.users.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No user found.",
                                          style: theme.textTheme.labelLarge,
                                        ),
                                      )

                                    //
                                    // showing message for no result in search
                                    : (controller.isSearchEnabled &&
                                            controller.filteredUsers.isEmpty)
                                        ? Center(
                                            child: Text(
                                              "No Result",
                                              style: theme.textTheme.labelLarge,
                                            ),
                                          )
                                        : ListView.separated(
                                            itemCount: (controller
                                                        .isSearchEnabled
                                                    ? controller.filteredUsers
                                                    : controller.users)
                                                .length,
                                            itemBuilder: (context, index) {
                                              final employee = (controller
                                                          .isSearchEnabled
                                                      ? controller.filteredUsers
                                                      : controller.users)
                                                  .elementAt(index);
                                              return _UserItemView(
                                                index: index,
                                                employee: employee,
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                height: 0,
                                                color: Colors.grey
                                                    .applyOpacity(0.2),
                                                indent: 68,
                                              );
                                            },
                                          ),
                  ),
                ),
              ),

              //
              //
              // add participants buttons
              Obx(
                () => Visibility(
                  visible: controller.selectedUsers.isNotEmpty,
                  child: BounceInUp(
                    animate: true,
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 600),
                    child: MainAppButton(
                      label: "Next",
                      trailingIcon: Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => Text(
                            controller.selectedUsers.length.toString(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (controller.selectedUsers.isEmpty) {
                          CommonWidgets.showSnackBar(
                            title: "Field Required",
                            message: "Please select at least one user.",
                            isError: false,
                          );
                        } else {
                          controller.onNextClicked();
                        }
                      },
                    ).marginOnly(left: 14, right: 14, bottom: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<ShareResourceController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.applyOpacity(Get.isDarkMode ? 0.3 : 1),
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          // back button, title, action icons
          Row(
            children: [
              //
              //
              // back button
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ).paddingOnly(right: 22),

              //
              //
              // heading
              Expanded(
                child: Obx(
                  () => Text(
                    controller.resource.value.resourceName ?? "",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              //
              // search icon
              GestureDetector(
                onTap: () {
                  if (controller.isSearchEnabled) {
                    controller.searchController.clear();
                  }
                  controller.toggleSearch();
                },
                child: Obx(
                  () => Icon(
                    controller.isSearchEnabled
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ).marginSymmetric(horizontal: 15),

              //
              //
              // select all check box
              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (controller.selectedUsers.length !=
                        controller.users.length) {
                      controller.selectedUsers.clear();
                      controller.selectedUsers.addAll(controller.users);
                    } else {
                      controller.selectedUsers.clear();
                    }
                  },
                  child: Icon(
                    (controller.selectedUsers.length == controller.users.length)
                        ? Icons.indeterminate_check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          //
          //
          // no of recources text
          Visibility(
            visible: controller.resource.value.resourceType == "folder",
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      "${controller.resource.value.childrenCount} Resource${controller.resource.value.haveManyChildren ? 's' : ''}",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).marginOnly(left: 45),

          //
          //
          // shared with or by text
          Obx(
            () => Visibility(
              visible: (controller.resource.value.shared ?? false),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        //
                        //
                        Text(
                          controller.resource.value.isSharedByMe
                              ? "Shared with"
                              : "Shared by",
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),

                        //
                        //
                        Expanded(
                          child: Text(
                            controller.resource.value.isSharedByMe
                                ? " ${controller.resource.value.sharedWithCount} ${controller.resource.value.sharedWithMany ? 'people' : 'person'}"
                                : " ${controller.resource.value.owner ?? "N/A"}",
                            style: textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).marginOnly(left: 45),
            ),
          ),

          //
          //
          // search field
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: controller.isSearchEnabled ? 50 : 0,
              margin: const EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSearchField(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            Get.isDarkMode ? Colors.white12 : Colors.white, // Background color
      ),
      child: TextField(
          controller: controller.searchController,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.all(0),
            hintText: "Search folder, file",
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

class _UserItemView extends GetView<ShareResourceController> {
  final int index;
  final EmployeeEntity employee;
  const _UserItemView({
    required this.index,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () {
        if (controller.selectedUsers.contains(employee)) {
          controller.selectedUsers.remove(employee);
        } else {
          controller.selectedUsers.add(employee);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          children: [
            //
            //
            // user image
            ProfileImage.network(
              url: employee.image,
              width: 45,
              height: 45,
              showLetterOnError: true,
              letter: employee.name?[0].capitalize,
            ).marginOnly(right: 10),
            //
            //
            // user name and desigination
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //
                  // user name
                  Text(
                    employee.name ?? "",
                    style: theme.textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  //
                  //
                  // desigination
                  Text(
                    employee.userDesignation ?? "",
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),

            //
            //
            //
            Obx(
              () => Icon(
                controller.selectedUsers.contains(employee)
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: controller.selectedUsers.contains(employee)
                    ? AppColorsLight.mainColor
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
