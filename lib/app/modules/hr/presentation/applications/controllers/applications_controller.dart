import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_entity.dart';
import 'package:ts_admin/app/modules/hr/domain/params/get_applications_params.dart';
import 'package:ts_admin/app/modules/hr/domain/usecases/get_applications_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ApplicationsController extends GetxController {
  final authController = Get.find<AuthController>();

  final TextEditingController searchController = TextEditingController();

  final List<ApplicationStatuses> statuses = [
    ApplicationStatuses.all,
    ApplicationStatuses.underReview,
    ApplicationStatuses.phoneScreening,
    ApplicationStatuses.inProcess,
    ApplicationStatuses.approved,
    ApplicationStatuses.hired,
    ApplicationStatuses.onHold,
    ApplicationStatuses.rejected,
    ApplicationStatuses.terminated,
  ];

  //
  //
  // usecases
  final getApplicationsUsecase = sl<GetApplicationsUsecase>();

  //
  //
  // refresh controllers
  RefreshController refreshController = RefreshController();

  //
  //
  // data variables
  final RxList<ApplicationEntity> applications = RxList();

  final RxInt page = 1.obs;

  final Rx<ApplicationStatuses> selectedStatus = ApplicationStatuses.all.obs;

  //
  //
  // states
  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;

  final RxBool _isLoadingApplications = false.obs;
  bool get isLoadingApplications => _isLoadingApplications.value;

  final RxBool _isLoadingMore = false.obs;
  bool get isLoadingMore => _isLoadingMore.value;

  final RxBool _hasMoreData = false.obs;
  bool get hasMoreData => _hasMoreData.value;

  //
  //
  @override
  void onInit() {
    super.onInit();

    selectedStatus.listen((status) {
      _loadInitialData();
    });

    _loadInitialData();
  }

  void toggleSearch() {
    _isSearchEnabled.toggle();
  }

  onSearch() {
    EasyDebounce.debounce('search', const Duration(milliseconds: 500), () {
      _loadInitialData();
    });
  }

  handleRefesh() async {
    _loadInitialData();
    refreshController.refreshCompleted();
  }

  _loadInitialData() async {
    _hasMoreData.value = false;
    page.value = 1;

    applications.clear();

    _isLoadingApplications.value = true;

    final data = await _getApplications(_getRequestBody());

    if (data != null) {
      _hasMoreData.value = data.hasMore ?? false;
      applications.clear();
      applications.addAll(data.data ?? []);
    }
    _isLoadingApplications.value = false;
  }

  GetApplicationsParams _getRequestBody() {
    final body = GetApplicationsParams();

    //
    // adding status if any status is selected other than all
    if (selectedStatus.value != ApplicationStatuses.all) {
      body.status = applicationStatuses.reverse[selectedStatus.value];
    }

    //
    // adding search if search text exist
    if (searchController.text.isNotEmpty) {
      body.search = searchController.text.trim();
    }

    //
    // adding page number
    body.page = page.value;

    return body;
  }

  Future<BaseResponse<List<ApplicationEntity>>?> _getApplications(
      GetApplicationsParams params) async {
    BaseResponse<List<ApplicationEntity>>? data;
    try {
      debugPrint('Body: $params');
      final response = await getApplicationsUsecase.call(params);
      response.fold((BaseResponse<List<ApplicationEntity>> response) {
        debugPrint('Response length: ${response.data?.length}');
        debugPrint('Response has more: ${response.hasMore}');
        data = response;
      }, (failure) {
        CommonWidgets.showSnackBar(
          title: "Error",
          message: failure.message.isNotEmpty
              ? failure.message
              : "Unable to load applications.",
        );
      });
    } catch (_) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Unable to load applications.",
      );
    }
    return data;
  }

  loadMoreApplications() async {
    if ((!hasMoreData) || isLoadingMore) {
      return;
    }

    page.value = page.value + 1;

    _isLoadingMore.value = true;

    final data = await _getApplications(_getRequestBody());

    if (data != null) {
      _hasMoreData.value = data.hasMore ?? false;
      applications.addAll(data.data ?? []);
    } else {
      if (page.value > 1) {
        page.value = page.value - 1;
      }
    }

    _isLoadingMore.value = false;
  }
}
