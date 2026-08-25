import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/controllers/task_management_controller.dart';
import 'package:ts_admin/app/modules/task_management/presentation/view_all_task/views/components/tasks_filters_bottom_sheet.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/task_dropdown_entity.dart';
import '../../../domain/usecases/get_all_tasks_usecase.dart';
import '../../../domain/usecases/get_task_dropdown_usecase.dart';

class ViewAllTaskController extends GetxController {
  final authController = Get.find<AuthController>();

  final Rx<TasksTabs> tab = TasksTabs.todo.obs;

  // body refresh controllers
  final RefreshController refreshController = RefreshController();

  //use case
  final getTaskDropdownUsecase = sl<GetTaskDropdownUsecase>();
  final getAllTasksUsecase = sl<GetAllTasksUsecase>();

  // and loading state variables
  final RxList<TaskEntity> tasks = <TaskEntity>[].obs;
  final users = <TaskDropdownsEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isHasMoreLoading = false.obs;
  final RxBool errorWhileLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool _isSearchEnabled = false.obs;
  bool get isSearchEnabled => _isSearchEnabled.value;
  // final RxBool isSearchEnabled = true.obs;

// pagination variables
  late final ScrollController scrollController;
  final RxInt page = 1.obs;
  final RxInt limit = 15.obs;
  final RxBool hasMore = true.obs;

// filter variables and search
  final RxString selectedRole = ''.obs;

  final TextEditingController txtSearchController = TextEditingController();
  final txtSearch = "".obs;

  final Rxn<TaskDropdownsEntity> selectedReportTo = Rxn();
  final Rxn<TaskDropdownsEntity> selectedRequestedTo = Rxn();

  @override
  void onInit() {
    super.onInit();

    try {
      final args = Get.arguments;
      if (args != null) {
        tab(args as TasksTabs);

        //set selected role
        switch (tab.value) {
          case TasksTabs.todo:
            selectedRole('pending');
            break;
          case TasksTabs.requested:
            selectedRole('requested');
            break;
          case TasksTabs.completed:
            selectedRole('completed');
            break;
          default:
            selectedRole('pending');
        }

        // set users
      }
    } catch (_) {}

    scrollController = ScrollController()..addListener(_scrollListener);

    // Initial data load
    getTaskDropdowns();
    getAllTasks();
  }

  Future<void> getTaskDropdowns() async {
    try {
      final response = await getTaskDropdownUsecase(const NoParams());
      response.fold(
        (BaseResponse<List<TaskDropdownsEntity>> dropdowns) {
          users.value = dropdowns.data!;
          debugPrint("Task Dropdowns: ${users.length}");
        },
        (Failure r) {
          debugPrint("Error: ${r.message}");
        },
      );
    } catch (_) {}
  }

  //!---

  void _scrollListener() {
    debugPrint('Scrolling');
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        hasMore.value) {
      page.value++;
      loadMoreTasks();
    }
  }

  Future<void> getAllTasks() async {
    tasks.clear();
    // filterList.clear();
    isLoading.value = true;
    await _fetchTasks(resetPage: true);
    isLoading.value = false;
  }

  Future<void> loadMoreTasks() async {
    isHasMoreLoading.value = true;
    await _fetchTasks();
    isHasMoreLoading.value = false;
  }

  Future<void> searchShipments() async {
    await _fetchTasks(resetPage: true);
    isSearching.value = false;
  }

  Future<void> _fetchTasks({bool resetPage = false}) async {
    if (resetPage) page.value = 1;

    errorWhileLoading.value = false;

    try {
      final body = {
        'currentPage': page.value,
        'pageSize': limit.value,
        'status':
            selectedRole.value == 'todo' ? ["pending"] : [selectedRole.value],
        'search': txtSearchController.text.isEmpty
            ? null
            : txtSearchController.text.trim(),
        'assigned_to': selectedRequestedTo.value?.id,
        'reports_to': selectedReportTo.value?.id,
      };

      debugPrint('Body: $body');

      final response = await getAllTasksUsecase.call(body);
      response.fold((BaseResponse<List<TaskEntity>> response) {
        debugPrint('Response length: ${response.data?.length}');
        debugPrint('Response has more: ${response.hasMore}');
        hasMore.value = response.hasMore ?? false;
        if (resetPage) {
          tasks.clear();
        }
        tasks.addAll(response.data!);
      }, (failure) {
        errorWhileLoading.value = true;
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      errorWhileLoading.value = true;
      debugPrint('Error $e');
    }
  }

  Future<void> handleShipmentRefresh() async {
    txtSearchController.clear();
    selectedRole.value = 'All';
    await getAllTasks();
    refreshController.refreshCompleted();
  }

  Future<void> handleSearchChange(String value) async {
    txtSearch.value = value;
    isSearching.value = true;
    tasks.clear();
    page.value = 1;
    EasyDebounce.debounce('search', const Duration(milliseconds: 500), () {
      txtSearchController.text = value;
      searchShipments();
    });
  }

  void viewTaskDetails(TaskEntity task) async {
    await Get.toNamed(Routes.TASK_DETAIL_VIEW, arguments: task);
    tasks.refresh();
  }

  void toggleSearch() {
    _isSearchEnabled.toggle();
  }

  void showFiltersBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColorsDark.scaffoldBackroundColor
              : AppColorsLight.scaffoldBackroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: const TasksFiltersBottomSheet(),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  //todo make extension
  bool assignedToMe(TaskEntity task) {
    return task.assignedTo?.id == authController.user.value?.id &&
        (authController.user.value?.id != null);
  }

  bool assignedByMe(TaskEntity task) {
    return task.reportsTo?.id == authController.user.value?.id &&
        (authController.user.value?.id != null);
  }

  //todo review this method
  TaskUserEntity? getReporterOrAssigne(TaskEntity task) {
    if (assignedToMe(task)) {
      return task.reportsTo;
    }
    if (assignedByMe(task)) {
      return task.assignedTo;
    }
    return task.assignedTo;
  }
}
