import 'dart:io';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/announcement_topic.dart';
import '../../../domain/entities/user_type_entity.dart';
import '../../../domain/usecases/create_announcement_usecase.dart';
import '../../../domain/usecases/get_announcements_user_types_usecase.dart';

/// How a "Drivers" announcement is targeted: hand-pick individual drivers
/// ([specific]) or broadcast to an application-status topic ([topic]).
enum DriverAudienceMode { specific, topic }

class CreateAnnouncementController extends GetxController {
  // usecases
  final createAnnouncementUsecase = sl<CreateAnnouncementUsecase>();
  final getAnnouncementUserTypes = sl<GetAnnouncementUserTypeUsecase>();

  // leading and variables
  final usersDropdown = Rxn<UserTypeEntity>();
  final selectedCategoryType = Rxn<String>(null);
  final selectedUsers = RxList<ItemEntity>();
  // Drivers can be targeted either by hand-picking users ([specific]) or by
  // broadcasting to an application-status topic ([topic]) — never both.
  final audienceMode = DriverAudienceMode.specific.obs;
  final selectedTopic = Rxn<AnnouncementTopic>();
  final announcementFile = Rxn<File>();
  final announcementFileSize = RxnString();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Controllers
  final titleController = TextEditingController();
  final htmlController = QuillController.basic();

  // file helper
  final fileExtensionHelper = FileExtensionHelper();

  @override
  void onInit() {
    super.onInit();
    getUserTypesDropdown();
  }

  Future<void> getUserTypesDropdown() async {
    try {
      isLoading(true);
      final response = await getAnnouncementUserTypes(const NoParams());
      response.fold((UserTypeEntity response) {
        usersDropdown.value = response;
        debugPrint('User Types: ${usersDropdown.value}');
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> createAnnouncement() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      //
      final dio.FormData? data = await _prepareFormData();
      if (data == null) {
        return;
      }
      debugPrint('data: ${data.fields}');
      isSubmitting(true);
      final response = await createAnnouncementUsecase.call(data);
      response.fold((result) async {
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: 'Announcement created successfully'.tr,
          isError: false,
        );
        Navigator.pop(Get.context!);
      }, (failure) {
        //
        CommonWidgets.showSnackBar(
          title: ''.tr,
          message: failure.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isSubmitting(false);
    }
  }

  // Helper function to prepare form data
  Future<dio.FormData?> _prepareFormData() async {
    // General details
    final title = titleController.text.trim();
    if (!_validateField(title, 'title', 'Please select a title')) {
      return null;
    }

    final type = selectedCategoryType.value;
    if (!_validateField(type, 'user type', 'Please select a user type')) {
      return null;
    }

    List deltaJson = htmlController.document.toDelta().toJson();
    final description = DeltaToHTML.encodeJson(deltaJson).trim();
    if (!_validateField(
      description,
      'description',
      'Please enter a description',
      minLength: 5,
    )) {
      return null;
    }

    // Prepare data map
    final Map<String, dynamic> dataMap = {
      'title': title,
      'body': description,
      'type': type!.toLowerCase(),
    };

    // Drivers can be broadcast to an application-status topic instead of
    // hand-picking users — topic replaces the explicit id selection.
    if (_isDriversType(type) &&
        audienceMode.value == DriverAudienceMode.topic) {
      final topic = selectedTopic.value?.value;
      if (!_validateField(topic, 'topic', 'Please select a topic')) {
        return null;
      }
      dataMap['topics'] = topic;
    } else {
      _addUsersToDataMap(dataMap, type);
    }

    // Add file if available
    if (announcementFile.value != null) {
      try {
        final path = announcementFile.value!.path;
        final multipartFile = dio.MultipartFile.fromFileSync(
          path,
          filename: getFileNameWithExtenshion(path),
        );
        dataMap['imageFile'] = multipartFile;
      } catch (e) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: 'Failed to process the file. Please try again.'.tr,
        );
        return null;
      }
    }

    // Return FormData
    return dio.FormData.fromMap(dataMap);
  }

// Helper function to validate fields
  bool _validateField(String? field, String fieldName, String errorMessage,
      {int minLength = 1}) {
    if (field == null ||
        field.trim().isEmpty ||
        field.trim().length < minLength) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: errorMessage.tr,
      );
      return false;
    }
    return true;
  }

// Helper function to add users to data map based on type
  void _addUsersToDataMap(Map<String, dynamic> dataMap, String type) {
    final userList = selectedUsers.toList();
    final userKey = type.toLowerCase();
    if (userKey == 'admins' || userKey == 'drivers') {
      userList.asMap().forEach((index, user) {
        dataMap['$userKey[$index]'] = user.id;
      });
    }
  }

  bool _isDriversType(String? type) => type?.toLowerCase() == 'drivers';

  // Whether the topic feature (drivers-only) applies to the current selection.
  bool get isDriversType => _isDriversType(selectedCategoryType.value);

  bool get isTopicMode => audienceMode.value == DriverAudienceMode.topic;

  // The driver multi-select is hidden while broadcasting by topic.
  bool get showUserMultiSelect {
    if (selectedCategoryType.value == null) return false;
    return !(isDriversType && isTopicMode);
  }

  /// Resets the topic/mode state whenever the user type changes.
  void onCategoryTypeChanged(String? value) {
    selectedCategoryType.value = value;
    selectedUsers.clear();
    selectedTopic.value = null;
    audienceMode.value = DriverAudienceMode.specific;
    selectedCategoryType.refresh();
  }

  /// Switches between hand-picking drivers and broadcasting by topic,
  /// clearing the other side's selection to keep them mutually exclusive.
  void setAudienceMode(DriverAudienceMode mode) {
    if (audienceMode.value == mode) return;
    audienceMode.value = mode;
    if (mode == DriverAudienceMode.topic) {
      selectedUsers.clear();
    } else {
      selectedTopic.value = null;
    }
  }

  List<ItemEntity> get getUnitlist {
    final type = selectedCategoryType.value?.toLowerCase();
    if (type == 'admins') return usersDropdown.value?.users ?? const [];
    if (type == 'drivers') return usersDropdown.value?.applicants ?? const [];
    return const [];
  }

  /// Attachments are image-only — gallery (images, no videos) + camera.
  void showAnnouncementAttachmentBottomSheet(ThemeData theme) {
    MediaPicker.showAttachmentBottomSheet(
      onImagePicked: (file) {
        if (file != null) setAnnouncementFile(file);
      },
      onCameraPicked: (file) {
        if (file != null) setAnnouncementFile(file);
      },
    );
  }

  void setAnnouncementFile(File file) {
    announcementFile.value = file;
    announcementFileSize.value = _formatFileSize(file);
  }

  void removeAnnouncementFile() {
    announcementFile.value = null;
    announcementFileSize.value = null;
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

  @override
  void onClose() {
    try {
      titleController.dispose();
      htmlController.dispose();
    } catch (_) {}
    super.onClose();
  }
}
