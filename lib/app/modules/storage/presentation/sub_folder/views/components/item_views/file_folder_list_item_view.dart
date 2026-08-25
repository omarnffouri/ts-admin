import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/bindings/sub_folder_screen_params.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/sub_folder_controller.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/sub_folder_view.dart';

class FileFolderListItemView extends StatelessWidget {
  final int index;
  final ResourceEntity resource;
  final SubFolderController controller;
  const FileFolderListItemView({
    super.key,
    required this.index,
    required this.resource,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final isFile = resource.resourceType == "file";

    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      groupTag: "sub_folder_listing_slide_group",
      endActionPane: ActionPane(
        extentRatio: 0.75,
        motion: const BehindMotion(),
        children: [
          //
          //
          // delete icon
          if (resource.canDelete(controller.authController.user.value!.id!))
            SlidableAction(
              onPressed: (context) {
                controller.onDeleteResourceCicked(resource);
              },
              backgroundColor: AppColorsLight.mainColor,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              // label: 'Delete',
            ),

          //
          //
          // share button
          if (resource.canShare(controller.authController.user.value!.id!))
            SlidableAction(
              onPressed: (context) {
                controller.onShareResourceCicked(resource);
              },
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              icon: Icons.share_rounded,
              // label: 'Share',
            ),

          //
          //
          // download button
          SlidableAction(
            onPressed: (context) {
              controller.onDownloadResourceCicked(resource);
            },
            backgroundColor: const Color.fromARGB(255, 56, 56, 56),
            foregroundColor: Colors.white,
            icon: Icons.download_rounded,
            // label: 'Download',
          ),

          //
          //
          // info button
          SlidableAction(
            onPressed: (context) {
              controller.onResourceInfoCicked(resource);
            },
            backgroundColor: const Color.fromARGB(255, 75, 75, 75),
            foregroundColor: Colors.white,
            icon: Icons.info_outline_rounded,
            // label: 'Info',
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          if (isFile) {
            controller.onFileResourceClicked(resource);
            return;
          }

          if (resource.resourceType != "folder" || resource.id == null) {
            return;
          }
          try {
            final result = await Get.to(
              () => SubFolderView(
                subFolderScreenParams: SubFolderScreenParams(
                  folderId: resource.id!,
                  folderName: resource.resourceName ?? "",
                  resourcesCount: resource.children ?? 0,
                  resource: Rxn(resource),
                ),
              ),
              preventDuplicates: false,
            );

            if (result == true) {
              controller.getResources();
            }
          } catch (_) {}
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: resource.isSharedWithMe
                ? AppColorsLight.mainColor.applyOpacity(0.05)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              //
              //  file,folder details
              Row(
                children: [
                  //
                  //
                  // file, folder icon
                  isFile
                      ? Image.asset(
                          controller.storageFilesManager
                              .getFileIconFromUrl(resource.primaryMediaUrl),
                          width: 30,
                          height: 30,
                          color: controller.storageFilesManager.getFileType(
                                    resource.primaryMediaUrl,
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

                  //
                  //
                  // folder name
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () {
                        controller.onRenameResourceCicked(resource);
                      },
                      child: Text(
                        resource.resourceName ?? "",
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  //
                  //
                  // share icon
                  if (resource.shared ?? false)
                    RotatedBox(
                      quarterTurns: resource.isSharedWithMe ? 3 : 1,
                      child: Icon(
                        Icons.share_rounded,
                        size: 20,
                        color: resource.isSharedByMe
                            ? Colors.grey
                            : AppColorsLight.mainColor,
                      ).marginOnly(left: 5),
                    ),
                ],
              ),

              //
              //
              // number of resources or size and modified date
              Row(
                children: [
                  //
                  //
                  // number of resources or file size
                  Expanded(
                    child: Text(
                      isFile
                          ? (resource.primaryMedia?.size ?? "N/A")
                          : "${resource.childrenCount} Resource${resource.haveManyChildren ? "s" : ""}",
                      style: textTheme.labelSmall,
                    ),
                  ),

                  //
                  //
                  //
                  // last modified date time
                  if (!(resource.shared ?? false))
                    Expanded(
                      child: Text(
                        resource.updatedAt.getDateMDYAndTime(),
                        style: textTheme.labelSmall,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                      ),
                    )
                ],
              ),

              //
              //
              // share and time view
              if (resource.shared ?? false)
                Row(
                  children: [
                    //
                    //
                    // owner name or shared with count

                    //
                    //
                    //
                    // last modified date time
                    Expanded(
                      child: Text(
                        resource.updatedAt.getDateMDYAndTime(),
                        style: textTheme.labelSmall,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
