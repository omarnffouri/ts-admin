import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/inspection_dropdown_entity.dart';
import '../../../domain/usecases/create_inspection_usecase.dart';
import '../../../domain/usecases/get_inspection_dropdown.dart';
import '../../driver_inspection/controllers/driver_inspection_controller.dart';
import '../../truck_trailer_inspection/controllers/truck_trailer_inspection_controller.dart';

class CreateInspectionRequestController extends GetxController {
  // usecase
  final getInspectionDropdownUsecase = sl<GetInspectionDropdownUsecase>();
  final createInspectionRequestUsecase = sl<CreateInspectionRequestUsecase>();

  // variables
  final refreshController = RefreshController();
  final serviceDropdown = Rxn<InspectionDropdownEntity>(null);
  final selectedCategory = Rxn<String>(null);
  final selectedUnit = Rxn<ItemEntity>(null);
  final GlobalKey formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final type = "".obs;

  final dropdownCategory = <String>[
    "driver",
    "truck",
    "trailer",
  ].obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('CreateInspectionRequestController onInit');

    final requestType = Get.arguments as String?;
    if (requestType != null) {
      type.value = requestType;
      debugPrint('Type: $type');
      selectedCategory.value = type.value;
      getInspectionDropdown();
    }
  }

  Future<void> getInspectionDropdown() async {
    selectedUnit.value = null;
    try {
      isLoading(true);
      final response = await getInspectionDropdownUsecase(const NoParams());
      response.fold((InspectionDropdownEntity response) {
        serviceDropdown.value = response;
      }, (Failure failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleRefresh() async {
    await getInspectionDropdown();
    refreshController.refreshCompleted();
  }

  List<ItemEntity> getUnitlist() {
    if (selectedCategory.value == null) {
      return [];
    } else {
      if (selectedCategory.value?.toLowerCase() == 'driver') {
        final items = serviceDropdown.value?.drivers ?? [];
        return items;
      }
      if (selectedCategory.value?.toLowerCase() == 'truck') {
        final items = serviceDropdown.value?.trucks ?? [];
        return items;
      }
      if (selectedCategory.value?.toLowerCase() == 'trailer') {
        final items = serviceDropdown.value?.trailers ?? [];
        return items;
      }
    }

    return [];
  }

  Future<void> createInspectionRequest() async {
    final unit = selectedUnit.value;
    final category = selectedCategory.value;
    final isDriver = category == 'driver';
    // Validate selected unit or driver
    if (unit == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: isDriver ? 'Please select a driver' : 'Please select a unit',
      );
      return;
    }

    final body = {
      'id': unit.id,
      'type': category,
    };
    debugPrint('body: $body');
    try {
      isSubmitting.value = true;
      final result = await createInspectionRequestUsecase.call(body);
      result.fold(
        (success) {
          // Show success message once
          CommonWidgets.showSnackBar(
            title: 'Success'.tr,
            message: 'Inspection request created successfully'.tr,
            isError: false,
          );

          // Refresh the appropriate list based on category
          if (isDriver) {
            Get.put(DriverInspectionController())
                .getAllDriverPendingInspections();
          } else {
            Get.put(TruckTrailerInspectionController())
                .getAllTruckTrailerPendingInspection();
          }

          // Navigate back to the previous screen
          Navigator.pop(Get.context!);
        },
        (e) {
          CommonWidgets.showSnackBar(
            title: 'Error'.tr,
            message: e.toString(),
          );
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
