import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/entities/inspection_details_entity.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/usecases/get_inspection_details_usecase.dart';

class InspectionDetailsController extends GetxController {
  // usecases
  final getInspectionDetailsUsecase = sl<GetInspectionDetailsUsecase>();

  // body refresh controllers
  final RefreshController refreshController = RefreshController();

  // loading state variables
  final _inspectionDetails = const InspectionDetailsEntity().obs;
  InspectionDetailsEntity get inspectionDetails => _inspectionDetails.value;
  final inspectionFields = [].obs;
  final RxInt expandedIndex = (-1).obs;
  final RxBool isLoading = false.obs;
  final type = "".obs;
  final id = "".obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('InspectionDetailsController');
    if (Get.arguments != null) {
      final Map<String, dynamic> args = Get.arguments;
      type.value = args['type'] ?? "";
      id.value = args['id'] ?? "";
      getInspectionDetails();
    }
  }

  Future<void> getInspectionDetails() async {
    expandedIndex.value = -1;
    inspectionFields.clear();
    try {
      isLoading.value = true;
      final body = {"type": type.value, "id": id.value};
      debugPrint('body: $body');
      final result = await getInspectionDetailsUsecase.call(body);
      result.fold(
        (InspectionDetailsEntity details) {
          _inspectionDetails.value = details;
          inspectionFields.value = details.inspectionDetail ?? [];
        },
        (failure) {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Error loading inspection types",
            isError: true,
          );
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void handleRefresh() {
    getInspectionDetails();
    refreshController.refreshCompleted();
  }

  int getTitlePassStatus(InspectionDataEntity inspectionM) {
    final passedInspections = inspectionM.checks!
        .where(
          (element) => element.needRepair == false,
        )
        .length;
    return passedInspections;
  }

  onTileExpantionChanged(int index, bool expanded) {
    if (!expanded) {
      if (index == expandedIndex.value) {
        expandedIndex.value = -1;
      }
      return;
    }

    if (inspectionFields.isEmpty) {
      return;
    }

    for (int i = 0; i < inspectionFields.length; i++) {
      if (i != index) {
        inspectionFields[i].tileController.collapse();
      }
    }
    expandedIndex.value = index;
  }
}
