import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/technician_entity.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_all_technicians.dart';
import 'package:ts_admin/app/modules/shop_management/presentation/components/confirmation_bottom_sheet.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/usecases/disable_technican.dart';

class TechniciansController extends GetxController
    with GetTickerProviderStateMixin {
  //
  //
  // body refresh controllers
  final RefreshController refreshController = RefreshController();
  late final AnimationController searchExpandedController;
  final TextEditingController txtSearchController = TextEditingController();

  //
  //
  // usecases
  final getAllTechniciansUsecase = sl<GetAllTechniciansUsecase>();
  final disableTechnicanUsecase = sl<DisableTechnicanUsecase>();

  //
  //
  // states
  final RxBool isLoading = false.obs;
  final RxBool deletingTechnician = false.obs;
  final RxBool isSearchEnabled = false.obs;
  final txtSearch = ''.obs;

  //
  //
  // data variables
  final RxList<TechnicianEntity> technicians = RxList();

  @override
  void onInit() {
    super.onInit();
    getAllTechnicians();
    searchExpandedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    txtSearchController.addListener(() {
      txtSearch.value = txtSearchController.text;
    });
  }

  Future<void> handleRefresh() async {
    await getAllTechnicians();
    refreshController.refreshCompleted();
  }

  Future<void> getAllTechnicians() async {
    filterList.clear();
    try {
      isLoading(true);
      final response = await getAllTechniciansUsecase.call(const NoParams());
      response.fold((response) {
        technicians.value = response;
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
      isLoading(false);
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  RxList<TechnicianEntity> get filterList {
    // no filter no search
    if (txtSearch.isEmpty) {
      return technicians;
      // filter no search
    } else {
      return technicians
          .where((element) =>
              element.name
                  ?.toLowerCase()
                  .contains(txtSearch.value.toLowerCase()) ??
              false)
          .toList()
          .obs;
    }
  }

  Future<void> onDisableTechnicianCicked(TechnicianEntity technician) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return ConfirmationBottomSheet(
          name: technician.name ?? "",
          title: technician.isActive == true
              ? 'Disable Technician ?'
              : 'Enable Technician ?',
          isLoading: deletingTechnician,
          confirmText: technician.isActive == true ? 'Disable ' : 'Enable ',
          confirmTextBtn: technician.isActive == true ? 'Disable' : 'Enable',
          onConfirm: () {
            disableTechnician(technician);
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> disableTechnician(TechnicianEntity technician) async {
    if (deletingTechnician.value) {
      return;
    }

    deletingTechnician.value = true;

    try {
      final isActive = technician.isActive;
      final body = {
        'id': technician.id,
        'status': isActive == true ? 'inactive' : 'active',
      };
      final result = await disableTechnicanUsecase.call(body);
      result.fold(
        (success) {
          if (success) {
            CommonWidgets.showSnackBar(
              title: 'Success'.tr,
              message:
                  'Technician ${isActive == true ? 'Disabled' : 'Enabled'} successfully'
                      .tr,
              isError: false,
            );
            // todo check if this is needed
            Navigator.pop(Get.context!);
            getAllTechnicians();
          } else {
            CommonWidgets.showSnackBar(
              title: 'Error'.tr,
              message: 'Failed to update the Technician'.tr,
            );
          }
        },
        (e) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: e.toString(),
          );
        },
      );
      deletingTechnician.value = false;
    } catch (e) {
      deletingTechnician.value = false;
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    try {
      txtSearchController.dispose();
    } catch (e) {
      debugPrint("Controller already disposed: $e");
    }
    super.onClose();
  }
}
