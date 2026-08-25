import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/bubble_menu/app_bubble_menu.dart';
import 'package:ts_admin/app/core/widgets/bubble_menu/bubble.dart';
import 'package:ts_admin/app/modules/storage/presentation/storage_drive/views/components/item_views/file_folder_grid_item_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/storage_drive/views/components/item_views/file_folder_list_item_view.dart';

import 'package:ts_admin/app/modules/storage/presentation/storage_drive/views/components/item_views/recently_uploaded_item_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/storage_drive/views/components/loading_views/storage_drive_loading_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/resources_empty_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/resources_loading_error_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/bindings/sub_folder_screen_params.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/sub_folder_view.dart';

import '../controllers/storage_drive_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class StorageDriveView extends GetView<StorageDriveController> {
  const StorageDriveView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Obx(
            () => FloatingActionBubble(
              // Menu items
              items: [
                AppBubbleMenu(Bubble(
                  title: "Upload File",
                  iconColor: Colors.white,
                  bubbleColor: AppColors.mainColor,
                  icon: Icons.upload_file_rounded,
                  titleStyle: TextStyle(fontSize: 15.sp, color: Colors.white),
                  onPress: () {
                    controller.onUploadFileClicked();
                  },
                )),
                AppBubbleMenu(Bubble(
                  title: "Create Folder",
                  iconColor: Colors.white,
                  bubbleColor: AppColors.mainColor,
                  icon: Icons.create_new_folder_rounded,
                  titleStyle: TextStyle(fontSize: 15.sp, color: Colors.white),
                  onPress: () {
                    controller.onCreateFolderClicked();
                  },
                )),
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
          body: Column(
            children: [
              //
              //
              // header
              const _Header(),

              //
              //
              // body view
              Expanded(
                child: Obx(
                  () => controller.isLoadingResources
                      ? const StorageDriveLoadingView()
                      : SmartRefresher(
                          controller: controller.refreshController,
                          header: const WaterDropMaterialHeader(),
                          onRefresh: () async {
                            await controller.getResources();
                            controller.refreshController.refreshCompleted();
                          },
                          child: Obx(
                            () => controller.errorWhileLoadingResources
                                ? const ResourcesLoadingErrorView()
                                : controller.allResources.isEmpty
                                    ? const ResourcesEmptyView()
                                    : controller.isSearchEnabled &&
                                            controller
                                                .filtertedResources.isEmpty
                                        ? const Center(
                                            child:
                                                Text("No search result found"),
                                          )
                                        : const _StorageBodyView(),
                          ),
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

class _Header extends GetView<StorageDriveController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                child: Row(
                  children: [
                    Text(
                      'Storage',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
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
              ).marginSymmetric(horizontal: 5),
            ],
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

class _StorageBodyView extends GetView<StorageDriveController> {
  const _StorageBodyView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        //
        // recently uploaded view
        Obx(
          () => Visibility(
            visible: controller.recentlyUploadedResource.isNotEmpty &&
                (!controller.isSearchEnabled),
            child: const _RecentlyUploaded(),
          ),
        ),

        //
        //
        // files, folders root view
        const Expanded(
          child: _RootResourcesView(),
        )
      ],
    );
  }
}

class _RecentlyUploaded extends GetView<StorageDriveController> {
  const _RecentlyUploaded();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Column(
      children: [
        //
        //
        // recently uploaded
        Row(
          children: [
            //
            // title
            Text(
              "Recently Uploaded",
              style: textTheme.headlineSmall,
            ),

            const Spacer(),

            //
            //
            // view all button
            // TextButton(
            //   onPressed: () {
            //     //
            //   },
            //   child: const Text("See all"),
            // )
          ],
        ).marginOnly(left: 14, right: 8, top: 14),

        //
        //
        // items list
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.recentlyUploadedResource.length,
            itemBuilder: (context, index) {
              final resource =
                  controller.recentlyUploadedResource.elementAt(index);
              return RecentlyUploadedItemView(
                index: index,
                resource: resource,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RootResourcesView extends GetView<StorageDriveController> {
  const _RootResourcesView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        //
        //
        // files, folder header
        Row(
          children: [
            //
            // resources heading
            Text(
              "Resources",
              style: theme.textTheme.headlineSmall,
            ),

            const Spacer(),

            Obx(
              () => IconButton(
                onPressed: () {
                  controller.toggleGridView();
                },
                icon: Icon(
                  controller.isGridView
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  size: 25,
                  color: AppColorsLight.mainColor,
                ),
              ),
            ),

            //
            //
            // view all button
            TextButton(
              onPressed: () async {
                try {
                  final result = await Get.to(
                    () => SubFolderView(
                      subFolderScreenParams: SubFolderScreenParams(
                        folderId: 0,
                        folderName: "Storage",
                        resourcesCount: controller.allResources.length,
                      ),
                    ),
                    preventDuplicates: false,
                  );
                  if (result == true) {
                    controller.getResources();
                  }
                } catch (_) {}
              },
              child: Text(
                "See all",
                style: theme.textTheme.labelMedium,
              ),
            )
          ],
        ).marginOnly(left: 14, right: 8, top: 14),

        //
        //
        // files and folders view
        Expanded(
          child: SlidableAutoCloseBehavior(
            child: Obx(
              () => controller.isGridView
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 90,
                      ),
                      itemCount: (controller.isSearchEnabled
                              ? controller.filtertedResources
                              : controller.allResources)
                          .length,
                      itemBuilder: (context, index) {
                        final resource = (controller.isSearchEnabled
                                ? controller.filtertedResources
                                : controller.allResources)
                            .elementAt(index);

                        return FileFolderGridItemView(
                          index: index,
                          resource: resource,
                        );
                      },
                    )
                  : ListView.separated(
                      itemCount: (controller.isSearchEnabled
                              ? controller.filtertedResources
                              : controller.allResources)
                          .length,
                      itemBuilder: (context, index) {
                        final resource = (controller.isSearchEnabled
                                ? controller.filtertedResources
                                : controller.allResources)
                            .elementAt(index);

                        return FileFolderListItemView(
                          index: index,
                          resource: resource,
                        ).marginOnly(
                          bottom: index ==
                                  ((controller.isSearchEnabled
                                              ? controller.filtertedResources
                                              : controller.allResources)
                                          .length -
                                      1)
                              ? 50
                              : 0,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0,
                          color: Colors.grey.applyOpacity(0.2),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
