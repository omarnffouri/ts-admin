import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/create_technician.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/edit_technician.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/technicians/controllers/technicians_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class CreateEditTechnicianController extends GetxController {
  //
  //
  // usecases
  final createTechnicianUsecase = sl<CreateTechnicianUsecase>();
  final editTechnicianUsecase = sl<EditTechnicianUsecase>();

  // add rxn for technician entity
  final technicianEntity = Rxn<TechnicianEntity>();

  // form key and text controller
  final formKey = GlobalKey<FormState>();

  // Text Controllers for each input field
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // Focus nodes, used only to move the keyboard through the fields in order
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();

  // Field keys used purely to scroll/focus toward the first invalid field on
  // submit — the validation rules themselves live on the fields
  final GlobalKey<FormFieldState<String>> firstNameFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> lastNameFieldKey = GlobalKey();

  /// The fields in visual order, paired with their focus node — used after a
  /// failed validation to reach the first field that reported an error.
  List<MapEntry<GlobalKey<FormFieldState<String>>, FocusNode>>
      get orderedFormFields => [
            MapEntry(firstNameFieldKey, firstNameFocusNode),
            MapEntry(lastNameFieldKey, lastNameFocusNode),
          ];

  // variables
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();

    try {
      // if get arguments is not null,
      // then set the technician entity
      final technician = Get.arguments;
      if (technician != null && technician is TechnicianEntity) {
        technicianEntity.value = technician;
        firstNameController.text = technicianEntity.value?.firstName ?? "";
        lastNameController.text = technicianEntity.value?.lastName ?? "";
      }
    } catch (_) {}
  }

  void onSubmit() {
    if (isSubmitting.value) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final bool isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      _revealFirstInvalidField();
      return;
    }

    createOrEditSupplier();
  }

  /// Scrolls to — and focuses — the first field that reported an error, so a
  /// failure below the fold is never silent.
  void _revealFirstInvalidField() {
    for (final field in orderedFormFields) {
      final FormFieldState<String>? state = field.key.currentState;
      if (state == null || !state.hasError) {
        continue;
      }

      final BuildContext? fieldContext = field.key.currentContext;
      if (fieldContext != null) {
        Scrollable.ensureVisible(
          fieldContext,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: 0.1,
        );
      }
      field.value.requestFocus();
      return;
    }
  }

  Future<void> createOrEditSupplier() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    final isUpdating = technicianEntity.value?.id != null;
    isSubmitting.value = true;
    try {
      var body = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
      };

      // If updating, include the technician ID
      if (isUpdating) {
        body["id"] = technicianEntity.value!.id.toString();
      }

      final result = isUpdating
          ? await editTechnicianUsecase.call(body)
          : await createTechnicianUsecase.call(body);

      result.fold(
        (bool success) {
          if (success) {
            CommonWidgets.showSnackBar(
                title: 'Success',
                message: isUpdating
                    ? 'Technician updated successfully'.tr
                    : 'Technician created successfully'.tr,
                isError: false);
            Navigator.of(Get.context!).pop();
            Get.put(TechniciansController()).getAllTechnicians();
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error',
              message: isUpdating
                  ? 'Failed to update Technician'.tr
                  : 'Failed to create Technician'.tr,
            );
          }
        },
        (Failure e) {
          CommonWidgets.showSnackBar(
            title: 'Error',
            message: e.toString(),
          );
        },
      );
      isSubmitting.value = false;
    } catch (e) {
      isSubmitting.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  // The text controllers keep their existing disposal in dispose(); the focus
  // nodes are released from onClose(), GetX's own teardown hook.
  @override
  void onClose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
