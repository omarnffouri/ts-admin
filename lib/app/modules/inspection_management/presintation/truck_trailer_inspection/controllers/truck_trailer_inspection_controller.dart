import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/values/system_rules_keys.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/pending_truck_entity.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/delete_inspection_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_inspected_trailer_truck_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_pending_trailer_truck_usecase.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class TruckTrailerInspectionController extends GetxController {
  final authController = Get.find<AuthController>();

  final getPendingTrailerTruckUsecase = sl<GetPendingTrailerTruckUsecase>();
  final getInspectedTrailerTruckUsecase = sl<GetInspectedTrailerTruckUsecase>();
  final deleteInspectionUsecase = sl<DeleteInspectionUsecase>();

  final type = "".obs;
  final RxInt pendingExpandedIndex = (-1).obs;
  final RxInt requestedExpandedIndex = (-1).obs;

  RefreshController pendingRefreshController = RefreshController(
    initialRefresh: false,
  );

  RefreshController requestedRefreshController = RefreshController(
    initialRefresh: false,
  );

  //
  final RxList<InspectionTrailerTruckEntity> pendingInspectionList =
      <InspectionTrailerTruckEntity>[].obs;
  final RxList<InspectionTrailerTruckEntity> requestedInspectionList =
      <InspectionTrailerTruckEntity>[].obs;

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
    //
    //
    // args
    final args = Get.arguments;
    if (args != null && (args is String)) {
      type.value = args;
    } else {
      type.value = "truck";
    }

    //
    //
    // fetch initial data
    getAllTruckTrailerInspections();
  }

  Future<void> getAllTruckTrailerInspections() async {
    Future.wait([
      getAllTruckTrailerPendingInspection(),
      getAllTruckTrailerRequestedInspection(),
    ]);
  }

  Future<void> getAllTruckTrailerPendingInspection() async {
    pendingInspectionList.clear();
    try {
      isLoadingPendingInspection.value = true;

      final body = {'type': type.value};
      final Either<List<InspectionTrailerTruckEntity>, Failure> response =
          await getPendingTrailerTruckUsecase.call(body);
      response.fold(
        (List<InspectionTrailerTruckEntity> data) {
          pendingInspectionList.addAll(data.toSet().toList());
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

  Future<void> getAllTruckTrailerRequestedInspection() async {
    requestedInspectionList.clear();
    try {
      isLoadingRequestedInspection.value = true;

      final body = {'type': type.value};
      final Either<List<InspectionTrailerTruckEntity>, Failure> response =
          await getInspectedTrailerTruckUsecase.call(body);

      response.fold(
        (List<InspectionTrailerTruckEntity> data) {
          requestedInspectionList.addAll(data);
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

  Future<void> deleteRequest(
      InspectionTrailerTruckEntity item, bool deletingPendingRequest) async {
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
            pendingInspectionList
                .removeWhere((element) => element.id == item.id);
            pendingInspectionList.refresh();
          } else {
            requestedInspectionList
                .removeWhere((element) => element.id == item.id);
            requestedInspectionList.refresh();
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

  //   for (int i = 0; i < pendingInspectionList.length; i++) {
  //     if (i != index) {
  //       if (!pendingInspectionList[i].tileController.isExpanded) {
  //         continue;
  //       }
  //       pendingInspectionList[i].tileController.collapse();
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

  //   for (int i = 0; i < requestedInspectionList.length; i++) {
  //     if (i != index) {
  //       if (!requestedInspectionList[i].tileController.isExpanded) {
  //         continue;
  //       }
  //       requestedInspectionList[i].tileController.collapse();
  //     }
  //   }
  //   requestedExpandedIndex.value = index;
  // }
}
