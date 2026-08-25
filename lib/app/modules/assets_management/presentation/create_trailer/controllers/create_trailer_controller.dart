import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/mixins/assets_update_mixin.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/create_dropdown_entity.dart';
import '../../../domain/entities/trailer_entity.dart';
import '../../../domain/usecases/create_vehicle_usecase.dart';
import '../../../domain/usecases/get_create_dropdown_usecase.dart';
import '../../../domain/usecases/get_single_trailer_usecase.dart';
import '../../../domain/usecases/update_vehicle_usecase.dart';
import '../../trailers/controllers/trailers_controller.dart';

class CreateTrailerController extends GetxController with AssetsUpdateMixin {
  // usecases
  final getCreateDropdownUsecase = sl<GetCreateDropdownUsecase>();
  final getSingleTrailerUsecase = sl<GetSingleTrailerUsecase>();
  final createVehicleUsecase = sl<CreateVehicleUsecase>();
  final updateVehicleUsecase = sl<UpdateVehicleUsecase>();

  // controllers
  final PageController pageController = PageController();

  // data variables
  final trailerId = ''.obs;
  final isLoading = false.obs;
  final _isUpdate = false.obs;
  final isCreating = false.obs;
  bool get isUpdate => _isUpdate.value;
  final errorWhileLoadingDropdown = false.obs;

  final trailerEntity = Rxn<TrailerEntity>();

  final createDropdown = Rxn<CreateDropdownEntity>();
  final selectedType = Rxn<Item>();
  final selectedState = Rxn<Item>();

  final RxInt vehicleCreationState = VehicleCreationStates.general.obs;

  // Form key for validation
  final generalFormKey = GlobalKey<FormState>();
  final ownerShipFormKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  // general tab fields
  final selectedOwnerShip = ''.obs;
  final maker = TextEditingController();
  final identifier = TextEditingController();
  final model = TextEditingController();
  final year = TextEditingController();
  final vin = TextEditingController();
  final titleNumber = TextEditingController();

  // ownership tab fields
  final licensePlateNumber = TextEditingController();
  final financedBy = TextEditingController();
  final ownedBy = TextEditingController();
  final purchaseDate = TextEditingController();
  final purchasePrice = TextEditingController();
  final saleDate = TextEditingController();
  final salePrice = TextEditingController();

