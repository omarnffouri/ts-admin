import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/update_task_usecase.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/controllers/task_detail_view_controller.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/controllers/task_management_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_dropdown_entity.dart';

import '../../../domain/usecases/create_task_usecase.dart';
import '../../../domain/usecases/get_task_dropdown_usecase.dart';

class CreateTaskController extends GetxController {
  final authController = Get.find<AuthController>();
  // usecases
  final getTaskDropdownUsecase = sl<GetTaskDropdownUsecase>();
  final createTaskUsecase = sl<CreateTaskUsecase>();
  final updateTaskUsecase = sl<UpdateTaskUsecase>();

  // variables
  final taskDropdowns = <TaskDropdownsEntity>[].obs;

  DateTime? pickedDate;
  final formKey = GlobalKey<FormState>();
  final Rxn<TaskDropdownsEntity> selectedAssignTo = Rxn();
  final Rxn<TaskDropdownsEntity> selectedReportTo = Rxn();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final Rxn<TaskEntity> task = Rxn();

  // input controller
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  // focus nodes, so keyboard "next" actions move between fields without
  // being recreated on every rebuild
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode categoryFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  // keys used purely to scroll/focus toward the first invalid field on
  // submit — not part of the validation rules themselves
  final GlobalKey titleFieldKey = GlobalKey();
  final GlobalKey categoryFieldKey = GlobalKey();
  final GlobalKey dueDateFieldKey = GlobalKey();
  final GlobalKey descriptionFieldKey = GlobalKey();

  //
  //  file
  final Rxn<File> confirmationFile = Rxn();
  final RxnString confirmationFileSize = RxnString();

  final fileExtensionHelper = FileExtensionHelper();

  @override
  void onInit() {
    super.onInit();

    try {
      //
      final args = Get.arguments;

      if (args != null) {
        task.value = args as TaskEntity;
      }

      titleController.text = task.value?.title ?? "";
      categoryController.text = task.value?.category ?? "";

      final formattedDate = DateFormat('yyyy-MM-dd')
          .format(task.value?.dueDate ?? DateTime.now());
      dueDateController.text = formattedDate;

      descriptionController.text = task.value?.description ?? "";
    } catch (_) {}

    getTaskDropdowns();
  }

  Future<void> getTaskDropdowns() async {
    try {
      isLoading.value = true;
      final response = await getTaskDropdownUsecase(const NoParams());
      response.fold(
        (BaseResponse<List<TaskDropdownsEntity>> dropdowns) {
          taskDropdowns.value = dropdowns.data!;
          debugPrint("Task Dropdowns: ${taskDropdowns.length}");
          // set default reportTo to current logged user

          if (task.value == null) {
            selectedReportTo.value = taskDropdowns.firstWhereOrNull(
              (element) => element.id == authController.user.value?.id,
            );
          } else {
            selectedReportTo.value = taskDropdowns.firstWhereOrNull(
              (element) => element.id == task.value!.reportsTo?.id,
            );
            selectedAssignTo.value = taskDropdowns.firstWhereOrNull(
              (element) => element.id == task.value!.assignedTo?.id,
            );
          }
        },
        (Failure r) {
          debugPrint("Error: ${r.message}");
        },
      );
      isLoading.value = false;
    } catch (_) {
      isLoading.value = false;
    }
  }

  Future<void> createTask() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      //
      final dio.FormData data = _getTaskFormData();
      isSubmitting(true);
      final response = await createTaskUsecase.call(data);

