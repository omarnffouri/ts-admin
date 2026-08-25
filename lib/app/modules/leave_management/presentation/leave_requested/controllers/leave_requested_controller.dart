import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/requested_leave_entity.dart';
import '../../../domain/usecases/get_all_requested_leaves_usecase.dart';

class LeaveRequestedController extends GetxController {
  final _user = Get.find<AuthController>().user;
  UserEntity? get user => _user.value;

  final getRequestedLeavesUsecase = sl<GetRequestedLeavesUsecase>();
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  final RxList<RequestEntity> requestedList = <RequestEntity>[].obs;

  final isLoading = false.obs;

  final selectedStatus = ''.obs;
  List<String> statusOptions = ['All', 'Approved', 'Pending', 'Rejected'];

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
    try {
      isLoading.value = true;
      final body = {'user_id': user?.id};
      final Either<List<RequestEntity>, Failure> response =
          await getRequestedLeavesUsecase.call(body);
      isLoading.value = false;
      response.fold(
        (List<RequestEntity> data) {
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

    selectedStatus.value = statusOptions[0];
    isLoading.value = false;
  }

  RxList<RequestEntity> get filterList {
    if (selectedStatus.value == 'All') {
      return requestedList;
    } else {
      return requestedList
          .where((request) =>
              request.status?.toLowerCase() == selectedStatus.toLowerCase())
          .toList()
          .obs;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.amber;
    }
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
