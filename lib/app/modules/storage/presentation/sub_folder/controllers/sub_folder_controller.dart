import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/storage_files_manager.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_image_preview.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_video_player.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';
import 'package:ts_admin/app/modules/storage/domain/params/get_resources_params.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/get_resources_usecase.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/create_folder_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/delete_resource_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/download_resource_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/rename_resource_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/components/bottom_sheets/upload_file_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/resource_details/controllers/resource_details_result.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/bindings/sub_folder_screen_params.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/enums/filtering_enums.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/enums/sorting_enums.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/components/bottom_sheets/filters_bottom_sheet.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/views/components/bottom_sheets/sorts_bottom_sheet.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class SubFolderController extends GetxController implements TickerProvider {
  final SubFolderScreenParams subFolderScreenParams;

  SubFolderController({
    required this.subFolderScreenParams,
  });

  Animation<double>? animation;
  AnimationController? animationController;

  //
  // input controller
  TextEditingController searchController = TextEditingController();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();

  // auth controller
  final authController = Get.find<AuthController>();

  //search enabled/disabled state
  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;

  // lisview, grid view state
  final RxBool _isGridView = false.obs;
  bool get isGridView => _isGridView.value;

  final RxBool _fabMenuOpened = false.obs;
  bool get fabMenuOpened => _fabMenuOpened.value;

  //
  //
  // usecase
  final getResourcesUsecase = sl<GetResourcesUsecase>();

  final storageFilesManager = Get.find<StorageFilesManager>();

  //
  //
  // data variables
  final RxList<ResourceEntity> allResources = RxList();
  final RxList<ResourceEntity> filtertedResources = RxList();

  //
  //
  // filtering and sorting states
  final resourceTypeFilter = ResourceTypeFilters.all.obs;
  final resourceOwnershipFilter = ResourceOwnershipFilters.any.obs;
  final resourceSortBy = ResourceSorts.newToOld.obs;

  //
  //
  // states
  final RxBool _isLoadingResources = false.obs;
  bool get isLoadingResources => _isLoadingResources.value;

  final RxBool _errorWhileLoadingResources = false.obs;
  bool get errorWhileLoadingResources => _errorWhileLoadingResources.value;

  bool needRefresh = false;

  @override
  onInit() {
    // load all resources from api
    getResources();

    // attach search change listener
    searchController.addListener(() {
      filterAndSortResources();
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController!);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.onInit();
  }

  void onFabButtonClicked() {
    if (fabMenuOpened) {
      animationController?.reverse();
    } else {
      animationController?.forward();
    }
    _fabMenuOpened.toggle();
  }

  //
  //
  /// get root resources from api
  Future<void> getResources() async {
    if (isLoadingResources) {
      return;
    }

    _errorWhileLoadingResources.value = false;
    _isLoadingResources.value = true;

    try {
      final response = await getResourcesUsecase.call(
        GetResourcesParams(
          parentId: subFolderScreenParams.resource.value?.id,
        ),
      );

      response.fold((BaseResponse<List<ResourceEntity>?> data) {
        if (data.data != null) {
          allResources.clear();
          allResources.addAll(data.data!);
          filterAndSortResources();

          //
          // check if childs count changed then update the child counts also enable
          // a refresh flag so that on back parent resource can also refesh the list
          if (subFolderScreenParams.resourcesCount.value != data.data!.length) {
            subFolderScreenParams.resourcesCount.value = data.data!.length;
            needRefresh = true;
          }
        } else {
          _errorWhileLoadingResources.value = true;
        }
      }, (Failure failure) {
        _errorWhileLoadingResources.value = true;
      });
    } catch (e) {
      debugPrint(e.toString());
      _errorWhileLoadingResources.value = true;
    }

    _isLoadingResources.value = false;
  }

  List<ResourceEntity> filterAndSortResources() {
    filtertedResources.clear();

    //
    //
    // Step 1: Filter by Resource Type
    List<ResourceEntity> filteredResources = allResources.where((resource) {
      bool matchesType = true;
      switch (resourceTypeFilter.value) {
        case ResourceTypeFilters.all:
          matchesType = true; // No filtering needed
          break;
        case ResourceTypeFilters.files:
          matchesType = resource.resourceType?.toLowerCase() == 'file';
          break;
        case ResourceTypeFilters.folders:
          matchesType = resource.resourceType?.toLowerCase() == 'folder';
          break;
      }
      return matchesType;
    }).toList();

    //
    //
    // Step 2: Filter by Resource Ownership
    filteredResources = filteredResources.where((resource) {
      bool matchesOwnership = true;
      switch (resourceOwnershipFilter.value) {
        case ResourceOwnershipFilters.any:
          matchesOwnership = true; // No filtering needed
          break;
        case ResourceOwnershipFilters.myResources:
          matchesOwnership = resource.iAmOwner;
          break;
        case ResourceOwnershipFilters.sharedWithOther:
          matchesOwnership = resource.isSharedByMe;
          break;
        case ResourceOwnershipFilters.sharedByOthers:
          matchesOwnership = resource.isSharedWithMe;
          break;
      }
      return matchesOwnership;
    }).toList();

    // Step 3: Dynamic Sorting based on user's preference
    filteredResources.sort((a, b) {
      // if sort by is name then sort items by name and return ignore by date sorting
      if (resourceSortBy.value == ResourceSorts.nameAZ ||
          resourceSortBy.value == ResourceSorts.nameZA) {
        // Determine name sort order: ascending (A to Z) or descending (Z to A)
        return resourceSortBy.value == ResourceSorts.nameAZ
            ? (a.resourceName ?? '').compareTo(b.resourceName ?? '') // A to Z
            : (b.resourceName ?? '').compareTo(a.resourceName ?? '');
      }

      // Helper to get the effective date for sorting
      DateTime? getEffectiveDate(ResourceEntity resource) {
        // Priority: media's updatedAt > media's createdAt > resource's updatedAt > resource's createdAt
        return resource.media?.firstOrNull?.updatedAt ??
            resource.media?.firstOrNull?.createdAt ??
            resource.updatedAt ??
            resource.createdAt;
      }

      DateTime? dateA = getEffectiveDate(a);
      DateTime? dateB = getEffectiveDate(b);

      // Determine date sort order: ascending (Old to New) or descending (New to Old)
      int dateComparison = 0;
      if (dateA != null && dateB != null) {
        dateComparison = resourceSortBy.value == ResourceSorts.newToOld
            ? dateB.compareTo(dateA) // New to Old
            : dateA.compareTo(dateB); // Old to New
      } else if (dateA != null) {
        dateComparison =
            resourceSortBy.value == ResourceSorts.newToOld ? -1 : 1;
      } else if (dateB != null) {
        dateComparison =
            resourceSortBy.value == ResourceSorts.newToOld ? 1 : -1;
      }

      return dateComparison;
    });

    if (searchController.text.isNotEmpty) {
      final search = searchController.text.toLowerCase();

      filteredResources = filteredResources.where(
        (resource) {
          return resource.resourceName?.toLowerCase().contains(search) ?? false;
        },
      ).toList();
    }

    filtertedResources.addAll(filteredResources);

    return filteredResources;
  }

  //
  //
  /// show filters bottom sheet
  void showFiltersButtomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      builder: (context) {
        return SubFolderFiltersBottomSheet(controller: this);
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// show sorts bottom sheet
  void showSortsButtomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      builder: (context) {
        return SubFolderSortsBottomSheet(controller: this);
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function to build a popup menu item
  PopupMenuItem<String> _buildPopupMenuItem(
      String value, String label, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          Text(label).marginOnly(left: 10),
        ],
      ),
    );
  }

  //
  //
  /// function to show option for the resource in grid list view
  void showPopupMenu(
      BuildContext context, Offset offset, ResourceEntity resource) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      elevation: 10,
      shadowColor: Colors.grey,
      items: [
        // filter option
        if (resource.canEdit(authController.user.value!.id!))
          _buildPopupMenuItem(
            'rename',
            'Rename',
            Icons.drive_file_rename_outline_rounded,
          ),
        // download option
        _buildPopupMenuItem(
          'download',
          'Download',
          Icons.download_rounded,
        ),
        // share option
        if (resource.canShare(authController.user.value!.id!))
          _buildPopupMenuItem(
            'share',
            'Share',
            Icons.share_rounded,
          ),
        // delete option
        if (resource.canDelete(authController.user.value!.id!))
          _buildPopupMenuItem(
            'delete',
            'Delete',
            Icons.delete_rounded,
          ),
        // info option
        _buildPopupMenuItem(
          'info',
          'Info',
          Icons.info_outlined,
        ),
      ],
    ).then((value) {
      switch (value) {
        case "rename":
          onRenameResourceCicked(resource);
          break;
        case "download":
          onDownloadResourceCicked(resource);
          break;
        case "share":
          onShareResourceCicked(resource);
          break;
        case "delete":
          onDeleteResourceCicked(resource);
          break;
        case "info":
          onResourceInfoCicked(resource);
          break;
      }
    });
  }

  //
  //
  // clear the search state
  void clearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchController.clear();
  }

  void toggleSearch() {
    _isSearchEnabled.toggle();
    if (!isSearchEnabled) {
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      filterAndSortResources();
    }
  }

  void toggleGridView() {
    _isGridView.toggle();
  }

  //
  //
  /// function to handle a file click
  onFileResourceClicked(ResourceEntity resource) async {
    //
    //
    // if resource is image or video file then load in previewer
    if ((resource.media ?? []).isNotEmpty) {
      try {
        //
        // collecting and loading file meta data
        final url = resource.primaryMediaUrl;
        if (url.isEmpty) {
          await onDownloadResourceCicked(resource);
          return;
        }
        final fileName =
            storageFilesManager.getFileName(url, withExtension: true);
        final file = await storageFilesManager.getFile(fileName);
        final mimeType = lookupMimeType(file?.path ?? url) ?? "";

        // if image file then load in image previewer
        if (storageFilesManager.isImageFile(mimeType)) {
          Get.to(
            () => ChatImagePreview(
              title: fileName,
              previewImages: [PreviewImage(file: file, url: url)],
              fileManager: storageFilesManager,
            ),
          );
        }

        // else if video file then load in video player
        else if (storageFilesManager.isVideoFile(mimeType)) {
          Get.to(
            () => ChatVideoPlayer(
              videoUrl: url,
              title: fileName,
              videoFile: file,
              fileManager: storageFilesManager,
            ),
          );
        } else if (file != null) {
          await FileOpener.openFile(file.path);
        } else {
          await onDownloadResourceCicked(resource);
        }
      } catch (_) {}
    } else {
      await onDownloadResourceCicked(resource);
    }
  }

  //
  //
  /// function to handle resource info click
  onResourceInfoCicked(ResourceEntity resource) async {
    try {
      final result =
          await Get.toNamed(Routes.RESOURCE_DETAILS, arguments: resource);

      if (result is ResourceDetailsResult) {
        //
        // refeshing details if needed
        if (result.needRefresh) {
          // refreshing a resources list if needed
          getResources();

          // refreshing a resource if needed
          if (subFolderScreenParams.folderId == result.resource.id) {
            needRefresh = true;
            subFolderScreenParams.resource.value
                ?.updateResourceDetails(result.resource);
            subFolderScreenParams.resource.refresh();
            if ((subFolderScreenParams.resource.value?.resourceName ?? "")
                .isNotEmpty) {
              subFolderScreenParams.folderName.value =
                  subFolderScreenParams.resource.value!.resourceName!;
            }
          }
        }
      }
    } catch (_) {}
  }

  //
  //
  /// function to handle resource share click
  onShareResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }

    try {
      final result =
          await Get.toNamed(Routes.SHARE_RESOURCE, arguments: resource);

      if (result == true) {
        getResources();
      }
    } catch (_) {}
  }

  //
  //
  /// function to handle resource download click
  onDownloadResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return DownloadResourceBottomSheet(
          resourceId: resource.id!,
          resourceType: resource.resourceType ?? "folder",
          onSuccess: () {
            Get.back();
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function to handle resource delete click
  onDeleteResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return DeleteResourceBottomSheet(
          resourceName: resource.resourceName ?? "",
          resourceId: resource.id!,
          onSuccess: () {
            needRefresh = true;
            Get.back();
            getResources();
            try {
              if (resource.resourceType == "file" &&
                  (resource.media ?? []).isNotEmpty) {
                final url = resource.primaryMediaUrl;
                if (url.isEmpty) {
                  return;
                }
                final fileName = storageFilesManager.getFileName(
                  url,
                  withExtension: true,
                );
                storageFilesManager.deleteFile(fileName);
              }
            } catch (_) {}
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function to handle resource rename click
  onRenameResourceCicked(ResourceEntity resource) async {
    if (resource.id == null) {
      return;
    }
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return RenameResourceBottomSheet(
          resourceId: resource.id!,
          parentId: resource.parentId,
          resourceName: resource.resourceName ?? "",
          resourceType: resource.resourceType ?? "folder",
          onSuccess: (newName) {
            if (resource.id == subFolderScreenParams.folderId) {
              subFolderScreenParams.folderName.value = newName;
              subFolderScreenParams.resource.value?.resourceName = newName;
              needRefresh = true;
            }
            Get.back();
            getResources();
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function that handles the folder creation
  onCreateFolderClicked() async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return CreateFolderBottomSheet(
          onSuccess: () {
            needRefresh = true;
            Get.back();
            getResources();
          },
          parentId: subFolderScreenParams.resource.value?.id,
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  //
  //
  /// function that handles the file uploading
  onUploadFileClicked() async {
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return UploadFileBottomSheet(
          parentId: subFolderScreenParams.resource.value?.id,
          onSuccess: () {
            needRefresh = true;
            Get.back();
            getResources();
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  @override
  void dispose() {
    refreshController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
