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
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class StorageDriveController extends GetxController implements TickerProvider {
  final authController = Get.find<AuthController>();
  //
  // input controller
  TextEditingController searchController = TextEditingController();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();

  Animation<double>? animation;
  AnimationController? animationController;

  //search enabled/disabled state
  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;

  // lisview, grid view state
  final RxBool _isGridView = false.obs;
  bool get isGridView => _isGridView.value;

  //
  //
  // usecase
  final getResourcesUsecase = sl<GetResourcesUsecase>();

  final storageFilesManager = Get.find<StorageFilesManager>();

  //
  //
  // data variables
  final RxList<ResourceEntity> recentlyUploadedResource = RxList();
  final RxList<ResourceEntity> allResources = RxList();
  final RxList<ResourceEntity> filtertedResources = RxList();

  final RxBool _fabMenuOpened = false.obs;
  bool get fabMenuOpened => _fabMenuOpened.value;

  //
  //
  // states
  final RxBool _isLoadingResources = false.obs;
  bool get isLoadingResources => _isLoadingResources.value;

  final RxBool _errorWhileLoadingResources = false.obs;
  bool get errorWhileLoadingResources => _errorWhileLoadingResources.value;

  @override
  onInit() {
    // load all resources from api
    getResources();

    // attach search change listener
    searchController.addListener(() {
      handleSearch();
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
      final response = await getResourcesUsecase.call(GetResourcesParams());

      response.fold((BaseResponse<List<ResourceEntity>?> data) {
        if (data.data != null) {
          _filterResourcesData(data.data!);
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

  //
  //
  /// filter the recently uploaded and all resources
  _filterResourcesData(List<ResourceEntity> data) {
    allResources.clear();
    allResources.addAll(data);

    DateTime now = DateTime.now();
    DateTime sevenDaysErlier = now.subtract(const Duration(days: 7));

    recentlyUploadedResource.clear();
    // Filter the resources that are uploaded in last 7 days
    recentlyUploadedResource.addAll(
      allResources.where(
        (item) {
          return (item.createdAt?.isAfter(sevenDaysErlier) ?? false) &&
              (item.createdAt?.isBefore(now) ?? false);
        },
      ),
    );

    _sortList(recentlyUploadedResource);
    _sortList(allResources);
  }

  //
  //
  /// This will sort the list on the base of createAt
  _sortList(List<ResourceEntity> list) {
    list.sort((a, b) {
      if (a.createdAt == null) return 1; // Nulls go last
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!); // Newest first
    });
  }

  //
  //
  /// will handle the search text and filter search result into seperate list
  handleSearch() {
    filtertedResources.clear();

    if (searchController.text.isEmpty) {
      filtertedResources.addAll(allResources);
    } else {
      final search = searchController.text.toLowerCase();
      filtertedResources.addAll(
        allResources.where(
          (resource) {
            return resource.resourceName?.toLowerCase().contains(search) ??
                false;
          },
        ),
      );
    }
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
      handleSearch();
    }
  }

  void toggleGridView() {
    _isGridView.toggle();
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
    await showModalBottomSheet(
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
          resourceName: resource.resourceName ?? "",
          resourceType: resource.resourceType ?? "folder",
          onSuccess: (newName) {
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
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return CreateFolderBottomSheet(
          onSuccess: () {
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
          onSuccess: () {
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
