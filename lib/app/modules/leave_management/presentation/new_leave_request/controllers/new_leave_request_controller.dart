import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:signature/signature.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/leave_management/domain/entities/eligibility_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/alternative_user_entity.dart';
import '../../../domain/entities/leave_type_entity.dart';
import '../../../domain/entities/remaining_leave_category_entity.dart';
import '../../../domain/entities/super_visor_entity.dart';
import '../../../domain/usecases/check_eligibility_usecase.dart';
import '../../../domain/usecases/get_all_leave_types_usecase.dart';
import '../../../domain/usecases/get_all_super_visors_usecase.dart';
import '../../../domain/usecases/get_alternative_users_usecase.dart';
import '../../../domain/usecases/get_remaining_leaves_per_category_usecase.dart';
import '../../../domain/usecases/submit_leave_request_usecase.dart';

class NewLeaveRequestController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rxn<UserEntity> _user = Get.find<AuthController>().user;
  UserEntity? get user => _user.value;

  //! Usecases
  final getAllLeaveTypesUsecase = sl<GetAllLeaveTypesUsecase>();
  final getAllSuperVisorsUsecase = sl<GetAllSuperVisorsUsecase>();
  final checkEligibilityUsecase = sl<CheckEligibilityUsecase>();
  final getAlternativeUsersUsecase = sl<GetAlternativeUsersUsecase>();
  final submitUsecase = sl<SubmitLeaveRequestUsecase>();

  //  controllers
  late AnimationController animationController;
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  // add list of strings
  final selectedLeaveType = "".obs;
  final selectedManager = "".obs;

  // Check if selected leave type contains "sick"
  bool get isSickLeave =>
      selectedLeaveType.value.toLowerCase().contains('sick');
  final leaveTypes = <String>[].obs;
  final managers = <String>[].obs;

  final users = RxList<AlternativeUserEntity>();
  final selectedUsers = RxList<AlternativeUserEntity>();
  final leaveList = RxList<LeaveTypeEntity>();
  final superList = RxList<SupervisorEntity>();
  final elegibilityText = ''.obs;

  final RxBool isEligible = false.obs;
  final eligibility = const EligibilityEntity().obs;

  final _isSubmitting = false.obs;
  bool get isSubmitting => _isSubmitting.value;

  // text controllers
  DateTimeRange? selectedDateRange;
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonTxtController = TextEditingController();

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Get.isDarkMode ? Colors.white : Colors.black,
    exportBackgroundColor: Colors.grey[100],
  );

  final RxBool isLeaveTypesLoading = false.obs;
  final RxBool isSupervisorsLoading = false.obs;
  final RxBool isCheckEligibilityLoading = false.obs;
  final RxBool isLoadingUsers = false.obs;

  final RxBool errorWhileLoadingLeaveTypes = false.obs;
  final RxBool errorWhileLoadingSupervisors = false.obs;
  final RxBool errorWhileLoadingUsers = false.obs;
  final RxBool errorWhileLoadingRemaining = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    debugPrint(">>>>> LeaveManagementController onInit <<<<<<");
    getUsersDropdowns();
    getAllLeaveTypes();
    getAllSupervisors();
    getRemainingLeavesPerCategory();
  }

  ///fetch leave balance
  final getRemainingLeavesPerCategoryUsecase =
      sl<GetRemainingLeavesPerCategoryUsecase>();

  final categories = RxList<RemainingLeaveCategoryEntity>();
  final RxBool isRemainingLoading = false.obs;

  Future<void> getRemainingLeavesPerCategory() async {
    if (isRemainingLoading.value) return;
    try {
      isRemainingLoading(true);
      errorWhileLoadingRemaining(false);
      final Either<List<RemainingLeaveCategoryEntity>, Failure> result =
          await getRemainingLeavesPerCategoryUsecase.call(const NoParams());
      isRemainingLoading(false);
      result.fold(
        (List<RemainingLeaveCategoryEntity> list) {
          categories.value = list;
        },
        (Failure r) {
          errorWhileLoadingRemaining(true);
          debugPrint("Error loading remaining leaves: ${r.message}");
        },
      );
    } catch (e) {
      isRemainingLoading(false);
      errorWhileLoadingRemaining(true);
      debugPrint(e.toString());
    }
  }

  Future<void> getUsersDropdowns() async {
    if (isLoadingUsers.value) return;
    try {
      isLoadingUsers.value = true;
      errorWhileLoadingUsers(false);
      final response = await getAlternativeUsersUsecase(const NoParams());
      response.fold(
        (List<AlternativeUserEntity> dropdowns) {
          users.value = dropdowns;
        },
        (Failure r) {
          errorWhileLoadingUsers(true);
          debugPrint("Error: ${r.message}");
        },
      );
      isLoadingUsers.value = false;
    } catch (_) {
      isLoadingUsers.value = false;
      errorWhileLoadingUsers(true);
    }
  }

  Future<void> getAllLeaveTypes() async {
    if (isLeaveTypesLoading.value) return;
    try {
      isLeaveTypesLoading(true);
      errorWhileLoadingLeaveTypes(false);
      final Either<List<LeaveTypeEntity>, Failure> result =
          await getAllLeaveTypesUsecase.call(const NoParams());
      isLeaveTypesLoading(false);
      result.fold((List<LeaveTypeEntity> list) {
        var uniqueTypes = <String>{};
        var uniqueLeaveTypes = <LeaveTypeEntity>[];

        for (var leaveType in list) {
          if (leaveType.type != null && !uniqueTypes.contains(leaveType.type)) {
            uniqueTypes.add(leaveType.type!);
            uniqueLeaveTypes.add(leaveType);
          }
        }

        leaveList.value = uniqueLeaveTypes;
        leaveTypes.clear();
        leaveTypes.addAll(uniqueLeaveTypes.map((e) => e.type!).toList());
        log('LeaveTypes length: ${leaveList.length}');
      }, (Failure r) {
        errorWhileLoadingLeaveTypes(true);
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } on Exception catch (e) {
      errorWhileLoadingLeaveTypes(true);
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      isLeaveTypesLoading(false);
    }
  }

  Future<void> getAllSupervisors() async {
    if (isSupervisorsLoading.value) return;
    try {
      isSupervisorsLoading(true);
      errorWhileLoadingSupervisors(false);
      final body = {
        'user_id': user!.id.toString(),
      };
      final Either<List<SupervisorEntity>, Failure> result =
          await getAllSuperVisorsUsecase.call(body);
      isSupervisorsLoading(false);
      result.fold((List<SupervisorEntity> list) {
        var uniqueTypes = <String>{};
        var uniqueSupervisors = <SupervisorEntity>[];
        for (var supervisor in list) {
          if (supervisor.name != null &&
              !uniqueTypes.contains(supervisor.name)) {
            uniqueTypes.add(supervisor.name!);
            uniqueSupervisors.add(supervisor);
          }
        }
        superList.value = uniqueSupervisors;
        managers.clear();
        managers.addAll(uniqueSupervisors.map((e) => e.name!).toList());
        log('Supervisors length: ${superList.length}');
      }, (Failure r) {
        errorWhileLoadingSupervisors(true);
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      errorWhileLoadingSupervisors(true);
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      isSupervisorsLoading(false);
    }
  }

  /// Re-runs every lookup the form depends on. Only dropdown sources and the
  /// balance strip are refetched — typed reason, picked dates and the drawn
  /// signature are left untouched, so this is safe to trigger mid-entry.
  Future<void> handleRefresh() async {
    await Future.wait([
      getUsersDropdowns(),
      getAllLeaveTypes(),
      getAllSupervisors(),
      getRemainingLeavesPerCategory(),
    ]);
    _dropStaleSelections();
    refreshController.refreshCompleted();
  }

  /// Clears a selection that no longer exists in the refreshed list.
  /// [getLeaveTypeId] and [getManagerId] use `firstWhere` without `orElse`, so
  /// a stale selection would throw on submit.
  void _dropStaleSelections() {
    if (selectedLeaveType.value.isNotEmpty &&
        !leaveTypes.contains(selectedLeaveType.value)) {
      selectedLeaveType.value = '';
      dateRangeController.clear();
      fromDateController.clear();
      toDateController.clear();
      isEligible.value = false;
      elegibilityText.value = '';
    }
    if (selectedManager.value.isNotEmpty &&
        !managers.contains(selectedManager.value)) {
      selectedManager.value = '';
    }
  }

  Future<void> checkEligibility() async {
    if (fromDateController.text.isEmpty ||
        toDateController.text.isEmpty ||
        selectedLeaveType.value.isEmpty) {
      return;
    }
    elegibilityText.value = 'Checking Eligibility...';
    try {
      isCheckEligibilityLoading(true);
      final body = CheckEligibilityParams(
        fromDate: fromDateController.text,
        toDate: toDateController.text,
        leaveType: getLeaveTypeId().toString(),
        userId: user!.id.toString(),
      );
      final Either<EligibilityEntity, Failure> result =
          await checkEligibilityUsecase.call(body);
      result.fold((EligibilityEntity eligible) {
        eligibility.value = eligible;
        if (eligible.balanceEligibility == true) {
          isEligible.value = true;
          elegibilityText.value = 'You are eligible for this leave';
        } else {
          isEligible.value = false;
          elegibilityText.value = 'You are not eligible for this leave';
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        isEligible.value = false;
        elegibilityText.value = 'You are not eligible for this leave';
      });
      isCheckEligibilityLoading.value = false;
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      isEligible.value = false;
      elegibilityText.value = 'You are not eligible for this leave';
      debugPrint(e.toString());
      isCheckEligibilityLoading.value = false;
    }
  }

  Future<void> submitLeaveRequest() async {
    final dio.FormData? data = await _getServiceFormData();
    if (data == null) {
      return;
    }
    debugPrint('data: ${data.toString()}');

    //clear the signature pad
    signatureController.clear();
    try {
      _isSubmitting(true);
      final Either<bool, Failure> result = await submitUsecase.call(data);
      _isSubmitting(false);
      result.fold((message) {
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: message
              ? 'Leave request submitted successfully'
              : 'failed to submit , try again later',
          isError: false,
        );

        Navigator.pop(Get.context!);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isSubmitting(false);
    }
  }

  int getLeaveTypeId() {
    final leaveType = leaveList.firstWhere(
      (element) => element.type == selectedLeaveType.value,
    );
    return leaveType.id!;
  }

  int getManagerId() {
    final manager = superList.firstWhere(
      (element) => element.name == selectedManager.value,
    );
    return manager.id!;
  }

  Future<dio.FormData?> _getServiceFormData() async {
    if (selectedManager.value.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Required',
        message: 'Select Manager please',
      );
      return null;
    }
    if (reasonTxtController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Required',
        message: 'Enter Reason',
      );
      return null;
    }

    //check the signature validation
    if (signatureController.isEmpty) {
      debugPrint('error you need to sign first ');
      CommonWidgets.showSnackBar(
        title: 'Required',
        message: 'You need to Sign First',
      );
      return null;
    }

    // from data map
    Map<String, dynamic> dataMap = {};

    dataMap['user_id'] = user!.id.toString();
    dataMap['leave_type_id'] = getLeaveTypeId().toString();
    dataMap['reporting_manager_id'] = getManagerId().toString();
    dataMap['from_date'] = fromDateController.text;
    dataMap['to_date'] = toDateController.text;
    dataMap['reason'] = reasonTxtController.text;

    selectedUsers
        .where((element) => element.id != 0)
        .toList()
        .asMap()
        .forEach((index, user) {
      dataMap['leave_application_users[$index]'] = user.id;
    });

    // adding signature file after service to form data

    final Uint8List? bytes = await signatureController.toPngBytes();
    if (bytes != null) {
      final multipartFile = dio.MultipartFile.fromBytes(bytes);
      dataMap['signutare'] = multipartFile;
    }

    return dio.FormData.fromMap(dataMap);
  }

  //todo improve this
  void scrollToTop() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint(">>>>> LeaveManagementController onClose <<<<<<");
    fromDateController.dispose();
    toDateController.dispose();
    signatureController.dispose();
    reasonTxtController.dispose();
    animationController.dispose();
    refreshController.dispose();
  }
}
