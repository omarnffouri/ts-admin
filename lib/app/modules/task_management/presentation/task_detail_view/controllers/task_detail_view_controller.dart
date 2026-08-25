import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/task_attachments_manager.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/update_task_progress_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/update_task_status_usecase.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/views/components/add_task_comment_bottom_sheet.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/views/components/task_statuses_bottom_sheet.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/views/components/update_task_status_bottom_sheet.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/controllers/task_management_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class TaskDetailViewController extends GetxController {
  final authController = Get.find<AuthController>();
  final Rxn<TaskEntity> task = Rxn();

  final RxDouble progress = 0.0.obs;

  final RxDouble downloadProgress = 0.0.obs;

  //
  //
  // usecase
  final updateTaskStatusUsecase = sl<UpdateTaskStatusUsecase>();
  final updateTaskProgressUsecase = sl<UpdateTaskProgressUsecase>();

  final taskAttachmentsManager = Get.find<TaskAttachmentsManager>();

  //
  // edit text controllers
  TextEditingController reasonController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  //
  //
  // states
  final RxBool _isUpdatingStatus = false.obs;
  bool get isUpdatingStatus => _isUpdatingStatus.value;

  final RxBool _isAddingComment = false.obs;
  bool get isAddingComment => _isAddingComment.value;

  final RxBool _isUpdatingProgress = false.obs;
  bool get isUpdatingProgress => _isUpdatingProgress.value;

  final RxBool _isDownloadingAttachment = false.obs;
  bool get isDownloadingAttachment => _isDownloadingAttachment.value;

  @override
  void onInit() {
    super.onInit();

    try {
      final args = Get.arguments;
      if (args is TaskEntity) {
        task.value = args;
        progress.value = ((task.value?.percentage ?? 0) / 100).toDouble();
      } else {
        Get.back();
      }
    } catch (_) {
      Get.back();
    }
  }

  bool assignedToMe() {
    if (task.value == null) {
      return false;
    }
    return task.value!.assignedTo?.id == authController.user.value?.id &&
        (authController.user.value?.id != null);
  }

  bool assignedByMe() {
    if (task.value == null) {
      return false;
    }
    return task.value!.reportsTo?.id == authController.user.value?.id &&
        (authController.user.value?.id != null);
  }

  TaskUserEntity? getReporterOrAssigne() {
    if (task.value == null) {
      return null;
    }
    if (assignedToMe() && (!assignedByMe())) {
      return task.value!.reportsTo;
    }

    if (assignedByMe() && (!assignedToMe())) {
      return task.value!.assignedTo;
    }
    return null;
  }

  bool haveDuration() {
    if (task.value == null) {
      return false;
    }

    return task.value!.getFormatedRemainingTime().isNotEmpty;
  }

  void updateProgress(double value) async {
    if (task.value?.id == null) {
      return;
    }

    // api call to update progress.

    try {
      _isUpdatingProgress.value = true;

      final body = {
        'id': task.value?.id,
        'percentage': (progress * 100).round().toInt(),
      };
      final response = await updateTaskProgressUsecase.call(body);
      response.fold((data) {
        if (data.data == true) {
          task.value?.percentage = (progress * 100).round().toInt();
          task.refresh();
          _notifyTaskUpdates(percentageUpdated: true);
          // CommonWidgets.showSnackBar(
          //   title: "Success",
          //   message: "Progress updated successfully.",
          //   isError: false,
          // );
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Unable to update a task progress.",
          );
        }
      }, (Failure failure) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Unable to update a task progress.",
      );
    }
    _isUpdatingProgress.value = false;
  }

  void showUpdateTaskBottomSheet() {
    if (task.value?.id == null) {
      return;
    }

    Get.bottomSheet(
      UpdateTaskStatusBottomSheet(
        title: task.value!.isPending() ? "Start Task" : "Complete Task",
        buttonLabel: task.value!.isPending() ? "Start" : "Complete",
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Get.isDarkMode
          ? AppColorsDark.scaffoldBackroundColor
          : AppColorsLight.scaffoldBackroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    );
  }

  void showTaskStatusesBottomSheet() {
    Get.bottomSheet(
      const TaskStatusesBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode
          ? AppColorsDark.scaffoldBackroundColor
          : AppColorsLight.scaffoldBackroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    );
  }

  void showAddCommentBottomSheet() {
    Get.bottomSheet(
      const AddTaskCommentBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode
          ? AppColorsDark.scaffoldBackroundColor
          : AppColorsLight.scaffoldBackroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    );
  }

  void updateTaskStatus() async {
    if (task.value?.id == null) {
      return;
    }
    String status = '';
    if (task.value?.isPending() ?? false) {
      status = 'in_progress';
    }

    if (task.value?.isInprogress() ?? false) {
      status = 'completed';
    }

    // api call to update status.

    try {
      _isUpdatingStatus.value = true;
      final response = await updateTaskStatusUsecase.call({
        'id': task.value?.id,
        'status': status,
        'reason': reasonController.text,
        'percentage': status == "completed" ? 100 : (progress * 100).toInt()
      });

      response.fold((data) {
        if (data.code == 200) {
          if (data.data != null) {
            task.value = data.data;
          } else {
            task.value?.status = status;
          }
          if (status == "completed") {
            task.value?.percentage = 100;
          }
          task.refresh();
          _notifyTaskUpdates();
          Get.back();
          reasonController.clear();
          CommonWidgets.showSnackBar(
            title: "Success",
            message: "Status updated successfully.",
            isError: false,
          );
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Unable to update a task status.",
          );
        }
      }, (Failure failure) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Unable to update a task status.",
      );
    }
    _isUpdatingStatus.value = false;
  }

  void addTaskComment() async {
    if (task.value?.id == null) {
      return;
    }

    try {
      _isAddingComment.value = true;
      final response = await updateTaskStatusUsecase.call({
        'id': task.value?.id,
        'status': "in_progress",
        'reason': commentController.text,
        'percentage': (progress * 100).toInt()
      });

      response.fold((data) {
        if (data.code == 200) {
          if (data.data != null) {
            task.value = data.data;
          }
          task.refresh();
          _notifyTaskUpdates();
          Get.back();
          commentController.clear();
          CommonWidgets.showSnackBar(
            title: "Success",
            message: "Comment added successfully.",
            isError: false,
          );
        } else {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Unable to add a comment on task.",
          );
        }
      }, (Failure failure) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Unable to add a comment on task.",
      );
    }
    _isAddingComment.value = false;
  }

  void _notifyTaskUpdates({bool percentageUpdated = false}) {
    if (task.value == null) {
      return;
    }
    try {
      if (Get.isRegistered<TaskManagementController>()) {
        Get.find<TaskManagementController>()
            .onTaskUpdated(task.value!, percentageUpdated: percentageUpdated);
      }
    } catch (_) {}
  }

  String getFileIcon() {
    return FileExtensionHelper().getFileIcon(FileExtensionHelper()
        .getFileType(FileExtensionHelper().getFileExtension(getFileName())));
  }

  String getFileName() {
    return task.value?.file?.fileNameExt ?? "";
  }

  void openAttachmentFile() async {
    try {
      //
      // if file url not exist then return
      if ((task.value?.file?.url ?? "").isEmpty) {
        return;
      }

      if (isDownloadingAttachment) {
        return;
      }

      final fileUrl = task.value!.file!.url!;

      final filePath = await taskAttachmentsManager.getAttachmentFile(
        fileUrl,
        onReceiveProgress: (received, total) {
          _isDownloadingAttachment(true);
          downloadProgress.value = received / total;
        },
        onFailure: (message) {
          CommonWidgets.showSnackBar(title: "Error", message: message);
        },
      );

      //
      //
      // resetting download progress states
      _isDownloadingAttachment(false);
      downloadProgress.value = 0.0;

      //
      // if got file successfully then open it
      if (filePath != null) {
        await FileOpener.openFile(filePath);
      }
    } catch (_) {
      _isDownloadingAttachment(false);
      downloadProgress.value = 0.0;
      CommonWidgets.showSnackBar(
          title: "Error", message: "Unable to download attachment.");
    }
  }

  ///
  ///
  /// This will refresh the tasks lists
  void onTaskUpdated(TaskEntity task) {
    if (this.task.value != null) {
      this.task.value!.update(task);
      this.task.refresh();
    }
  }

  @override
  void onClose() {
    if ((task.value?.file?.url ?? "").isNotEmpty) {
      try {
        final fileName = taskAttachmentsManager.getFileName(
          task.value?.file?.url ?? "",
          withExtension: true,
        );

        taskAttachmentsManager.deleteFile(fileName);
      } catch (_) {}
    }
    super.onClose();
  }
}
