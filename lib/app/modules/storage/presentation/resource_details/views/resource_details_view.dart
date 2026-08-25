import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';

import '../controllers/resource_details_controller.dart';

class ResourceDetailsView extends GetView<ResourceDetailsController> {
  const ResourceDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              Get.back(result: controller.getResults());
            }
          },
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                //
                // header
                const _Header(),

                //
                //
                //
                // body
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        // heading
                        Text(
                          "Resource Information",
                          style: theme.textTheme.titleLarge,
                        ).marginOnly(left: 14, top: 20, bottom: 10),

                        Divider(
                          height: 0,
                          color: Colors.grey.applyOpacity(0.2),
                        ).marginSymmetric(horizontal: 14),

                        //
                        //
                        // resource details view
                        Container(
                          margin: const EdgeInsets.only(
                              left: 14, right: 14, top: 20),
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.grey.applyOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              if (!Get.isDarkMode)
                                BoxShadow(
                                  color: Colors.grey.applyOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                )
                            ],
                          ),
                          child: Column(
                            children: [
                              //
                              //
                              // resource name
                              Obx(
                                () => _buildDetailsSection(
                                  "Name",
                                  controller.resource.value.resourceName,
                                  actionIcon: GestureDetector(
                                    onTap: () {
                                      controller.onRenameResourceCicked(
                                          controller.resource.value);
                                    },
                                    child: const Icon(
                                      Icons.drive_file_rename_outline_rounded,
                                    ),
                                  ),
                                  dataLeftIcon: controller.resource.value.isFile
                                      ? Image.asset(
                                          controller.storageFilesManager
                                              .getFileIconFromUrl(controller
                                                  .resource
                                                  .value
                                                  .primaryMediaUrl),
                                          width: 25,
                                          height: 25,
                                          color: controller.storageFilesManager
                                                      .getFileType(
                                                    controller.resource.value
                                                        .primaryMediaUrl,
                                                  ) ==
                                                  FileTypes.none
                                              ? Get.isDarkMode
                                                  ? Colors.white
                                                  : AppColorsLight.mainColor
                                              : null,
                                        ).marginOnly(right: 5)
                                      : const Icon(
                                          Icons.folder_rounded,
                                          size: 30,
                                          color: Colors.amber,
                                        ).marginOnly(right: 5),
                                ),
                              ),

                              //
                              //
                              // resource owner
                              _buildDetailsSection(
                                "Owner",
                                (controller.resource.value.iAmOwner)
                                    ? "You"
                                    : controller.resource.value.owner,
                              ).marginOnly(top: 10),

                              //
                              //
                              // resources and shared
                              Obx(
                                () => _buildDoubleColumnDetailsSection(
                                  controller.resource.value.isFile
                                      ? "Size"
                                      : "Resources",
                                  controller.resource.value.isFile
                                      ? controller.resource.value.media
                                          ?.firstOrNull?.size
                                      : controller.resource.value.children
                                          ?.toString(),
                                  "Shared",
                                  (!(controller.resource.value.shared ?? false))
                                      ? "No"
                                      : controller.resource.value.isSharedByMe
                                          ? "with ${controller.resource.value.sharedWithCount} ${controller.resource.value.sharedWithMany ? 'people' : 'person'}"
                                          : "by ${controller.resource.value.owner ?? "N/A"}",
                                ),
                              ).marginOnly(top: 10),

                              //
                              //
                              // created at and updated at
                              Obx(
                                () => _buildDoubleColumnDetailsSection(
                                  "Created At",
                                  (controller.resource.value.media
                                              ?.firstOrNull !=
                                          null)
                                      ? controller.resource.value.media
                                          ?.firstOrNull?.createdAt
                                          .getDateMDYAndTime()
                                      : controller.resource.value.createdAt
                                          .getDateMDYAndTime(),
                                  "Updated At",
                                  (controller.resource.value.media
                                              ?.firstOrNull !=
                                          null)
                                      ? controller.resource.value.media
                                          ?.firstOrNull?.updatedAt
                                          .getDateMDYAndTime()
                                      : controller.resource.value.updatedAt
                                          .getDateMDYAndTime(),
                                ),
                              ).marginOnly(top: 10),

                              //
                              //
                              //
                            ],
                          ),
                        ),

                        //
                        //
                        // shared with heading
                        if (controller.resource.value.sharedWithUsers != null)
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                //
                                // heading
                                Text(
                                  "Shared With",
                                  style: theme.textTheme.titleLarge,
                                ),
                                const Spacer(),

                                // revoke all permission button
                                if (controller.resource.value.canEdit(controller
                                        .authController.user.value!.id!) &&
                                    controller.resource.value.sharedWithUsers!
                                        .isNotEmpty)
                                  IconButton(
                                    onPressed: () {
                                      controller
                                          .onRevokeAllResourcePermissionsClicked();
                                    },
                                    icon: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.applyOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.person_remove_alt_1_outlined,
                                            size: 25,
                                            color: AppColorsLight.mainColor,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Revoke All",
                                            style: TextStyle(
                                              color: AppColorsLight.mainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                IconButton(
                                  onPressed: () {
                                    controller.onShareResourceCicked(
                                        controller.resource.value);
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.applyOpacity(0.2),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    child: const Icon(
                                      Icons.share_rounded,
                                      size: 25,
                                      color: AppColorsLight.mainColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).marginOnly(left: 14, right: 14, top: 20),

                        if (controller.resource.value.sharedWithUsers != null)
                          Divider(
                            height: 0,
                            color: Colors.grey.applyOpacity(0.2),
                          ).marginSymmetric(horizontal: 14),

                        const SizedBox(
                          height: 20,
                        ),

                        //
                        //
                        /// shared with list
                        if (controller.resource.value.sharedWithUsers != null)
                          Obx(
                            () => SlidableAutoCloseBehavior(
                              child: ListView.separated(
                                itemCount: controller
                                    .resource.value.sharedWithUsers!.length,
                                shrinkWrap: true,
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final user = controller
                                      .resource.value.sharedWithUsers!
                                      .elementAt(index);
                                  return _SharedWithUserItemView(
                                    index: index,
                                    user: user,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    height: 0,
                                    indent: 66,
                                    color: Colors.grey.applyOpacity(0.2),
                                  );
                                },
                              ),
                            ),
                          )
                      ],
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

  Widget _buildDetailsSection(String heading, String? data,
      {Widget? actionIcon, Widget? dataLeftIcon}) {
    final ThemeData theme = Get.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        //
        // heading
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey.applyOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              // heading
              Expanded(
                child: Text(
                  heading,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // action icon
              if (actionIcon != null) actionIcon
            ],
          ),
        ),

        //
        //
        // data
        Row(
          children: [
            if (dataLeftIcon != null) dataLeftIcon,
            Expanded(
              child: Text(
                data ?? "N/A",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ).marginSymmetric(horizontal: 5),
      ],
    );
  }

  Widget _buildDoubleColumnDetailsSection(
      String heading1, String? data1, String heading2, String? data2) {
    return Row(
      children: [
        //
        //
        // details section column 1
        Expanded(
          child: _buildDetailsSection(
            heading1,
            data1,
          ),
        ),

        const SizedBox(
          width: 20,
        ),

        //
        //
        // details section column 2
        Expanded(
          child: _buildDetailsSection(
            heading2,
            data2,
          ),
        )
      ],
    );
  }
}

class _Header extends GetView<ResourceDetailsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
                  Get.back(result: controller.getResults());
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
              //
              /// resource option menu
              PopupMenuButton<String>(
                onSelected: (item) {
                  if (item == "rename") {
                    controller
                        .onRenameResourceCicked(controller.resource.value);
                  } else if (item == "share") {
                    controller.onShareResourceCicked(controller.resource.value);
                  } else if (item == "download") {
                    controller
                        .onDownloadResourceCicked(controller.resource.value);
                  } else if (item == "delete") {
                    controller
                        .onDeleteResourceCicked(controller.resource.value);
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
                    // edit option
                    if (controller.resource.value
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
                    if (controller.resource.value
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
                    if (controller.resource.value
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
                  ];
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SharedWithUserItemView extends GetView<ResourceDetailsController> {
  final int index;
  final SharedWithUserEntity user;
  const _SharedWithUserItemView({
    required this.index,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      groupTag: "shared_with_user_slide_group",
      endActionPane: (!controller.resource.value
              .canEdit(controller.authController.user.value!.id!))
          ? null
          : ActionPane(
              motion: const BehindMotion(),
              extentRatio: 0.3,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    controller.onRevokeResourcePermissionClicked(user, index);
                  },
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: Colors.white,
                  icon: Icons.person_remove_alt_1_rounded,
                  label: 'Revoke',
                ),
              ],
            ),
      child: Obx(
        () => LoadingWrapperWidget(
          isLoading: controller.isRevokingAllPermission.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              children: [
                //
                //
                // user image
                ProfileImage.network(
                  url: user.image,
                  width: 45,
                  height: 45,
                  showLetterOnError: true,
                  letter: user.name?[0].capitalize,
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
                        user.name ?? "",
                        style: theme.textTheme.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      //
                      //
                      // desigination
                      Text(
                        user.designation ?? "",
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),

                //
                //
                // permission, options click or loading view
                Obx(
                  () => controller.isRevokingAllPermission.value
                      ? const SizedBox(
                          width: 30,
                          child: LinearProgressIndicator(
                            color: AppColorsLight.mainColor,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //
                            //
                            // permission
                            Text(user.getPermissionText()).marginOnly(right: 5),

                            //
                            //
                            // options icon
                            const Icon(
                              Icons.arrow_back_ios_outlined,
                              size: 15,
                              color: Colors.grey,
                            )
                          ],
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
