import 'package:animate_do/animate_do.dart';
import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/widgets/bubble_menu/app_bubble_menu.dart';
import 'package:ts_admin/app/core/widgets/bubble_menu/bubble.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/resources_empty_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/resources_loading_error_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/bindings/sub_folder_screen_params.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/enums/filtering_enums.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/components/item_views/file_folder_grid_item_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/components/item_views/file_folder_list_item_view.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/components/sub_folder_resources_loading_view.dart';
import '../controllers/sub_folder_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class SubFolderView extends StatefulWidget {
  final SubFolderScreenParams subFolderScreenParams;
  const SubFolderView({
    super.key,
    required this.subFolderScreenParams,
  });

  @override
  State<SubFolderView> createState() => _SubFolderViewState();
}

class _SubFolderViewState extends State<SubFolderView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final controller = Get.put(
      SubFolderController(subFolderScreenParams: widget.subFolderScreenParams),
      tag: widget.subFolderScreenParams.folderId.toString(),
    );

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              Get.back(result: controller.needRefresh);
            }
          },
          child: Scaffold(
            floatingActionButton: Obx(
              () => Visibility(
                visible: (controller.subFolderScreenParams.resource.value
                            ?.canEdit(
                                controller.authController.user.value!.id!) ??
                        false) ||
                    controller.subFolderScreenParams.folderId == 0,
                child: FloatingActionBubble(
                  // Menu items
                  items: [
                    AppBubbleMenu(Bubble(
                      title: "Upload File",
                      iconColor: Colors.white,
                      bubbleColor: AppColors.mainColor,
                      icon: Icons.upload_file_rounded,
                      titleStyle:
                          TextStyle(fontSize: 15.sp, color: Colors.white),
                      onPress: () {
                        controller.onUploadFileClicked();
                      },
                    )),
                    AppBubbleMenu(Bubble(
                      title: "Create Folder",
                      iconColor: Colors.white,
                      bubbleColor: AppColors.mainColor,
                      icon: Icons.create_new_folder_rounded,
                      titleStyle:
                          TextStyle(fontSize: 15.sp, color: Colors.white),
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
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //
                  // header
                  FadeInDown(
                    duration: const Duration(milliseconds: 300),
                    child: _Header(controller: controller),
                  ),

                  //
                  //
                  //
                  // body
                  Expanded(
                      child: SlidableAutoCloseBehavior(
                    child: Obx(
                      () => controller.isLoadingResources
                          ? SubFolderResourcesLoadingView(
                              isGridView: controller.isGridView,
                            )
                          : Column(
                              children: [
                                //
                                //
                                // filters sorting item
                                FiltersSortingView(controller: controller),

                                //
                                //
                                // body view
                                Expanded(
                                  child: SmartRefresher(
                                    controller: controller.refreshController,
                                    header: const WaterDropMaterialHeader(),
                                    onRefresh: () async {
                                      await controller.getResources();
                                      controller.refreshController
                                          .refreshCompleted();
                                    },
                                    child: controller.errorWhileLoadingResources
                                        ? const ResourcesLoadingErrorView()
                                        : controller.allResources.isEmpty
                                            ? const ResourcesEmptyView()
                                            : (controller.isSearchEnabled ||
                                                        (controller
                                                                .resourceTypeFilter
                                                                .value !=
                                                            ResourceTypeFilters
                                                                .all) ||
                                                        (controller
                                                                .resourceOwnershipFilter
                                                                .value !=
                                                            ResourceOwnershipFilters
                                                                .any)) &&
                                                    controller
                                                        .filtertedResources
                                                        .isEmpty
                                                ? const Center(
                                                    child: Text(
                                                        "No search result found"),
                                                  )
                                                : controller.isGridView
                                                    ? GridView.builder(
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          mainAxisSpacing: 10,
                                                          crossAxisSpacing: 10,
                                                          mainAxisExtent: 90,
                                                        ),
                                                        itemCount: controller
                                                            .filtertedResources
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final resource =
                                                              controller
                                                                  .filtertedResources
                                                                  .elementAt(
                                                                      index);

                                                          return FileFolderGridItemView(
                                                            index: index,
                                                            resource: resource,
                                                            controller:
                                                                controller,
                                                          );
                                                        },
                                                      )
                                                    : ListView.separated(
                                                        itemCount: controller
                                                            .filtertedResources
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final resource =
                                                              controller
                                                                  .filtertedResources
                                                                  .elementAt(
                                                                      index);

                                                          return FileFolderListItemView(
                                                            index: index,
                                                            resource: resource,
                                                            controller:
                                                                controller,
                                                          ).marginOnly(
                                                            bottom: index ==
                                                                    (controller
                                                                            .filtertedResources
                                                                            .length -
                                                                        1)
                                                                ? 50
                                                                : 0,
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return Divider(
                                                            height: 0,
                                                            color: Colors.grey
                                                                .applyOpacity(
                                                                    0.2),
                                                          );
                                                        },
                                                      ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    try {
      Get.delete<SubFolderController>(
        tag: widget.subFolderScreenParams.folderId.toString(),
        force: true,
      );
    } catch (_) {}
    super.dispose();
  }
}

class FiltersSortingView extends StatelessWidget {
  final SubFolderController controller;
  const FiltersSortingView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !controller.isLoadingResources,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //
            //
            // filter icon
            IconButton(
              onPressed: () {
                controller.showFiltersButtomSheet();
              },
              icon: Icon(
                Icons.filter_alt_rounded,
                size: 25,
                color: Colors.grey.shade400,
              ),
            ),

            //
            //
            // sort icon
            IconButton(
              onPressed: () {
                controller.showSortsButtomSheet();
              },
              icon: Icon(
                Icons.sort_rounded,
                size: 25,
                color: Colors.grey.shade400,
              ),
            ).marginOnly(left: 10),

            const Spacer(),

            //
            //
            // list/grid icon
            IconButton(
              onPressed: () {
                controller.toggleGridView();
              },
              icon: Obx(
                () => Icon(
                  controller.isGridView
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  size: 25,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ).marginSymmetric(horizontal: 5, vertical: 5),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SubFolderController controller;
  const _Header({
    required this.controller,
  });

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
                  Get.back(result: controller.needRefresh);
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
                    Obx(
                      () => Text(
                        controller.subFolderScreenParams.folderName.value,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: Colors.white),
                        maxLines: 1,
                      ),
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
              ).marginSymmetric(horizontal: 10),

              //
              //
              /// folder option menu
              if (controller.subFolderScreenParams.resource.value != null)
                PopupMenuButton<String>(
                  onSelected: (item) {
                    if (item == "rename") {
                      controller.onRenameResourceCicked(
                          controller.subFolderScreenParams.resource.value!);
                    } else if (item == "share") {
                      controller.onShareResourceCicked(
                          controller.subFolderScreenParams.resource.value!);
                    } else if (item == "download") {
                      controller.onDownloadResourceCicked(
                          controller.subFolderScreenParams.resource.value!);
                    } else if (item == "delete") {
                      controller.onDeleteResourceCicked(
                          controller.subFolderScreenParams.resource.value!);
                    } else if (item == "info") {
                      controller.onResourceInfoCicked(
                          controller.subFolderScreenParams.resource.value!);
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
                      // rename option
                      if (controller.subFolderScreenParams.resource.value!
                          .canEdit(controller.authController.user.value!.id!))
                        PopupMenuItem<String>(
                          value: 'rename',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.drive_file_rename_outline_rounded,
                                size: 20,
                              ),
                              const Text('Rename').marginOnly(left: 10),
                            ],
                          ),
                        ),

                      //
                      //
                      // share option
                      if (controller.subFolderScreenParams.resource.value!
                          .canShare(controller.authController.user.value!.id!))
                        PopupMenuItem<String>(
                          value: 'share',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.share_rounded,
                                size: 20,
                              ),
                              const Text('Share').marginOnly(left: 10),
                            ],
                          ),
                        ),

                      //
                      //
                      // download option
                      PopupMenuItem<String>(
                        value: 'download',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              size: 20,
                            ),
                            const Text('Download').marginOnly(left: 10),
                          ],
                        ),
                      ),

                      //
                      //
                      // delete option
                      if (controller.subFolderScreenParams.resource.value!
                          .canDelete(controller.authController.user.value!.id!))
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_rounded,
                                size: 20,
                              ),
                              const Text('Delete').marginOnly(left: 10),
                            ],
                          ),
                        ),

                      //
                      //
                      // info option
                      PopupMenuItem<String>(
                        value: 'info',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                            ),
                            const Text('Info').marginOnly(left: 10),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
            ],
          ),

          //
          //
          // no of recources text
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    "${controller.subFolderScreenParams.resourcesCount} Resource${controller.subFolderScreenParams.resourcesCount > 1 ? 's' : ''}",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ).marginOnly(left: 45),

          //
          //
          // shared with or by text

          Obx(
            () => Visibility(
              visible: (controller.subFolderScreenParams.resource.value
                          ?.sharedWithUsers ??
                      [])
                  .isNotEmpty,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        //
                        //
                        Text(
                          (controller.subFolderScreenParams.resource.value
                                      ?.isSharedByMe ??
                                  false)
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
                            (controller.subFolderScreenParams.resource.value
                                        ?.isSharedByMe ??
                                    false)
                                ? " ${controller.subFolderScreenParams.resource.value?.sharedWithCount} ${(controller.subFolderScreenParams.resource.value?.sharedWithMany ?? false) ? 'people' : 'person'}"
                                : " ${controller.subFolderScreenParams.resource.value?.owner ?? "N/A"}",
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
              ),
            ),
          ).marginOnly(left: 45),

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