  // lease and maintenance tab fields
  // lease tab fields
  final leaseCompany = TextEditingController();
  final leaseReference = TextEditingController();
  final nextInspectionOn = TextEditingController();
  final inServiceOn = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    // getCreateDropdown();
    vehicleCreationState.listen((state) {
      if (state >= 0 && state < 3) {
        pageController.animateToPage(
          state,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    final trailer = Get.arguments;
    if (Get.arguments != null && trailer is TrailerEntity) {
      trailerId.value = trailer.id.toString();
      _isUpdate.value = true;
      await init();
    } else {
      await getCreateDropdown();
    }
  }

  Future<void> init() async {
    trailerEntity.value = await getSingleTruck(
      id: trailerId.value,
    );

    await getCreateDropdown();

    _setTextControllers(trailerEntity.value!);

    syncTrailers(
      id: trailerId.value,
      updatedTrailer: trailerEntity.value!,
    );
  }

  Future<TrailerEntity?> getSingleTruck({
    required String id,
  }) async {
    try {
      final body = {'id': id};
      isLoading.value = true;
      final response = await getSingleTrailerUsecase(body);
      return response.fold(
        (success) => success,
        (failure) {
          Get.snackbar('Error', failure.message);
          return null;
        },
      );
    } catch (e) {
      debugPrint('Error $e');
      Get.snackbar('Error', 'An unexpected error occurred.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCreateDropdown() async {
    //! optimize this
    isLoading.value = true;
    errorWhileLoadingDropdown.value = false;

    try {
      final response = await getCreateDropdownUsecase({'isTrailer': true});
      return response.fold((CreateDropdownEntity dataFromApi) {
        createDropdown.value = dataFromApi;

        // set selected items if in update mode
        if (isUpdate == false) {
          return;
        }
        try {
          if (trailerEntity.value?.type != null) {
            selectedType.value = _findItemById(
              createDropdown.value?.types,
              trailerEntity.value?.type.toString(),
            );
          }

          if (trailerEntity.value?.stateName != null) {
            selectedState.value = _findItemById(
              createDropdown.value?.states,
              trailerEntity.value?.stateId.toString(),
            );
          }
        } catch (e) {
          debugPrint('Error setting selected type or state: $e');
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
        errorWhileLoadingDropdown.value = true;
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      errorWhileLoadingDropdown.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrEditTrailer() async {
    final body = _prepairTrailerBody();
    try {
      isCreating.value = true;
      final response = _isUpdate.value
          ? await updateVehicleUsecase(body)
          : await createVehicleUsecase(body);
      return response.fold((bool created) async {
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message:
              'Trailer ${_isUpdate.value ? 'updated' : 'created'} successfully',
          isError: false,
        );

        if (isUpdate) {
          await init();
        } else {
          Get.find<TrailersController>().handleRefresh();
        }

        Navigator.pop(Get.context!);
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: 'Error'.tr,
          message: r.message,
        );
      });
    } catch (e) {
      debugPrint('Error $e');
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isCreating.value = false;
    }
  }

  void onBackPressed(bool didPop) {
    if (vehicleCreationState.value > VehicleCreationStates.values.first) {
      vehicleCreationState.value--;
    } else if ((!didPop) && (!isCreating.value)) {
      Get.back(canPop: true);
    }
  }

  void submitGeneralStep() {
    if (!(generalFormKey.currentState?.validate() ?? false)) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }
    if (selectedType.value == null) {
      Get.snackbar('Error', 'Please select a type');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    vehicleCreationState.value++;
  }

  void submitOwnershipStep() {
    if (!(ownerShipFormKey.currentState?.validate() ?? false)) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }
    if (selectedState.value == null) {
      Get.snackbar('Error', 'Please select a state');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    vehicleCreationState.value++;
  }

  void submitTrailer() {
    FocusManager.instance.primaryFocus?.unfocus();
    createOrEditTrailer();
  }

  String getStepName(int step) {
    switch (step) {
      case 0:
        return "General";
      case 1:
        return "Ownership";
      case 2:
        return "Lease & \nMaintenance";
      default:
        return "";
    }
  }

  Map<String, dynamic> _prepairTrailerBody() {
    final body = {
      'isTrailer': true,
      'owner_type': selectedOwnerShip.value.toString(),
      'type': selectedType.value?.id.toString(),
      'identifier': identifier.text,
      'maker': maker.text,
      'model': model.text,
      'making_year': year.text,
      'vin': vin.text,
      'title_number': titleNumber.text,
      'licence_plate_number': licensePlateNumber.text,
      "state": {
        "id": selectedState.value?.id,
      },
      'financed_by': financedBy.text,
      'owned_by': ownedBy.text,
      'purchase_date': purchaseDate.text,
      'purchase_price': purchasePrice.text,
      'sale_date': saleDate.text,
      'sale_price': salePrice.text,
      'leasing_company': leaseCompany.text,
      'lease_reference': leaseReference.text,
      'next_inspection_on': nextInspectionOn.text,
      'in_service_on': inServiceOn.text,
    };
    if (isUpdate) {
      body['id'] = trailerId.value;
    }

    return body;
  }

  void _setTextControllers(TrailerEntity truck) {
    debugPrint('Setting text controllers with truck id: ${truck.id}');
    // General tab fields
    identifier.text = truck.identifier?.toString() ?? '';
    maker.text = truck.maker ?? '';
    model.text = truck.model ?? '';
    year.text = truck.makingYear?.toString() ?? '';
    vin.text = truck.vin ?? '';
    titleNumber.text = truck.titleNumber ?? '';

    // Plate tab fields
    licensePlateNumber.text = truck.licencePlateNumber ?? '';

    // Ownership tab fields
    if (truck.ownerType != null &&
            truck.ownerType?.toLowerCase() == 'company-trailers' ||
        truck.ownerType?.toLowerCase() == 'owner-trailers') {
      selectedOwnerShip.value = truck.ownerType!;
    }
    if (truck.ownedBy != null) {
      ownedBy.text = truck.ownedBy ?? '';
    }
    financedBy.text = truck.financedBy ?? '';

    if (truck.purchaseDate != null) {
      purchaseDate.text = DateFormat('yyyy-MM-dd').format(truck.purchaseDate!);
    }
    purchasePrice.text = truck.purchasePrice?.toString() ?? '';
    if (truck.saleDate != null) {
      saleDate.text = DateFormat('yyyy-MM-dd').format(truck.saleDate!);
    }
    salePrice.text = truck.salePrice?.toString() ?? '';

    // Lease tab fields
    leaseCompany.text = truck.leasingCompany ?? '';
    leaseReference.text = truck.leaseReference ?? '';

    // Maintenance tab fields
    if (truck.nextInspectionOn != null) {
      nextInspectionOn.text = DateFormat('yyyy-MM-dd').format(
        truck.nextInspectionOn!,
      );
    }
    if (truck.inServiceOn != null) {
      inServiceOn.text = DateFormat('yyyy-MM-dd').format(truck.inServiceOn!);
    }
  }

  @override
  void onClose() {
    pageController.dispose();

    maker.dispose();
    identifier.dispose();
    model.dispose();
    year.dispose();
    vin.dispose();
    titleNumber.dispose();
    licensePlateNumber.dispose();
    financedBy.dispose();
    ownedBy.dispose();
    purchaseDate.dispose();
    purchasePrice.dispose();
    saleDate.dispose();
    salePrice.dispose();
    leaseCompany.dispose();
    leaseReference.dispose();
    nextInspectionOn.dispose();
    inServiceOn.dispose();
    super.onClose();
  }

  T? _findItemById<T extends dynamic>(List<T>? items, String? id) {
    if (items == null || id == null) {
      return null;
    }

    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}

class VehicleCreationStates {
  static const general = 0;
  static const ownership = 1;
  static const lease = 2;

  static const values = [general, ownership, lease];
}
