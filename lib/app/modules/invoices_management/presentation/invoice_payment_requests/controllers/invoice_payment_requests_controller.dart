import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/enums/invoice_payment_actions.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/enums/invoice_payment_statuses.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/params/get_invoices_params.dart';

import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/invoice_payment_request_entity.dart';
import '../../../domain/params/update_invoice_payment_status_params.dart';
import '../../../domain/usecases/invoice_payments_use_case.dart';
import '../../../domain/usecases/update_invoice_payment_status_use_case.dart';

class InvoicePaymentRequestsController extends GetxController {
  final authController = Get.find<AuthController>();

  final Rx<InvoicePaymentsRequestsTabs> currentTab =
      InvoicePaymentsRequestsTabs.pending.obs;

  // body refresh controllers
  RefreshController pendingRefreshController =
      RefreshController(initialRefresh: false);

  //
  RefreshController approvedRefreshController =
      RefreshController(initialRefresh: false);

  //
  RefreshController rejectedRefreshController =
      RefreshController(initialRefresh: false);

  // usecases
  final invoicePaymentsUseCase = sl<InvoicePaymentsUseCase>();
  final updateInvoicePaymentStatusUseCase =
      sl<UpdateInvoicePaymentStatusUseCase>();

  // loading state variables
  final _isLoadingPendingInvoicePayments = false.obs;
  bool get isLoadingPendingInvoicePayments =>
      _isLoadingPendingInvoicePayments.value;

  final _isLoadingApprovedInvoicePayments = false.obs;
  bool get isLoadingApprovedInvoicePayments =>
      _isLoadingApprovedInvoicePayments.value;

  final _isLoadingRejectedInvoicePayments = false.obs;
  bool get isLoadingRejectedInvoicePayments =>
      _isLoadingRejectedInvoicePayments.value;

  // updating state variables
  final _isUpdatingInvoiceStatus = false.obs;
  bool get isUpdatingInvoiceStatus => _isUpdatingInvoiceStatus.value;

  // updating at invoice
  final RxInt updatingAtIndex = (-1).obs;

  // list of invoices
  final RxList<InvoicePaymentEntity> pendingInvoicePayments =
      RxList<InvoicePaymentEntity>();

  final RxList<InvoicePaymentEntity> approvedInvoicePayments =
      RxList<InvoicePaymentEntity>();

  final RxList<InvoicePaymentEntity> rejectedInvoicePayments =
      RxList<InvoicePaymentEntity>();

  final RxInt pendingInvoiceExpandedIndex = (-1).obs;
  final RxInt approvedInvoiceExpandedIndex = (-1).obs;
  final RxInt rejectedInvoiceExpandedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    getPendingInvoicePayments();
    getApprovedInvoicePayments();
    getRejectedInvoicePayments();
  }

  handlePendingRefresh() async {
    await getPendingInvoicePayments();
    pendingRefreshController.refreshCompleted();
  }

  handleApprovedRefresh() async {
    await getApprovedInvoicePayments();
    approvedRefreshController.refreshCompleted();
  }

  handleRejectedRefresh() async {
    await getRejectedInvoicePayments();
    rejectedRefreshController.refreshCompleted();
  }

  Future<void> getPendingInvoicePayments() async {
    try {
      _isLoadingPendingInvoicePayments(true);
      final Either<BaseResponse<List<InvoicePaymentEntity>>, Failure> result =
          await invoicePaymentsUseCase.call(GetInvoicesParams(
        action: InvoicePaymentActions.edit,
        status: InvoicePaymentStatuses.pending,
      ));

      result.fold((BaseResponse<List<InvoicePaymentEntity>> invoiceData) {
        if (invoiceData.code == 200 &&
            (invoiceData.data?.isNotEmpty ?? false)) {
          pendingInvoicePayments.value = invoiceData.data!;
          _sortListItemsByDate(pendingInvoicePayments);
        } else {
          pendingInvoicePayments.clear();
        }
        _isLoadingPendingInvoicePayments(false);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        _isLoadingPendingInvoicePayments(false);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingPendingInvoicePayments(false);
    }
  }

  Future<void> getApprovedInvoicePayments() async {
    try {
      _isLoadingApprovedInvoicePayments(true);
      final Either<BaseResponse<List<InvoicePaymentEntity>>, Failure> result =
          await invoicePaymentsUseCase.call(GetInvoicesParams(
        action: InvoicePaymentActions.edit,
        status: InvoicePaymentStatuses.approved,
      ));

      result.fold((BaseResponse<List<InvoicePaymentEntity>> invoiceData) {
        if (invoiceData.code == 200 &&
            (invoiceData.data?.isNotEmpty ?? false)) {
          approvedInvoicePayments.value = invoiceData.data!;
          _sortListItemsByDate(approvedInvoicePayments);
        } else {
          approvedInvoicePayments.clear();
        }
        _isLoadingApprovedInvoicePayments(false);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        _isLoadingApprovedInvoicePayments(false);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingApprovedInvoicePayments(false);
    }
  }

  Future<void> getRejectedInvoicePayments() async {
    try {
      _isLoadingRejectedInvoicePayments(true);
      final Either<BaseResponse<List<InvoicePaymentEntity>>, Failure> result =
          await invoicePaymentsUseCase.call(GetInvoicesParams(
        action: InvoicePaymentActions.edit,
        status: InvoicePaymentStatuses.rejected,
      ));

      result.fold((BaseResponse<List<InvoicePaymentEntity>> invoiceData) {
        if (invoiceData.code == 200 &&
            (invoiceData.data?.isNotEmpty ?? false)) {
          rejectedInvoicePayments.value = invoiceData.data!;
          _sortListItemsByDate(rejectedInvoicePayments);
        } else {
          rejectedInvoicePayments.clear();
        }
        _isLoadingRejectedInvoicePayments(false);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        _isLoadingRejectedInvoicePayments(false);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingRejectedInvoicePayments(false);
    }
  }

  Future<void> updateInvoicePaymentStatus(int invoiceId, String status) async {
    if (isUpdatingInvoiceStatus) {
      return;
    }
    try {
      _isUpdatingInvoiceStatus(true);
      final Either<BaseResponse, Failure> result =
          await updateInvoicePaymentStatusUseCase.call(
        UpdateInvoicePaymentStatusParams(
            invoiceId: invoiceId,
            status: status,
            updatedBy: authController.user.value!.id!),
      );

      _isUpdatingInvoiceStatus(false);

      result.fold((BaseResponse invoiceStatusResponse) {
        if (invoiceStatusResponse.code == 200) {
          CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message: invoiceStatusResponse.message ??
                  "Status updated successfully.",
              isError: false);
          pendingInvoicePayments
              .removeWhere((element) => element.id == invoiceId);
          pendingInvoicePayments.refresh();
          if (status == InvoicePaymentStatuses.approved) {
            handleApprovedRefresh();
          } else {
            handleRejectedRefresh();
          }
        } else {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: invoiceStatusResponse.message ?? "Something went wrong.",
          );
        }
        updatingAtIndex(-1);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        _isUpdatingInvoiceStatus(true);
        updatingAtIndex(-1);
      });
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isUpdatingInvoiceStatus(false);
      updatingAtIndex(-1);
    }
  }

//
// sort list on the bases of the createdAt, latest must on top
  _sortListItemsByDate(List<InvoicePaymentEntity> dataList) {
    dataList.sort((a, b) {
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
  }
}

enum InvoicePaymentsRequestsTabs { pending, approved, rejected }