      response.fold((result) {
        //
        if ((result.code == 200) && (result.data == true)) {
          try {
            if (Get.isRegistered<TaskManagementController>()) {
              Get.find<TaskManagementController>()
                  .refreshTasksListing("requested");
            }
          } catch (_) {}
          Get.back(result: true);
          CommonWidgets.showSnackBar(
            title: 'Success'.tr,
            message: result.message ?? "Task created successfully.",
            isError: false,
          );
        }
      }, (failure) {
        //
        CommonWidgets.showSnackBar(
          title: ''.tr,
          message: failure.message,
        );
      });
      isSubmitting(false);
    } catch (e) {
      //
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      isSubmitting(false);
    }
  }

  Future<void> updateTask() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      //
      final dio.FormData data = _getTaskFormData();
      isSubmitting(true);
      final response = await updateTaskUsecase.call(data);

      response.fold((result) {
        //
        if ((result.code == 200) && (result.data == true)) {
          try {
            task.value!.title = titleController.text;
            task.value!.category = categoryController.text;
            task.value!.description = descriptionController.text;
            if (selectedAssignTo.value != null) {
              task.value!.assignedTo?.id = selectedAssignTo.value?.id;
              task.value!.assignedTo?.name = selectedAssignTo.value?.name;
              task.value!.assignedTo?.image = selectedAssignTo.value?.image;
            }

            if (selectedReportTo.value != null) {
              task.value!.reportsTo?.id = selectedReportTo.value?.id;
              task.value!.reportsTo?.name = selectedReportTo.value?.name;
              task.value!.reportsTo?.image = selectedReportTo.value?.image;
            }

            if (pickedDate != null) {
              task.value!.dueDate = pickedDate;
              task.value!.updatedAt = DateTime.now();
            }

            if (Get.isRegistered<TaskManagementController>() &&
                task.value != null) {
              Get.find<TaskManagementController>().onTaskUpdated(task.value!);
            }

            if (Get.isRegistered<TaskDetailViewController>() &&
                task.value != null) {
              Get.find<TaskDetailViewController>().onTaskUpdated(task.value!);
            }
          } catch (_) {}
          Get.back(result: true);
          CommonWidgets.showSnackBar(
            title: 'Success'.tr,
            message: result.message ?? "Task updated successfully.",
            isError: false,
          );
        }
      }, (failure) {
        //
        CommonWidgets.showSnackBar(
          title: ''.tr,
          message: failure.message,
        );
      });
      isSubmitting(false);
    } catch (e) {
      //
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      isSubmitting(false);
    }
  }

  //todo improve this and make general function
  dio.FormData _getTaskFormData() {
    //
    // general details
    final title = titleController.text;
    final category = categoryController.text;
    final description = descriptionController.text;
    final dueDate =
        "${dueDateController.text} 00:00:00"; // adding 00 for seconds
    final assignTo = selectedAssignTo.value?.id;
    final reportTo = selectedReportTo.value?.id;

    //
    // from data map
    Map<String, dynamic> dataMap = {};
    if (task.value != null) {
      dataMap['id'] = task.value!.id;
    }
    dataMap['title'] = title;
    dataMap['category'] = category;
    dataMap['description'] = description;
    dataMap['due_date'] = dueDate;
    dataMap['assigned_to'] = assignTo;
    dataMap['reports_to'] = reportTo;

    //
    // adding confirmation file to data map
    if (confirmationFile.value != null) {
      final multipartFile = dio.MultipartFile.fromFileSync(
        confirmationFile.value!.path,
        filename: getConformationFileName(),
      );
      dataMap['file'] = multipartFile;
    }

    return dio.FormData.fromMap(dataMap);
  }

  void pickFile() async {
    try {
      //
      // pick file
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (filePickerResult != null) {
        PlatformFile pickedFile = filePickerResult.files.first;
        if (pickedFile.path != null) {
          confirmationFile.value = File(pickedFile.path!);
          confirmationFileSize.value = _formatFileSize(confirmationFile.value!);
        }
      }
    } catch (_) {}
  }

  void removeConfirmationFile() {
    confirmationFile.value = null;
    confirmationFileSize.value = null;
  }

  String? _formatFileSize(File file) {
    try {
      final int bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return null;
    }
  }

  /// Mirrors the same required-field rules already enforced by the form's
  /// validators — used only to scroll/focus toward the first invalid field
  /// after a failed submit, not to change what counts as valid.
  GlobalKey? get firstInvalidFieldKey {
    if (titleController.text.isEmpty) return titleFieldKey;
    if (categoryController.text.isEmpty) return categoryFieldKey;
    if (dueDateController.text.isEmpty) return dueDateFieldKey;
    if (descriptionController.text.isEmpty) return descriptionFieldKey;
    return null;
  }

  @override
  void onClose() {
    titleController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    titleFocusNode.dispose();
    categoryFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.onClose();
  }

  String getConformationFileIcon() {
    return fileExtensionHelper.getFileIcon(
      fileExtensionHelper.getFileType(confirmationFile.value?.path ?? "none"),
    );
  }

  bool confirmationFileIsImage() {
    final fileType = fileExtensionHelper.getFileType(
      confirmationFile.value?.path ?? "none",
    );
    return (fileType == FileTypes.jpeg ||
        fileType == FileTypes.jpg ||
        fileType == FileTypes.png);
  }

  String getConformationFileName() {
    return fileExtensionHelper.getFileName(
      confirmationFile.value?.path ?? "none",
      withExtension: true,
    );
  }
}
