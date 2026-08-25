import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/incoming_user_leave_request_entity.dart';
import '../../../domain/usecases/admin_action_usecase.dart';
import '../../../domain/usecases/get_users_requested_leaves_usecase.dart';

class ManageLeaveRequestsController extends GetxController {
  final getUsersRequestedLeavesUsecase = sl<GetUsersRequestedLeavesUsecase>();
  final adminActionUsecase = sl<AdminActionUsecase>();

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  final RxList<UserLeaveRequestEntity> requestedList =
      <UserLeaveRequestEntity>[].obs;

  // add text editing controller
  final commentsController = TextEditingController();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  @override
  void onInit() {
    super.onInit();
    getAllRequests();
  }

  Future<void> getAllRequests() async {
    requestedList.clear();
    try {
      isLoading.value = true;
      final Either<List<UserLeaveRequestEntity>, Failure> response =
          await getUsersRequestedLeavesUsecase.call(const NoParams());
      isLoading.value = false;
      response.fold(
        (List<UserLeaveRequestEntity> data) {
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
  }

  Future<void> submit({
    required int id,
    required String status,
    String comments = "",
  }) async {
    try {
      isSubmitting.value = true;
      final body = {
        'application_id': id.toString(),
        'action': status,
        'admin_comments': comments,
      };
      final Either<bool, Failure> response =
          await adminActionUsecase.call(body);
      isSubmitting.value = false;
      response.fold(
        (bool isSuccessful) {
          debugPrint('>> adminActionUsecase isSuccessful: $isSuccessful');
          if (isSuccessful) {
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: 'Leave request $status successfully',
              isError: false,
            );
            // remove from list
            requestedList.removeWhere((element) => element.id == id);
            requestedList.refresh();
          }
        },
        (r) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: r.message,
          );
        },
      );
    } on Exception catch (e) {
      isSubmitting.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Something went wrong ${e.toString()}',
      );
    }
  }

  Future<void> handleRefresh() async {
    await getAllRequests();
    refreshController.refreshCompleted();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
