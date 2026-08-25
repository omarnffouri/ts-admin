import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:signature/signature.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/attachment_helper.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/domain/usecases/reject_form_usecase.dart';
import 'package:ts_admin/app/modules/forms/domain/usecases/sign_form_usecase.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/views/components/form_rejection_bottom_sheet_view.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/controllers/forms_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class FormDetailViewController extends GetxController {
  FormEntity? form;

  final isKeyboardHidden = true.obs;

  TextEditingController rejectionReasonController = TextEditingController();

  final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

  //
  // sigining state
  final RxBool _isSigning = false.obs;
  bool get isSigning => _isSigning.value;

  final RxBool _isSigned = false.obs;
  bool get isSigned => _isSigned.value;

  final RxBool _isRejecting = false.obs;
  bool get isRejecting => _isRejecting.value;

  final signFormUsecase = sl<SignFormUsecase>();
  final rejectFormUsecase = sl<RejectFormUsecase>();
  //
  //
  // signature pad controller
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.grey[100],
  );

  final ItemScrollController scrollController = ItemScrollController();

  @override
  void onInit() {
    super.onInit();
    try {
      form = (Get.arguments as FormEntity);
      _isSigned(form?.isSigned ?? false);
    } catch (_) {
      Get.back();
    }
  }

  Future<void> saveAndContinue() async {
    // check the fields validation
    if (form!.formGlobalKey.currentState!.validate() == false) {
      debugPrint('is NOT valid ');
      // FocusManager.instance.primaryFocus?.unfocus();
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: 'Some Fields are required!',
      );
      jumpToFirstRequiredField();
      return;
    }

    //check the signature validation
    if (signatureController.isEmpty) {
      debugPrint('error you need to sign first ');
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: 'You need to Sign First',
      );
      return;
    }

    // convert signature to base64
    final Uint8List? bytes = await signatureController.toPngBytes();
    String base64Image = getSignatureBase64(bytes);
    debugPrint(base64Image);

    final body = {
      "violation_id": form!.violationId,
      "applicant_form_id": form!.applicantFormId,
      "signature": base64Image,
    };

    // integrate signed form with backend
    try {
      _isSigning(true);
      final Either<bool, Failure> result = await signFormUsecase.call(body);

      result.fold((bool succ) {
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: 'Form submitted successfully.',
          isError: false,
        );

        //clear the signature pad
        signatureController.clear();

        Navigator.of(Get.context!).pop();

        // going back to the forms and update list
        Get.put(FormsController()).getAllUserForms();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
      _isSigning(false);
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      _isSigning(false);
    }
  }

  onSubmitTextField(int index, FormEntity currentForm) {
    if ((index + 1) < (currentForm.formFields?.length ?? 0)) {
      for (int i = (index + 1);
          i < (currentForm.formFields?.length ?? 0);
          i++) {
        if ((currentForm.formFields![i].type == "string" ||
                currentForm.formFields![i].type == "textarea") &&
            (currentForm.formFields![i].formFieldsValue?.value.isEmpty ??
                true)) {
          scrollController.scrollTo(
              index: i, duration: const Duration(milliseconds: 500));
          currentForm.formFields![i].focusNode.requestFocus();
          break;
        }
      }
    }
  }

  void jumpToFirstRequiredField() {
    for (int i = 0; i < (form!.formFields?.length ?? 0); i++) {
      if ((form!.formFields![i].type == "string" ||
              form!.formFields![i].type == "textarea") &&
          (form!.formFields![i].textEditingController.text.isEmpty)) {
        scrollController.scrollTo(
            index: i, duration: const Duration(milliseconds: 500));
        form!.formFields![i].focusNode.requestFocus();
        break;
      }
    }
  }

  Future<void> rejectForm() async {
    //
    //
    // hceking if reason is empty show error message
    if (rejectionReasonController.text.trim().isEmpty) {
      CommonWidgets.showSnackBar(
          title: "Field Required",
          message: "Please enter the rejection reason.",
          isError: false);
      return;
    }

    Get.back();

    final body = {
      'status': 'rejected',
      'reason': rejectionReasonController.text,
      'violation_form_id': form!.violationId
    };

    // integrate signed form with backend
    try {
      _isRejecting(true);
      final Either<bool, Failure> result = await rejectFormUsecase.call(body);

      result.fold((bool succ) {
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: 'Form rejected successfully.',
          isError: false,
        );

        // update is signed status
        try {
          if (Get.isRegistered<FormsController>()) {
            final formsController = Get.find<FormsController>();
            formsController.forms
                .firstWhere((element) => element.formId == form!.formId)
                .isSigned = true;

            formsController.refreshFormsList();
          }
        } catch (_) {}

        Navigator.of(Get.context!).pop();

        // going to the next form and update the page
        // getAllUserForms();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
      _isRejecting(false);
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      _isRejecting(false);
    }
  }

  void launchAttachment(
    FormAttachmentEntity formAttachmentEntity,
    int index,
    String attachmentType,
  ) async {
    try {
      final launcher = AttachmentLauncherFactory.getLauncher(
        formAttachmentEntity,
        attachmentType,
      );
      await launcher.launch(formAttachmentEntity);
    } catch (e) {
      debugPrint("Error launching attachment: $e");
      Get.snackbar(
        "Error",
        "Failed to launch attachment",
      );
    }
  }

  showFormRejectionBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor:
          Get.isDarkMode ? AppColorsDark.scaffoldBackroundColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const FormRejectionBottomSheet();
      },
    );
  }
}

class FormAttachmentType {
  static const video = "video";
  static const attachment = "attachment";
  static const otherDocuments = "otherDocumnets";
  static const none = "none";
}
