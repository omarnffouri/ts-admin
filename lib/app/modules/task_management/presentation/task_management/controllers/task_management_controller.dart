import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_listing_data_entity.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/get_tasks_listing_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/refresh_tasks_listing_usecase.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class TaskManagementController extends GetxController
    implements TickerProvider {
  final Rx<TasksTabs> currentTab = TasksTabs.todo.obs;

  late TabController tabController;

  final AuthController authController = Get.find<AuthController>();

  //
  // usecase
  final getTasksListingUsecase = sl<GetTasksListingUsecase>();
  final refreshTasksListingUsecase = sl<RefreshTasksListingUsecase>();

  // body refresh controllers
  RefreshController todoRefreshController = RefreshController();
  RefreshController completedRefreshController = RefreshController();
  RefreshController requestedRefreshController = RefreshController();

  //
  // data variables

  // todo
  final RxList<TaskEntity> upcommingDedlines = RxList();
  final RxList<TaskEntity> todos = RxList();

  // completed
  final RxList<TaskEntity> recentlyAchived = RxList();
  final RxList<TaskEntity> completed = RxList();

  // requested
  final RxList<TaskEntity> latelyAsked = RxList();
  final RxList<TaskEntity> requested = RxList();

  // search text controller
  TextEditingController searchTextController = TextEditingController();

  //
  // states
  final RxBool _isLoadingTasksListing = false.obs;
  bool get isLoadingTasksListing => _isLoadingTasksListing.value;

  final RxBool _isRefreshingTodoTasks = false.obs;
  bool get isRefreshingTodoTasks => _isRefreshingTodoTasks.value;

  final RxBool _isRefreshingTasksComplete = false.obs;
  bool get isRefreshingCompletedTasks => _isRefreshingTasksComplete.value;

  final RxBool _isRefeshingRequestedTasks = false.obs;
  bool get isRefeshingRequestedTasks => _isRefeshingRequestedTasks.value;

  final RxBool _errorWhileLoadingTasksListing = false.obs;
  bool get errorWhileLoadingTasksListing =>
      _errorWhileLoadingTasksListing.value;

  //
  //
  //

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      searchTextController.clear();
      if (tabController.index == 0) {
        currentTab(TasksTabs.todo);
      } else if (tabController.index == 1) {
        currentTab(TasksTabs.requested);
      } else {
        currentTab(TasksTabs.completed);
      }
    });

    getTasksListing();
  }

  ///
  ///
  /// This function will call api for tasks listing and pass data to filter functions
  refreshTasksListing(String status) async {
    if (status == "pending") {
      _isRefreshingTodoTasks(true);
    } else if (status == "completed") {
      _isRefreshingTasksComplete(true);
    } else if (status == "requested") {
      _isRefeshingRequestedTasks(true);
    }

    try {
      final response = await refreshTasksListingUsecase.call(status);

      response.fold((BaseResponse<List<TaskEntity>> data) {
        if (data.data != null) {
          debugPrint("Tasks refreshing data $status: ${data.data?.length}");
          if (status == "pending") {
            _filterTodoTasksData(data.data!);
          } else if (status == "completed") {
            _filterCompletedTasksData(data.data!);
          } else if (status == "requested") {
            _filterRequestedTasksData(data.data!);
          }
        }
      }, (Failure _) {});
    } catch (e) {
      debugPrint(e.toString());
    }

    if (status == "pending") {
      _isRefreshingTodoTasks(false);
    } else if (status == "completed") {
      _isRefreshingTasksComplete(false);
    } else if (status == "requested") {
      _isRefeshingRequestedTasks(false);
    }
  }

  ///
  ///
  /// This function will call api for tasks listing and pass data to filter functions
  Future<void> getTasksListing() async {
    if (isLoadingTasksListing) {
      return;
    }

    _errorWhileLoadingTasksListing.value = false;
    _isLoadingTasksListing.value = true;

    try {
      final response = await getTasksListingUsecase.call(const NoParams());

      response.fold((BaseResponse<TaskListingDataEntity> data) {
        if (data.data != null) {
          // debugPrint("Tasks listing data: ${data.data}");
          _filterTasksData(data.data!);
        } else {
          _errorWhileLoadingTasksListing.value = true;
        }
      }, (Failure failure) {
        _errorWhileLoadingTasksListing.value = true;
      });
      _isLoadingTasksListing.value = false;
    } catch (e) {
      debugPrint(e.toString());
      _errorWhileLoadingTasksListing.value = true;
      _isLoadingTasksListing.value = false;
    }
  }

  ///
  ///
  /// Filters the todos, completed and requested lists data
  _filterTasksData(TaskListingDataEntity data) {
    _filterTodoTasksData(data.todo ?? []);
    _filterCompletedTasksData(data.completed ?? []);
    _filterRequestedTasksData(data.requested ?? []);
  }

  ///
  ///
  /// Filters the todo list and upcomming deadlines
  _filterTodoTasksData(List<TaskEntity> tasks) {
    upcommingDedlines.clear();
    todos.clear();

    DateTime now = DateTime.now();
    DateTime threeDaysLater = now.add(const Duration(days: 3));

    // Filter the tasks that are going to expire within next 3 days
    final upcommings = tasks.where((item) {
      return (item.dueDate?.isAfter(now) ?? false) &&
          (item.dueDate?.isBefore(threeDaysLater) ?? false);
    }).toList();

    // tasks after filtering upcomming expire
    final remainings = tasks.where((item) {
      return (item.dueDate?.isBefore(now) ?? false) ||
          (item.dueDate?.isAfter(threeDaysLater) ?? false);
    }).toList();

    //
    // sort both list on the base of created at date
    _sortList(upcommings);
    _sortList(remainings);

    //
    // if upcomming tasks list empty and remaining list have tasks then
    // copy first 5 items from remaining to upcommming
    if (upcommings.isEmpty && remainings.isNotEmpty) {
      _copyItems(remainings, upcommings, 5);
    }

    //
    // if remainging tasks list empty and upcomming list have tasks then
    // copy all items from upcommming to remaining
    if (remainings.isEmpty && upcommings.isNotEmpty) {
      _copyItems(upcommings, remainings, 20);
    }

    //
    // add data to lists
    upcommingDedlines.addAll(upcommings);
    todos.addAll(remainings);
  }

  ///
  ///
  /// Filters the completd list and recently achived
  _filterCompletedTasksData(List<TaskEntity> tasks) {
    recentlyAchived.clear();
    completed.clear();

    DateTime now = DateTime.now();
    DateTime threeDaysErlier = now.subtract(const Duration(days: 3));

    // Filter the tasks that are completed in last 3 days
    final recently = tasks.where((item) {
      return (item.updatedAt?.isAfter(threeDaysErlier) ?? false) &&
          (item.updatedAt?.isBefore(now) ?? false);
    }).toList();

    // tasks after filtering recently completed
    final remainings = tasks.where((item) {
      return (item.updatedAt?.isBefore(threeDaysErlier) ?? false) ||
          (item.updatedAt?.isAfter(now) ?? false);
    }).toList();

    //
    // sort both list on the base of created at date
    _sortList(recently);
    _sortList(remainings);

    //
    // if recently tasks list empty and remaining list have tasks then
    // copy first 5 items from remaining to recently
    if (recently.isEmpty && remainings.isNotEmpty) {
      _copyItems(remainings, recently, 5);
    }

    //
    // if remainging tasks list empty and recently list have tasks then
    // copy all items from recently to remaining
    if (remainings.isEmpty && recently.isNotEmpty) {
      _copyItems(recently, remainings, 20);
    }

    //
    // add data to lists
    recentlyAchived.addAll(recently);
    completed.addAll(remainings);
  }

  ///
  ///
  /// Filters the requested list and lately asked
  _filterRequestedTasksData(List<TaskEntity> tasks) {
    latelyAsked.clear();
    requested.clear();

    DateTime now = DateTime.now();
    DateTime threeDaysErlier = now.subtract(const Duration(days: 3));

    // Filter the tasks that are requesyed in last 3 days
    final recently = tasks.where((item) {
      return (item.createdAt?.isAfter(threeDaysErlier) ?? false) &&
          (item.createdAt?.isBefore(now) ?? false);
    }).toList();

    // tasks after filtering recently completed
    final remainings = tasks.where((item) {
      return (item.createdAt?.isBefore(threeDaysErlier) ?? false) ||
          (item.createdAt?.isAfter(now) ?? false);
    }).toList();

    //
    // sort both list on the base of created at date
    _sortList(recently);
    _sortList(remainings);

    //
    // if recently tasks list empty and remaining list have tasks then
    // copy first 5 items from remaining to recently
    if (recently.isEmpty && remainings.isNotEmpty) {
      _copyItems(remainings, recently, 5);
    }

    //
    // if remainging tasks list empty and recently list have tasks then
    // copy all items from recently to remaining
    if (remainings.isEmpty && recently.isNotEmpty) {
      _copyItems(recently, remainings, 20);
    }

    //
    // add data to lists
    latelyAsked.addAll(recently);
    requested.addAll(remainings);
  }

  ///
  ///
  /// This will sort the list on the base of createAt
  _sortList(List<TaskEntity> list) {
    list.sort((a, b) {
      if (a.createdAt == null) return 1; // Nulls go last
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
  }

  ///
  ///
  /// This will copy the n number of items form the 'from' list to 'to' list
  _copyItems(List<TaskEntity> from, List<TaskEntity> to, int n) {
    // validate that n must be > 0
    if (n <= 0) {
      return;
    }

    //
    if (n < from.length) {
      try {
        to.addAll(from.sublist(0, n));
      } catch (_) {}
    } else {
      to.addAll(from);
    }
  }

  void viewAllTasks() {
    Get.toNamed(
      Routes.VIEW_ALL_TASK,
      arguments: currentTab.value,
    );
  }

  void viewTaskDetails(TaskEntity task) {
    Get.toNamed(
      Routes.TASK_DETAIL_VIEW,
      arguments: task,
    );
  }

  ///
  ///
  /// This will refresh the tasks lists
  void onTaskUpdated(TaskEntity task, {bool percentageUpdated = false}) {
    if (percentageUpdated) {
      if (task.id == null) {
        return;
      }
      upcommingDedlines
          .firstWhereOrNull((item) => item.id == task.id)
          ?.update(task);
      upcommingDedlines.refresh();
      todos.firstWhereOrNull((item) => item.id == task.id)?.update(task);
      todos.refresh();
      return;
    }
    getTasksListing();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

enum TasksTabs { todo, inProgress, completed, requested }
