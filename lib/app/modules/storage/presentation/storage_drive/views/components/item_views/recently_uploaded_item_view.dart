import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/presentation/storage_drive/controllers/storage_drive_controller.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/bindings/sub_folder_screen_params.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/sub_folder_view.dart';

class RecentlyUploadedItemView extends GetView<StorageDriveController> {
  final int index;
  final ResourceEntity resource;
  const RecentlyUploadedItemView({
    super.key,
    required this.index,
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final isFile = resource.resourceType == "file";
    return Container(
      width: 200,
      margin: EdgeInsets.only(left: index == 0 ? 14 : 10),
      decoration: BoxDecoration(
        color: resource.isSharedWithMe
            ? AppColorsLight.mainColor.applyOpacity(0.05)
            : Colors.grey.applyOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: resource.isSharedWithMe
              ? AppColorsLight.mainColor.applyOpacity(0.5)
              : Colors.grey.applyOpacity(0.5),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              //
              // file folder icon
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
                  // file name
                  Expanded(
                    child: Text(
                      resource.resourceName ?? "",
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  //
                  //
                  // option button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.applyOpacity(0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTapDown: (details) {
                        controller.showPopupMenu(
                            context, details.globalPosition, resource);
                      },
                      child: const Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              //
              //
              // number of resources
              Text(
                isFile
                    ? (resource.primaryMedia?.size ?? "N/A")
                    : "${resource.childrenCount} Resource${resource.haveManyChildren ? "s" : ""}",
                style: textTheme.labelSmall,
              ),

              //
              //
              // owner name or shared with count
              (resource.shared ?? false)
                  ? Row(
                      children: [
                        //
                        //
                        Text(
                          resource.isSharedByMe ? "Shared with" : "Shared by",
                          style: textTheme.bodySmall,
                        ),

                        //
                        //
                        Expanded(
                          child: Text(
                            resource.isSharedByMe
                                ? " ${resource.sharedWithCount} ${resource.sharedWithMany ? 'people' : 'person'}"
                                : " ${resource.owner ?? "N/A"}",
                            style: textTheme.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        //
                        //
                        // share icon

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
                    )
                  :

                  //
                  //
                  // modified at time
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last modified",
                          style: textTheme.bodySmall,
                        ),

                        //
                        //
                        // modified date time
                        Expanded(
                          child: Text(
                            resource.updatedAt.getDateMDYAndTime(),
                            style: textTheme.labelSmall,
                            maxLines: 2,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
