import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/annoucments/domain/entities/annoucement_entity.dart';
import 'package:ts_admin/app/modules/annoucments/domain/usecases/get_all_announcements_usecase.dart';
import 'package:ts_admin/app/modules/annoucments/domain/usecases/update_announcement__read_status_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

/// Single instance shared by the home tab, the dashboard unread badge, the FCM
/// refresh handler and the announcements listing — registered untagged so every
/// consumer resolves the same one.
class AnnoucmentsController extends GetxController {
  // usecases
  final getAllAnnoucementsUsecase = sl<GetAllAnnouncementsUsecase>();
  final updateAnnoucementReadStatusUsecase =
      sl<UpdateAnnouncementReadStatusUsecase>();

  // list of annoucements
  final RxList<AnnoucementEntity> annoucements = RxList<AnnoucementEntity>();

  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  // loading
  final RxBool _isLoadingAnnoucements = false.obs;
  bool get isLoadingAnnoucements => _isLoadingAnnoucements.value;

  final RxBool errorWhileLoadingAnnoucements = false.obs;

  // loading
  final RxBool _isupdatingAnnoucementStatus = false.obs;
  bool get isupdatingAnnoucementStatus => _isupdatingAnnoucementStatus.value;

  final updatingAnnouncementStatusIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    getAllAnnoucements();
  }

  Future<void> getAllAnnoucements() async {
    if (_isLoadingAnnoucements.value) return;
    try {
      // Not cleared upfront: isLoading already drives the skeleton, and the
      // home tab shares this list — blanking it flashes stale-but-valid data
      // off both screens on every refetch.
      _isLoadingAnnoucements(true);
      errorWhileLoadingAnnoucements(false);
      final result = await getAllAnnoucementsUsecase.call(const NoParams());

      result.fold((List<AnnoucementEntity> annoucementsFromApi) {
        // storung annoucements
        annoucements.value = annoucementsFromApi;

        log('annoucements at home list length: ${annoucements.length}');

        _isLoadingAnnoucements(false);
      }, (Failure r) {
        errorWhileLoadingAnnoucements(true);
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        _isLoadingAnnoucements(false);
      });
    } catch (e) {
      errorWhileLoadingAnnoucements(true);
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingAnnoucements(false);
    }
  }

  Future<void> handleRefresh() async {
    await getAllAnnoucements();
    refreshController.refreshCompleted();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Future<void> updateAnnoucementsReadStatus(
      AnnoucementEntity annoucement, int index) async {
    try {
      if (isupdatingAnnoucementStatus) {
        return;
      }
      if (annoucement.read == 1) {
        return;
      }
      if (annoucement.id == null) {
        return;
      }
      updatingAnnouncementStatusIndex(index);

      _isupdatingAnnoucementStatus(true);
      final result =
          await updateAnnoucementReadStatusUsecase.call(annoucement.id!);

      result.fold((bool isReadSucessful) {
        log('annoucement read: $isReadSucessful ===> ${annoucement.id}');
        if (isReadSucessful) {
          annoucements
              .firstWhereOrNull((element) => ((element.id == annoucement.id) &&
                  (element.id != null && annoucement.id != null)))
              ?.read = 1;
          annoucements.refresh();
        }
      }, (Failure r) {
        log('annoucement update read status error: ${r.message}');
      });
      _isupdatingAnnoucementStatus(false);
      updatingAnnouncementStatusIndex(-1);
    } catch (e) {
      log('annoucement update read status error: $e');
      debugPrint(e.toString());
      _isupdatingAnnoucementStatus(false);
      updatingAnnouncementStatusIndex(-1);
    }
  }
}
