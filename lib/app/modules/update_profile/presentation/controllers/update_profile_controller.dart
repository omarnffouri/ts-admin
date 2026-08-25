import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/image_helper.dart';
import 'package:ts_admin/app/core/helpers/shared_preferences_helper.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/update_profile/domain/entities/update_profile_data_entity.dart';
import 'package:ts_admin/app/modules/update_profile/domain/usecases/update_profile_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../../core/network/error/failures.dart';

class UpdateProfileController extends GetxController {
  final authController = Get.find<AuthController>();

  final updateProfileUsecase = sl<UpdateProfileUsecase>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final RxBool _isUpdatingProfile = false.obs;
  bool get isUpdatingProfile => _isUpdatingProfile.value;

  final RxnString filePath = RxnString();

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();

    firstNameController.text = authController.user.value?.firstName ?? "";
    lastNameController.text = authController.user.value?.lastName ?? "";
    phoneController.text = authController.user.value?.phone ?? "";
  }

  Future<void> updateProfile() async {
    if (firstNameController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Please enter a first name.",
      );
      return;
    }
    if (lastNameController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Please enter a last name.",
      );
      return;
    }
    if (phoneController.text.length < 11) {
      CommonWidgets.showSnackBar(
        title: 'Missing'.tr,
        message: "Please enter a valid phone number.",
      );
      return;
    }

    // api call
    try {
      // declaring variables
      Map<String, dynamic> dataMap = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "phone": phoneController.text.trim()
      };

      if (filePath.value?.isNotEmpty ?? false) {
        final multipartFile = dio.MultipartFile.fromFileSync(filePath.value!,
            filename: _getFileNameWithExtenshion(filePath.value!));
        dataMap['image'] = multipartFile;
      }

      // converting key map to form data for api
      final formData = dio.FormData.fromMap(dataMap);

      _isUpdatingProfile(true);

      // calling api
      final Either<BaseResponse<UpdateProfileDataEntity>, Failure> result =
          await updateProfileUsecase.call(formData);

      _isUpdatingProfile(false);

      result.fold((BaseResponse<UpdateProfileDataEntity> profile) {
        if (profile.code == 200 && profile.data != null) {
          CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: "Profile updated Successfully.",
              isError: false);
          _saveUseDetails(profile.data!);
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: "Something went wrong. Unable to update profile.",
          );
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isUpdatingProfile(false);
    }
  }

  _saveUseDetails(UpdateProfileDataEntity profile) async {
    final data = storage.read(UserPrefKeys.userDetails);
    final user = UserEntity.fromEntity(data);
    user.firstName = profile.firstName;
    user.lastName = profile.lastName;
    user.phone = profile.phone;
    user.name = "${profile.firstName} ${profile.lastName}";
    if (profile.image?.isNotEmpty ?? false) {
      user.image = profile.image;
    }

    authController.user.value = user;
    authController.user.refresh();
    // Both caches — the native call layer reads name/photo from the second.
    final String? token = storage.read(AuthenticationPrefKeys.token);
    await Future.wait([
      storage.write(UserPrefKeys.userDetails, user.toEntity()),
      if (token != null) SharedPrefrencesHelper.storeMyDetails(user, token),
    ]);
  }

  void pickImage() async {
    if (Platform.isIOS) {
      _pickImageIOS();
    } else if (Platform.isAndroid) {
      _pickImageAndroid();
    }
  }

  _pickImageIOS() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final croppedImage = await ImageHelper.cropProcess(File(file.path), [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5
      ]);
      if (croppedImage == null) {
        return;
      }
      filePath.value = croppedImage.path;
    }
  }

  _pickImageAndroid() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (files.isNotEmpty) {
        final croppedImage = await ImageHelper.cropProcess(files[0], [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5
        ]);
        if (croppedImage == null) {
          return;
        }
        filePath.value = croppedImage.path;
      }
    }
  }

  String _getFileNameWithExtenshion(String filePath) {
    var paths = filePath.split("/");
    if (paths.isNotEmpty) {
      return paths.last;
    } else {
      return "Unkown";
    }
  }
}
