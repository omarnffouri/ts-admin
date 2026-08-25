import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/bindings/sub_folder_screen_params.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/sub_folder_controller.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/sub_folder_view.dart';

class FileFolderGridItemView extends StatelessWidget {
  final int index;
  final ResourceEntity resource;
  final SubFolderController controller;
  const FileFolderGridItemView({
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

    return Container(
      margin: EdgeInsets.only(
        left: index % 2 == 0 ? 14 : 0,
        right: index % 2 != 0 ? 14 : 0,
      ),
      decoration: BoxDecoration(
        color: resource.isSharedWithMe
            ? AppColorsLight.mainColor.applyOpacity(0.05)
            : null,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //
              //
              // file,folder details
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
                      maxLines: (resource.shared ?? false) ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  //
                  //
                  // option button
                  GestureDetector(
                    onTapDown: (details) {
                      controller.showPopupMenu(
                          context, details.globalPosition, resource);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.applyOpacity(0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.all(5.0),
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
              // number of resources or size
              Text(
                isFile
                    ? (resource.primaryMedia?.size ?? "N/A")
                    : "${resource.childrenCount} Resource${resource.haveManyChildren ? "s" : ""}",
                style: textTheme.labelSmall,
              ),

              //
              //
              // owner name or shared with count and modified at time
              (!(resource.shared ?? false))
                  ? Text(
                      resource.updatedAt.getDateMDYAndTime(),
                      style: textTheme.labelSmall,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                    )
                  : Row(
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
                                ? " ${resource.sharedWithCount} ${resource.sharedWithMany ? 'person' : 'people'}"
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
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
