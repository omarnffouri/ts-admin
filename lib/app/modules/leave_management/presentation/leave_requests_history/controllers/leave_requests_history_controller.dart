import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/leave_history_entity.dart';
import '../../../domain/usecases/get_requested_history_usecase.dart';

class LeaveRequestsHistoryController extends GetxController {
  final getRequestedHistoryUsecase = sl<GetRequestedHistoryUsecase>();

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  final RxList<LeaveHistoryEntity> requestedList = <LeaveHistoryEntity>[].obs;
  final isLoading = false.obs;

  final selectedStatus = 'All'.obs;
  List<String> statusOptions = ['All', 'Approved', 'Rejected'];

  final selectedAdmin = 'All'.obs;
  RxList<String> adminOptions = <String>[].obs;

  final Rxn<int?> expandedRequestId = Rxn<int?>(null);

  @override
  void onInit() {
    super.onInit();
    getAllRequests();
  }

  Future<void> handleRefresh() async {
    await getAllRequests();
    refreshController.refreshCompleted();
  }

  Future<void> getAllRequests() async {
    requestedList.clear();
    adminOptions.clear();
    requestedList.clear();
    try {
      isLoading.value = true;
      final Either<List<LeaveHistoryEntity>, Failure> response =
          await getRequestedHistoryUsecase.call(const NoParams());
      isLoading.value = false;
      response.fold(
        (List<LeaveHistoryEntity> data) {
          debugPrint(
              '>> getUsersRequestedLeavesUsecase length: ${data.length}');
          requestedList.addAll(data);
        },
        (r) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: r.message,
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Something went wrong ${e.toString()}',
      );
    }

    // create list of admin options by extracting actionByName from requestedList
    // and remove duplicates
    adminOptions.addAll(
      requestedList.map((e) => e.updatedBy!).toSet().toList(),
    );
    adminOptions.insert(0, 'All');
    // expansionTileControllers = List.generate(
    //   requestedList.length,
    //   (_) => ExpansionTileController(),
    // );
    isLoading.value = false;
  }

  RxList<LeaveHistoryEntity> get filterList {
    // expansionTileControllers?.clear();
    if (selectedStatus.value == 'All' && selectedAdmin.value == 'All') {
      return requestedList;
    } else if (selectedStatus.value == 'All' && selectedAdmin.value != 'All') {
      return requestedList
          .where((request) =>
              request.updatedBy?.toLowerCase() ==
              selectedAdmin.value.toLowerCase())
          .toList()
          .obs;
    } else if (selectedStatus.value != 'All' && selectedAdmin.value == 'All') {
      return requestedList
          .where((request) =>
              request.status?.toLowerCase() == selectedStatus.toLowerCase())
          .toList()
          .obs;
    } else {
      return requestedList
          .where((request) =>
              request.status?.toLowerCase() == selectedStatus.toLowerCase() &&
              request.updatedBy?.toLowerCase() ==
                  selectedAdmin.value.toLowerCase())
          .toList()
          .obs;
    }
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  getColor(String string) {
    if (string == 'approved') {
      return Colors.green;
    } else if (string == 'rejected') {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}
