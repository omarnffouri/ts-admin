import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/system_rules_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_driver_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/delete_inspection_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_inspected_drivers_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_pending_drivers_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class DriverInspectionController extends GetxController {
  final authController = Get.find<AuthController>();

  final getInspectedDriverUsecase = sl<GetInspectedDriverUsecase>();
  final getPendingDriverUsecase = sl<GetPendingDriverUsecase>();
  final deleteInspectionUsecase = sl<DeleteInspectionUsecase>();

  final type = "driver";
  final RxInt pendingExpandedIndex = (-1).obs;
  final RxInt requestedExpandedIndex = (-1).obs;

  RefreshController pendingRefreshController = RefreshController(
    initialRefresh: false,
  );

  RefreshController requestedRefreshController = RefreshController(
    initialRefresh: false,
  );

  //
  final RxList<InspectionDriverEntity> driverPendingInspectionsList =
      <InspectionDriverEntity>[].obs;

  final RxList<InspectionDriverEntity> driverRequestedInspectionsList =
      <InspectionDriverEntity>[].obs;

  final isLoadingPendingInspection = false.obs;
  final isLoadingRequestedInspection = false.obs;

  final tabIndex = 0.obs;

  bool get isSuperAdmin =>
      authController.user.value?.hasAnyRole([
        SystemRulesKeys.superAdmin,
      ]) ??
      false;

  @override
  void onInit() {
    super.onInit();
    getAllDriverInspections();
  }

  Future<void> getAllDriverInspections() async {
    Future.wait([
      getAllDriverPendingInspections(),
      getAllDriverRequestedInspections(),
    ]);
  }

  Future<void> getAllDriverPendingInspections() async {
    driverPendingInspectionsList.clear();
    try {
      isLoadingPendingInspection.value = true;
      final body = {'type': type};
      final Either<List<InspectionDriverEntity>, Failure> response =
          await getPendingDriverUsecase.call(body);
      response.fold(
        (List<InspectionDriverEntity> data) {
          driverPendingInspectionsList.addAll(data.toSet().toList());
        },
        (r) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: r.message,
          );
        },
      );
      isLoadingPendingInspection.value = false;
    } catch (e) {
      isLoadingPendingInspection.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Something went wrong ${e.toString()}',
      );
    }
  }

  Future<void> getAllDriverRequestedInspections() async {
    driverRequestedInspectionsList.clear();
    try {
      isLoadingRequestedInspection.value = true;
      final body = {'type': type};
      final Either<List<InspectionDriverEntity>, Failure> response =
          await getInspectedDriverUsecase.call(body);
      response.fold(
        (List<InspectionDriverEntity> data) {
          driverRequestedInspectionsList.addAll(data);
        },
        (r) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: r.message,
          );
        },
      );
      isLoadingRequestedInspection.value = false;
    } catch (e) {
      isLoadingRequestedInspection.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Something went wrong ${e.toString()}',
      );
    }
  }

  // add delete method
  Future<void> deleteRequest(
      InspectionDriverEntity item, bool deletingPendingRequest) async {
    item.isDeleting.value = true;
    // add delay to simulate api call
    try {
      final body = {'id': item.id};
      final Either<bool, Failure> response =
          await deleteInspectionUsecase.call(body);
      response.fold(
        (bool data) {
          CommonWidgets.showSnackBar(
            title: 'Success'.tr,
            message: 'Request deleted successfully',
            isError: false,
          );

          if (deletingPendingRequest) {
            driverPendingInspectionsList
                .removeWhere((element) => element.id == item.id);
            driverPendingInspectionsList.refresh();
          } else {
            driverRequestedInspectionsList
                .removeWhere((element) => element.id == item.id);
            driverRequestedInspectionsList.refresh();
          }
        },
        (r) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: r.message,
          );
        },
      );
      item.isDeleting.value = false;
    } catch (e) {
      item.isDeleting.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: 'Something went wrong ${e.toString()}',
      );
    }
  }

  // onTilePendingInspectionsExpansionChanged(int index, bool expanded) {
  //   if (!expanded) {
  //     if (index == pendingExpandedIndex.value) {
  //       pendingExpandedIndex.value = -1;
  //     }
  //     return;
  //   }

  //   for (int i = 0; i < driverPendingInspectionsList.length; i++) {
  //     if (i != index) {
  //       if (!driverPendingInspectionsList[i].tileController.isExpanded) {
  //         continue;
  //       }
  //       driverPendingInspectionsList[i].tileController.collapse();
  //     }
  //   }
  //   pendingExpandedIndex.value = index;
  // }

  // onTileRequestedInspectionsExpansionChanged(int index, bool expanded) {
  //   if (!expanded) {
  //     if (index == requestedExpandedIndex.value) {
  //       requestedExpandedIndex.value = -1;
  //     }
  //     return;
  //   }

  //   for (int i = 0; i < driverRequestedInspectionsList.length; i++) {
  //     if (i != index) {
  //       if (!driverRequestedInspectionsList[i].tileController.isExpanded) {
  //         continue;
  //       }
  //       driverRequestedInspectionsList[i].tileController.collapse();
  //     }
  //   }
  //   requestedExpandedIndex.value = index;
  // }
}
