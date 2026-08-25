import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/supplier_entity.dart';
import '../../../domain/usecases/create_supplier.dart';
import '../../../domain/usecases/edit_supplier.dart';
import '../../../domain/usecases/used_part/create_used_supplier_usecase.dart';
import '../../../domain/usecases/used_part/edit_used_supplier_usecase.dart';
import '../../shop_suppliers/controllers/shop_suppliers_controller.dart';

class CreateEditSupplierController extends GetxController {
  // usecase
  final createSupplierUsecase = sl<CreateSupplierUsecase>();
  final editSupplierUsecase = sl<EditSupplierUsecase>();
  //- used part
  final createUsedSupplierUsecase = sl<CreateUsedSupplierUsecase>();
  final editUsedSupplierUsecase = sl<EditUsedSupplierUsecase>();

  // add rxn for supplier entity
  final supplierEntity = Rxn<SupplierEntity>();

  // form key and text controller
  final formKey = GlobalKey<FormState>();

  // Text Controllers for each input field
  final nameController = TextEditingController();
  final representativeController = TextEditingController();
  final taxReferenceController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  // Focus nodes, used only to move the keyboard through the fields in order
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode representativeFocusNode = FocusNode();
  final FocusNode taxReferenceFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

  // Field keys used purely to scroll/focus toward the first invalid field on
  // submit — the validation rules themselves live on the fields
  final GlobalKey<FormFieldState<String>> nameFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> representativeFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> taxReferenceFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> phoneFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> emailFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> addressFieldKey = GlobalKey();

  /// The fields in visual order, paired with their focus node — used after a
  /// failed validation to reach the first field that reported an error.
  List<MapEntry<GlobalKey<FormFieldState<String>>, FocusNode>>
      get orderedFormFields => [
            MapEntry(nameFieldKey, nameFocusNode),
            MapEntry(representativeFieldKey, representativeFocusNode),
            MapEntry(taxReferenceFieldKey, taxReferenceFocusNode),
            MapEntry(phoneFieldKey, phoneFocusNode),
            MapEntry(emailFieldKey, emailFocusNode),
            MapEntry(addressFieldKey, addressFocusNode),
          ];

  // variables
  final RxBool isSubmitting = false.obs;
  final isUpdating = false.obs;
  final isUsedPart = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('CreateSupplierController onInit');

    // if get arguments is not null, then set the supplier entity
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      isUsedPart.value = arguments['isUsedPart'] ?? false;
      final supplier = arguments['supplier'];
      if (supplier != null && supplier is SupplierEntity) {
        supplierEntity.value = supplier;
        isUpdating.value = true;
        _setTextControllers(supplier);
      }
    }
  }

  Future<void> createOrEditSupplier() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    isSubmitting.value = true;
    try {
      final body = {
        "name": nameController.text,
        "representative": representativeController.text,
        "tax_reference": taxReferenceController.text,
        "phone": phoneController.text,
        "email": emailController.text,
        "address": addressController.text,
      };

      // If updating, include the supplier ID
      if (isUpdating.value && supplierEntity.value?.id != null) {
        body["id"] = supplierEntity.value!.id.toString();
      }

      final result = isUpdating.value
          ? (isUsedPart.value
              ? await editUsedSupplierUsecase.call(body)
              : await editSupplierUsecase.call(body))
          : (isUsedPart.value
              ? await createUsedSupplierUsecase.call(body)
              : await createSupplierUsecase.call(body));
      result.fold(
        (bool success) {
          if (success) {
            CommonWidgets.showSnackBar(
                title: 'Success',
                message: isUpdating.value
                    ? 'Supplier updated successfully'.tr
                    : 'Supplier created successfully'.tr,
                isError: false);
            Navigator.of(Get.context!).pop();
            Get.put(ShopSuppliersController()).getAllSuppliers(
              isUsedPart: isUsedPart.value,
            );
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error',
              message: isUpdating.value
                  ? 'Failed to update Supplier'.tr
                  : 'Failed to create Supplier'.tr,
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

  void _setTextControllers(SupplierEntity supplier) {
    nameController.text = supplier.name ?? '';
    representativeController.text = supplier.representative ?? '';
    taxReferenceController.text = supplier.taxReference ?? '';
    phoneController.text = supplier.phone ?? '';
    emailController.text = supplier.email ?? '';
    addressController.text = supplier.address ?? '';
  }

  // Method to clear all the text controllers
  void clearForm() {
    nameController.clear();
    representativeController.clear();
    taxReferenceController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
  }

  @override
  void onClose() {
    // Dispose of all controllers when the controller is closed
    nameController.dispose();
    representativeController.dispose();
    taxReferenceController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    nameFocusNode.dispose();
    representativeFocusNode.dispose();
    taxReferenceFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    super.onClose();
  }
}
