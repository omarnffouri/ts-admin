import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/enum/additional_pay_status.dart';
import 'package:ts_admin/app/core/utils/additional_pay_extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/enitities/additional_pay_entity.dart';
import '../../../domain/enitities/shipment_entity.dart';
import '../../../domain/usecases/get_additional_pays_usecase.dart';
import '../../../domain/usecases/resolve_additional_pay_usecase.dart';
import '../views/components/additional_pay_action_sheet.dart';

class AdditionalPayController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final getAdditionalPaysUsecase = sl<GetAdditionalPaysUsecase>();
  final resolveAdditionalPayUsecase = sl<ResolveAdditionalPayUsecase>();
  final authController = Get.find<AuthController>();

  /// Request whose decision is in flight. Scoped by id, not a bare bool, so a
  /// response never drives the spinner or closes the sheet of another request.
  final RxnInt submittingId = RxnInt();

  bool get isSubmitting => submittingId.value != null;

  int? _openSheetRequestId;

  /// Raw pages for the selected tab, as fetched (?status= filters server-side).
  final RxList<AdditionalPayEntity> requests = <AdditionalPayEntity>[].obs;

  /// What the list renders — [requests] minus resolved items and search.
  final RxList<AdditionalPayEntity> visible = <AdditionalPayEntity>[].obs;

  /// Per-status totals from the API, adjusted locally when a request resolves.
  final RxMap<AdditionalPayStatus, int> statusCounts =
      <AdditionalPayStatus, int>{}.obs;

  int get selectedCount => statusCounts[selectedStatus.value] ?? 0;

  final Rx<AdditionalPayStatus> selectedStatus =
      AdditionalPayStatus.pending.obs;
  final RxBool isLoading = true.obs;

  // pagination
  static const int _pageSize = 12;
  late final ScrollController scrollController;
  int _page = 1;
  bool _hasMore = true;

  /// True while a next page is appending — drives the list's footer spinner.
  final RxBool isLoadingMore = false.obs;

  final RxBool isSearchEnabled = false.obs;
  final RxString txtSearch = ''.obs;
  final TextEditingController txtSearchController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  late final AnimationController searchExpandedController;
  late final Worker _searchDebounce;

  final RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_scrollListener);
    searchExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchDebounce = debounce(
      txtSearch,
      (_) => _recompute(),
      time: const Duration(milliseconds: 250),
    );
    if (authController.userPermissionHelper.canResolveAdditionalPays()) {
      loadRequests();
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _searchDebounce.dispose();
    scrollController.dispose();
    txtSearchController.dispose();
    noteController.dispose();
    searchExpandedController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (isLoadingMore.value ||
        isLoading.value ||
        !_hasMore ||
        txtSearch.value.trim().isNotEmpty) {
      return;
    }
    // Prefetch the next page shortly before the end of the list.
    if (scrollController.position.extentAfter > 400) return;
    _loadMore();
  }

  Future<void> _loadMore() async {
    isLoadingMore.value = true;
    _page++;
    try {
      await _fetchRequests();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadRequests() async {
    requests.clear();
    _recompute();
    isLoading.value = true;
    _page = 1;
    _hasMore = true;
    try {
      await _fetchRequests();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchRequests() async {
    final response = await getAdditionalPaysUsecase.call({
      'page': _page,
      'per_page': _pageSize,
      'status': selectedStatus.value.name,
    });
    response.fold((data) {
      requests.addAll(data.data?.approvals ?? []);
      // `status_counts` is global, not scoped to ?status= — one fetch fills
      // every tab. Later pages repeat the same numbers, so only page 1 applies.
      if (_page == 1) {
        // Left absent when the envelope omits them — the tab renders a blank
        // badge, which beats showing one page's length as a total.
        final counts = data.data?.statusCounts;
        if (counts != null) statusCounts.assignAll(counts.byStatus);
      }
      _hasMore = data.hasMore ?? false;
      _recompute();
    }, (failure) {
      _hasMore = false;
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: failure.message,
        isError: true,
      );
    });
  }

  /// Rebuilds [visible] from the selected tab and search query.
  void _recompute() {
    final String query = txtSearch.value.trim().toLowerCase();
    final List<AdditionalPayEntity> matched = [];
    for (final r in requests) {
      if (r.status.value != selectedStatus.value) continue;
      if (query.isEmpty ||
          (r.driverName ?? '').toLowerCase().contains(query) ||
          (r.truckNumber ?? '').toLowerCase().contains(query) ||
          (r.shipmentRef ?? '').toLowerCase().contains(query)) {
        matched.add(r);
      }
    }
    visible.assignAll(matched);
  }

  /// Keeps the tab totals honest after a local approve/reject.
  void _shiftCount(AdditionalPayStatus from, AdditionalPayStatus to) {
    if (statusCounts.isEmpty || from == to) return;
    statusCounts.update(from, (v) => v > 0 ? v - 1 : 0, ifAbsent: () => 0);
    statusCounts.update(to, (v) => v + 1, ifAbsent: () => 1);
  }

  Future<void> handleRefresh() async {
    await loadRequests();
    refreshController.refreshCompleted();
  }

  void selectStatus(AdditionalPayStatus status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    // Status filtering is server-side (?status=), so switching tabs refetches.
    loadRequests();
  }

  void handleSearchChange(String value) {
    txtSearch.value = value; // debounced into _recompute
  }

  void clearSearch() {
    txtSearchController.clear();
    txtSearch.value = '';
    _recompute();
  }

  /// Opens the shipment behind a pay request. Only the id and ref travel with
  /// the pay record; the details screen fetches the rest by id.
  void openShipment(AdditionalPayEntity request) {
    final int? shipmentId = request.shipment?.id;
    if (shipmentId == null) {
      CommonWidgets.showSnackBar(
        title: 'Unavailable',
        message: 'This request has no shipment linked to it.',
        isError: true,
      );
      return;
    }
    Get.toNamed(
      Routes.SHIPMENT_DETAILS,
      arguments: ShipmentEntity(
        id: shipmentId,
        shipmentNumber: request.shipmentRef,
      ),
    );
  }

  void showActionSheet(AdditionalPayEntity request, {required bool isApprove}) {
    // A second sheet would share noteController with the in-flight request.
    if (isSubmitting) {
      CommonWidgets.showSnackBar(
        title: 'Please wait',
        message: 'A decision is still being saved.',
        isError: true,
      );
      return;
    }
    noteController.clear();
    _openSheetRequestId = request.id;
    Get.bottomSheet(
      AdditionalPayActionSheet(
        request: request,
        isApprove: isApprove,
        noteController: noteController,
        submittingId: submittingId,
        onConfirm: () => _resolve(
          request,
          isApprove
              ? AdditionalPayStatus.approved
              : AdditionalPayStatus.rejected,
          isApprove
              ? '${request.amountLabel} approved for ${request.driverName ?? ''}'
              : 'Request from ${request.driverName ?? ''} rejected',
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Get.context!.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    ).whenComplete(() {
      if (_openSheetRequestId == request.id) _openSheetRequestId = null;
    });
  }

  /// Nothing is mutated until the API confirms — a money decision shouldn't
  /// appear applied and then roll back. The response echoes the decided record,
  /// so the row is replaced rather than patched field by field.
  Future<void> _resolve(
    AdditionalPayEntity request,
    AdditionalPayStatus status,
    String message,
  ) async {
    if (isSubmitting) return;

    final String note = noteController.text.trim();
    if (!status.acceptsNote(note)) {
      CommonWidgets.showSnackBar(
        title: 'Note required',
        message: 'Add a note explaining the '
            '${status == AdditionalPayStatus.approved ? 'approval' : 'rejection'}',
        isError: true,
      );
      return;
    }
    if (request.id == null) {
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: 'This request is missing an id and cannot be resolved.',
        isError: true,
      );
      return;
    }

    submittingId.value = request.id;
    final Either<AdditionalPayEntity, Failure> response;
    try {
      response = await resolveAdditionalPayUsecase.call(
        ResolveAdditionalPayParams(
          id: request.id!,
          status: status,
          decisionNote: note.isEmpty ? null : note,
        ),
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: 'Could not reach the server. Try again.',
        isError: true,
      );
      debugPrint('resolveAdditionalPay failed: $e');
      return;
    } finally {
      submittingId.value = null;
    }

    response.fold((AdditionalPayEntity updated) {
      final AdditionalPayStatus previous = request.status.value;
      final int index = requests.indexWhere((r) => r.id == request.id);
      if (updated.id != null && index != -1) {
        // Server copy carries decidedBy/decidedAt and the settled pay figures,
        // which a field-by-field patch would leave stale.
        requests[index] = updated;
      } else {
        request.note.value = note.isEmpty ? null : note;
        request.status.value = status;
      }
      _shiftCount(previous, status);
      _recompute();
      // Sheets are dismissible, so an unguarded pop could close a later sheet
      // — or the page itself.
      if (_openSheetRequestId == request.id &&
          (Get.isBottomSheetOpen ?? false)) {
        Get.back();
      }
      // The decision saved — red is for a failed request, not a rejected one.
      CommonWidgets.showSnackBar(
        title: status.label,
        message: message,
        isError: false,
      );
    }, (failure) {
      // Sheet stays open so the note survives and the action can be retried.
      CommonWidgets.showSnackBar(
        title: 'Error',
        message: failure.message,
        isError: true,
      );
    });
  }
}
