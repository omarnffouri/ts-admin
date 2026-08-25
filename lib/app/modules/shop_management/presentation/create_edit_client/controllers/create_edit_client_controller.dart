import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/client_entity.dart';
import '../../../domain/usecases/create_edit_client.dart';
import '../../../domain/usecases/used_part/create_or_edit_used_client_usecase.dart';
import '../../shop_clients/controllers/shop_clients_controller.dart';

class CreateEditClientController extends GetxController {
  // usecase
  final createOrEditClientUsecase = sl<CreateOrEditClientUsecase>();
  //- used part
  final createOrEditUsedClientUsecase = sl<CreateOrEditUsedClientUsecase>();

  // add rxn for client entity
  final clientEntity = Rxn<ClientEntity>();

  // form key and text controller
  final formKey = GlobalKey<FormState>();

  // Text Controllers for each input field
  final companyNameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final taxReferenceController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  // Focus nodes, used only to move the keyboard through the fields in order
  final FocusNode companyNameFocusNode = FocusNode();
  final FocusNode contactPersonFocusNode = FocusNode();
  final FocusNode taxReferenceFocusNode = FocusNode();
  final FocusNode contactNumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

  // Field keys used purely to scroll/focus toward the first invalid field on
  // submit — the validation rules themselves live on the fields
  final GlobalKey<FormFieldState<String>> companyNameFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> contactPersonFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> taxReferenceFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> contactNumberFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> emailFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> addressFieldKey = GlobalKey();

  /// The fields in visual order, paired with their focus node — used after a
  /// failed validation to reach the first field that reported an error.
  List<MapEntry<GlobalKey<FormFieldState<String>>, FocusNode>>
      get orderedFormFields => [
            MapEntry(companyNameFieldKey, companyNameFocusNode),
            MapEntry(contactPersonFieldKey, contactPersonFocusNode),
            MapEntry(taxReferenceFieldKey, taxReferenceFocusNode),
            MapEntry(contactNumberFieldKey, contactNumberFocusNode),
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
    debugPrint('createEditClientController onInit');
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      isUsedPart.value = arguments['isUsedPart'] ?? false;
      // if get arguments is not null, then set the client entity
      final client = Get.arguments['client'];
      if (client != null && client is ClientEntity) {
        clientEntity.value = client;
        isUpdating.value = true;
        _setTextControllers(client);
      }
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

    createOrEditClient();
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

  Future<void> createOrEditClient() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    isSubmitting.value = true;
    try {
      final body = {
        "company_name": companyNameController.text,
        "contact_person": contactPersonController.text,
        "contact_number": contactNumberController.text,
        "email": emailController.text,
        "address": addressController.text,
        "tax_number": taxReferenceController.text,
      };

      // If updating, include the supplier ID
      if (isUpdating.value && clientEntity.value?.id != null) {
        body["id"] = clientEntity.value!.id.toString();
      }

      final result = isUsedPart.value
          ? await createOrEditUsedClientUsecase.call(body)
          : await createOrEditClientUsecase.call(body);
      result.fold(
        (bool success) {
          if (success) {
            CommonWidgets.showSnackBar(
                title: 'Success',
                message: isUpdating.value
                    ? 'Client updated successfully'.tr
                    : 'Client created successfully'.tr,
                isError: false);
            Navigator.of(Get.context!).pop();
            Get.put(ShopClientsController()).getAllClients(
              isUsedPart: isUsedPart.value,
            );
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error',
              message: isUpdating.value
                  ? 'Failed to update Client'.tr
                  : 'Failed to create Client'.tr,
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

  void _setTextControllers(ClientEntity client) {
    companyNameController.text = client.companyName ?? '';
    contactPersonController.text = client.contactPerson ?? '';
    contactNumberController.text = client.contactNumber ?? '';
    emailController.text = client.email ?? '';
    addressController.text = client.address ?? '';
    taxReferenceController.text = client.taxNumber ?? '';
  }

  // Method to clear all the text controllers
  void clearForm() {
    companyNameController.clear();
    contactPersonController.clear();
    contactNumberController.clear();
    emailController.clear();
    addressController.clear();
    taxReferenceController.clear();
  }

  @override
  void onClose() {
    // Dispose of all controllers when the controller is closed
    companyNameController.dispose();
    contactPersonController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    taxReferenceController.dispose();
    companyNameFocusNode.dispose();
    contactPersonFocusNode.dispose();
    taxReferenceFocusNode.dispose();
    contactNumberFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    super.onClose();
  }
}
