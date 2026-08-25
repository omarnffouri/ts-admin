import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/widgets/dialogs/confirmation_dialog.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/update_user_status_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/rule_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_all_rules_usecase.dart';
import '../../../domain/usecases/get_all_users_usecase.dart';

class AllUserController extends GetxController {
  final authController = Get.find<AuthController>();

  // usecases
  final getAllUsersUsecase = sl<GetAllUsersUsecase>();
  final getAllRulesUsecase = sl<GetAllRulesUsecase>();
  final updateUserStatusUsecase = sl<UpdateUserStatusUsecase>();

  // body refresh controllers
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // pagination variables
  late final ScrollController scrollController;
  final RxInt page = 1.obs;
  final RxInt limit = 20.obs;
  final RxBool hasMore = true.obs;

  // variables
  RxList<UserEntity> users = <UserEntity>[].obs;
  RxList<RuleEntity> roles = <RuleEntity>[].obs;
  final errorWhileLoadingUsers = false.obs;
  final isLoading = false.obs;
  final RxBool isHasMoreLoading = false.obs;
  final RxBool isSearching = false.obs;
  final isUpdatingUserStatus = false.obs;
  final RxInt updatingStatusAtIndex = (-1).obs;

  final selectedRole = 'driver'.obs;
  RxList<String> roleOptions = <String>[].obs;

  // rules states
  final RxBool isLoadingRoles = false.obs;
  final RxBool errorWhileLoadingRoles = false.obs;

  final txtSearchController = TextEditingController();
  final txtSearch = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    scrollController = ScrollController()..addListener(_scrollListener);
    getAllRoles();
    getAllUsers();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        hasMore.value) {
      page.value++;
      loadMoreUsers();
    }
  }

  Future<void> getAllRoles() async {
    roles.clear();
    roleOptions.clear();
    isLoadingRoles(true);
    errorWhileLoadingRoles(false);
    try {
      final response = await getAllRulesUsecase.call(const NoParams());
      response.fold(
        (List<RuleEntity> data) {
          roles.value = data;
          roleOptions.addAll(data.map((e) => e.name!));
          roleOptions.insert(0, 'All');
          debugPrint("getAllRules length ${data.length}");
        },
        (r) {
          debugPrint(r.message);
          errorWhileLoadingRoles(true);
        },
      );
      isLoadingRoles(false);
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      isLoadingRoles(false);
      errorWhileLoadingRoles(true);
    }
  }

  Future<void> getAllUsers() async {
    isLoading.value = true;
    await _fetchUsers(resetPage: true);
    isLoading.value = false;
  }

  Future<void> loadMoreUsers() async {
    isHasMoreLoading.value = true;
    await _fetchUsers();
    isHasMoreLoading.value = false;
  }

  Future<void> searchUsers() async {
    isSearching.value = true;
    await _fetchUsers(resetPage: true);
    isSearching.value = false;
  }

  Future<void> _fetchUsers({bool resetPage = false}) async {
    if (resetPage) page.value = 1;

    errorWhileLoadingUsers.value = false;
    try {
      final body = {
        'page': page.value,
        'limit': limit.value,
        'role': selectedRole.value == 'All' ? null : selectedRole.value,
        'search': txtSearchController.text.isEmpty
            ? null
            : txtSearchController.text.trim(),
      };

      debugPrint('Body: $body');

      final response = await getAllUsersUsecase.call(body);
      response.fold((BaseResponse<List<UserEntity>> response) {
        hasMore.value = response.hasMore ?? false;
        if (resetPage) {
          users.clear();
        }
        users.addAll(response.data!);

        debugPrint('users length: ${users.length}');
      }, (failure) {
        errorWhileLoadingUsers.value = true;
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      errorWhileLoadingUsers.value = true;
      debugPrint('Error $e');
    }
  }

  Future<void> handleShipmentRefresh() async {
    getAllUsers();
    refreshController.refreshCompleted();
  }

  Future<void> handleStatusChange(String? value) async {
    selectedRole.value = value.toString();
    getAllUsers();
  }

  Future<void> handleSearchChange(String value) async {
    txtSearch.value = value;
    isSearching.value = true;
    users.clear();
    EasyDebounce.debounce('search', const Duration(milliseconds: 500), () {
      txtSearchController.text = value;
      searchUsers();
    });
  }

  Future<void> suspendUser(UserEntity user, int index) async {
    bool confirmed = false;

    //
    //
    // confirmation dialog before suspention
    await Get.defaultDialog(
      title: 'Suspend ${user.firstName ?? "User"}',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.mainColor,
      ),
      onWillPop: () async {
        return false;
      },
      titlePadding: EdgeInsets.only(top: 10.h),
      content: ConfirmationDialog(
        message: 'Are you sure?',
        onConfirmation: () async {
          confirmed = true;
          Get.back();
        },
        onCancel: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );

    //
    //
    // if confirmed by user then suspend this user
    if (confirmed) {
      isUpdatingUserStatus.value = true;
      updatingStatusAtIndex.value = index;

      //
      //
      // api call for suspending user
      await _updateUserStatus(user, "suspended");

      //
      //
      // resting states
      isUpdatingUserStatus.value = false;
      updatingStatusAtIndex.value = (-1);
    }
  }

  Future<void> activateUser(UserEntity user, int index) async {
    bool confirmed = false;

    //
    //
    // confirmation dialog before suspention
    await Get.defaultDialog(
      title: 'Active ${user.firstName ?? "User"}',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.mainColor,
      ),
      onWillPop: () async {
        return false;
      },
      titlePadding: EdgeInsets.only(top: 10.h),
      content: ConfirmationDialog(
        message: 'Are you sure?',
        onConfirmation: () async {
          confirmed = true;
          Get.back();
        },
        onCancel: () {
          Get.back();
        },
      ),
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
    );

    //
    //
    // if confirmed by user then active this user
    if (confirmed) {
      isUpdatingUserStatus.value = true;
      updatingStatusAtIndex.value = index;

      //
      //
      // api call for suspending user
      await _updateUserStatus(user, "active");

      //
      //
      // resting states
      isUpdatingUserStatus.value = false;
      updatingStatusAtIndex.value = (-1);
    }
  }

  Future<void> _updateUserStatus(
    UserEntity user,
    String action,
  ) async {
    //
    //
    // api call for suspending user
    try {
      final body = {
        'user_id': user.id,
        'action': action,
      };

      final response = await updateUserStatusUsecase.call(body);

      response.fold((bool successful) {
        if (successful) {
          user.status = action;
          users.refresh();
        }
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
      Get.snackbar('Error', "Something went wrong while updating user status.");
    }
  }
}
