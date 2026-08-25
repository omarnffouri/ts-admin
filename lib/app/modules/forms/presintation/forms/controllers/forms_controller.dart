// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import '../../../../../controllers/auth_controller.dart';
import '../../../../../services/injection_service.dart';
import '../../../domain/entities/form_entity.dart';
import '../../../domain/usecases/get_all_forms_usecase.dart';

class FormsController extends GetxController {
  final user = Get.find<AuthController>().user.value;

  final Rx<FormsTabs> _currentTab = FormsTabs.pending.obs;
  FormsTabs get currentTab => _currentTab.value;

  //
  //
  // edit text controllers
  final TextEditingController searchTextController = TextEditingController();

  //
  //
  // use cases
  final getAllFormsUsecase = sl<GetAllFormsUsecase>();

  //
  //
  // froms data lists
  final RxList<FormEntity> _forms = RxList<FormEntity>();
  List<FormEntity> get forms => _forms.value;

  final RxList<FormEntity> _signedForms = RxList<FormEntity>();
  List<FormEntity> get signedForms => _signedForms.value;

  final RxList<FormEntity> _pendingForms = RxList<FormEntity>();
  List<FormEntity> get pendingForms => _pendingForms.value;

  //
  //
  // search result lists
  final RxList<FormEntity> _filteredSignedForms = RxList<FormEntity>();
  List<FormEntity> get filteredSignedForms => _filteredSignedForms.value;

  final RxList<FormEntity> _filteredPendingForms = RxList<FormEntity>();
  List<FormEntity> get filteredPendingForms => _filteredPendingForms.value;

  //
  //
  // smart refresh controller
  RefreshController pendingFormsRefreshController = RefreshController(
    initialRefresh: false,
  );

  RefreshController signedFormsRrefreshController = RefreshController(
    initialRefresh: false,
  );

  //
  //
  // loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  //
  // states
  final RxBool isSearchEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllUserForms();

    // adding listener so check if search text is empty then load full list else apply search
    searchTextController.addListener(() {
      if (searchTextController.text.isEmpty) {
        isSearchEnabled(false);
        _filteredPendingForms.clear();
        _filteredSignedForms.clear();
      } else {
        applySearch();
      }
    });
  }

  // search by name
  void applySearch() {
    isSearchEnabled(true);

    _filteredPendingForms.clear();
    _filteredPendingForms.addAll(_pendingForms.where((item) {
      final name = item.applicantName
              ?.toLowerCase()
              .contains(searchTextController.text.toString().toLowerCase()) ??
          false;
      return name;
    }));

    _filteredSignedForms.clear();
    _filteredSignedForms.addAll(_signedForms.where((item) {
      final name = item.applicantName
              ?.toLowerCase()
              .contains(searchTextController.text.toString().toLowerCase()) ??
          false;
      return name;
    }));
  }

  void refreshFormsList() {
    _forms.refresh();
  }

  void handleRefresh() async {
    await getAllUserForms();
    pendingFormsRefreshController.refreshCompleted();
    signedFormsRrefreshController.refreshCompleted();
  }

  void switchTab(FormsTabs formsTabs) {
    if (currentTab != formsTabs) {
      _currentTab(formsTabs);
    }
  }

  void filterForms() {
    final List<FormEntity> pending = [];
    final List<FormEntity> signed = [];

    for (var form in forms) {
      if (form.isSigned ?? false) {
        signed.add(form);
      } else {
        pending.add(form);
      }
    }

    _pendingForms.value = pending;
    _signedForms.value = signed;
  }

  Future<void> getAllUserForms() async {
    try {
      _forms.clear();
      _isLoading(true);
      final result = await getAllFormsUsecase.call(const NoParams());

      result.fold((List<FormEntity> forms) {
        _forms.value = forms;
        log('forms list length: ${forms.length}');
        filterForms();
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
      _isLoading(false);
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoading(false);
    }
  }

  void clearSearch() {
    searchTextController.clear();
    _filteredPendingForms.clear();
    _filteredSignedForms.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

enum FormsTabs { pending, signed }
