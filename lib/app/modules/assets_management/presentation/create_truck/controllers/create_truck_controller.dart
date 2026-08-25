import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/mixins/assets_update_mixin.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/create_dropdown_entity.dart';
import '../../../domain/entities/truck_entity.dart';
import '../../../domain/usecases/create_vehicle_usecase.dart';
import '../../../domain/usecases/get_create_dropdown_usecase.dart';
import '../../../domain/usecases/get_single_truck_usecase.dart';
import '../../../domain/usecases/update_vehicle_usecase.dart';
import '../../trucks/controllers/trucks_controller.dart';

class CreateTruckController extends GetxController with AssetsUpdateMixin {
  // usecases
  final getCreateDropdownUsecase = sl<GetCreateDropdownUsecase>();
  final getSingleTruckUsecase = sl<GetSingleTruckUsecase>();
  final createVehicleUsecase = sl<CreateVehicleUsecase>();
  final updateVehicleUsecase = sl<UpdateVehicleUsecase>();

  // controllers
  final PageController pageController = PageController();

  // data variables
  final truckId = ''.obs;
  final isLoading = false.obs;
  final isCreating = false.obs;
  final _isUpdate = false.obs;
  bool get isUpdate => _isUpdate.value;

  final errorWhileLoadingDropdown = false.obs;

  // add rxn for truck entity
  final truckEntity = Rxn<TruckEntity>();

  final createDropdown = Rxn<CreateDropdownEntity>();
  final selectedType = Rxn<Item>();
  final selectedState = Rxn<Item>();
  final selectedLessor = Rxn<Item>();

  final RxInt vehicleCreationState = TruckCreationStates.general.obs;

  // Form key for validation
  final generalFormKey = GlobalKey<FormState>();
  final plateFormKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  // general tab fields
  final maker = TextEditingController();
  final identifier = TextEditingController();
  final model = TextEditingController();
  final year = TextEditingController();
  final engineMaker = TextEditingController();
  final engineModel = TextEditingController();
  final engineYear = TextEditingController();
  final vin = TextEditingController();
  final titleNumber = TextEditingController();
  final truckColor = TextEditingController();
  final selectedGlider = ''.obs;

  // plate tab fields
  final licensePlateNumber = TextEditingController();
  final licensePlateState = TextEditingController();
  final tagsExpireOn = TextEditingController();
  final platesOwnedBy = TextEditingController();

  // ownership tab fields
  final selectedOwnerShip = ''.obs;
  final financedBy = TextEditingController();
  final ownerName = TextEditingController();
  final ownerPhone = TextEditingController();
  final purchaseDate = TextEditingController();
  final purchasePrice = TextEditingController();
  final saleDate = TextEditingController();
  final salePrice = TextEditingController();

  // lease tab fields
  final leaseCompany = TextEditingController();
  final leaseReference = TextEditingController();
  final leaseEndDate = TextEditingController();
  final leaseEarlyWalkDate = TextEditingController();
  final leaseMonthlyPayment = TextEditingController();
  final leaseMaintenanceCPM = TextEditingController();
  final leaseMileageYearlyAllowance = TextEditingController();

  // maintenance tab fields
  final nextInspectionOn = TextEditingController();
  final inServiceOn = TextEditingController();
  final nextServiceOn = TextEditingController();
  final emptyWeight = TextEditingController();
  final grossWeight = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    vehicleCreationState.listen((state) {
      if (state >= 0 && state < 5) {
        pageController.animateToPage(
          state,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    final truck = Get.arguments;
    if (Get.arguments != null && truck is TruckEntity) {
      truckId.value = truck.id.toString();
      _isUpdate.value = true;
      await init();
    } else {
      await getCreateDropdown();
    }
  }

  Future<void> init() async {
    truckEntity.value = await getSingleTruck(
      id: truckId.value,
    );

    await getCreateDropdown();

    _setTextControllers(truckEntity.value!);

    syncTrucks(
      id: truckId.value,
      updatedTruck: truckEntity.value!,
    );
  }

  Future<TruckEntity?> getSingleTruck({
    required String id,
  }) async {
    try {
      final body = {'id': id};
      isLoading.value = true;
      final response = await getSingleTruckUsecase(body);
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
    try {
      isLoading.value = true;
      errorWhileLoadingDropdown.value = false;
      final response = await getCreateDropdownUsecase({});
      return response.fold((CreateDropdownEntity dataFromApi) {
        createDropdown.value = dataFromApi;

        // set selected items if in update mode
        if (isUpdate == false) {
          return;
        }
        try {
          if (truckEntity.value?.type != null) {
            selectedType.value = _findItemById(
              createDropdown.value?.types,
              truckEntity.value?.type.toString(),
            );
          }
        } catch (e) {
          debugPrint('Error setting selected type or state: $e');
        }

        try {
          if (truckEntity.value?.licencePlateStateId != null) {
            selectedState.value = _findItemById(
              createDropdown.value?.states,
              truckEntity.value?.licencePlateStateId.toString(),
            );
          }
        } catch (e) {
          debugPrint('Error setting selected state: $e');
        }

        try {
          if (truckEntity.value?.lessorId != null) {
            selectedLessor.value = _findItemById(
              createDropdown.value?.lessors,
              truckEntity.value?.lessorId.toString(),
            );
          }
        } catch (e) {
          debugPrint('Error setting selected lessor: $e');
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

  Future<void> createOrEditTruck() async {
    final body = _prepairTruckBody();
    try {
      isCreating.value = true;
      final response = _isUpdate.value
          ? await updateVehicleUsecase(body)
          : await createVehicleUsecase(body);
      return response.fold((bool created) async {
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message:
              'Truck ${_isUpdate.value ? 'updated' : 'created'} successfully',
          isError: false,
        );

        if (isUpdate) {
          await init();
        } else {
          Get.find<TrucksController>().handleRefresh();
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

  @override
  void onClose() {
    pageController.dispose();

    // Dispose of all text editing controllers
    // General tab controllers
    maker.dispose();
    identifier.dispose();
    model.dispose();
    year.dispose();
    engineMaker.dispose();
    engineModel.dispose();
    engineYear.dispose();
    vin.dispose();
    titleNumber.dispose();
    truckColor.dispose();

    // Plate tab controllers
    licensePlateNumber.dispose();
    licensePlateState.dispose();
    tagsExpireOn.dispose();
    platesOwnedBy.dispose();

    // Ownership tab controllers
    financedBy.dispose();
    ownerName.dispose();
    ownerPhone.dispose();
    purchaseDate.dispose();
    purchasePrice.dispose();
    saleDate.dispose();
    salePrice.dispose();

    // Lease tab controllers
    leaseCompany.dispose();
    leaseReference.dispose();
    leaseEndDate.dispose();
    leaseEarlyWalkDate.dispose();
    leaseMonthlyPayment.dispose();
    leaseMaintenanceCPM.dispose();
    leaseMileageYearlyAllowance.dispose();

    // Maintenance tab controllers
    nextInspectionOn.dispose();
    inServiceOn.dispose();
    nextServiceOn.dispose();
    emptyWeight.dispose();
    grossWeight.dispose();

    super.onClose();
  }

  void onBackPressed(bool didPop) {
    if (vehicleCreationState.value > TruckCreationStates.values.first) {
      vehicleCreationState.value--;
    } else if ((!didPop) && (!isCreating.value)) {
      Get.back(canPop: true);
    }
  }

  String getStepName(int step) {
    switch (step) {
      case 0:
        return "General";
      case 1:
        return "Plate";
      case 2:
        return "Ownership";
      case 3:
        return "Lease";
      case 4:
        return "Maintenance";
      default:
        return "";
    }
  }

  Map<String, dynamic> _prepairTruckBody() {
    final body = {
      'maker': maker.text,
      'identifier': identifier.text,
      'model': model.text,
      'making_year': year.text,
      'engine_maker': engineMaker.text,
      'engine_model': engineModel.text,
      'engine_year': engineYear.text,
      'type': selectedType.value?.id.toString(),
      'vin': vin.text,
      'title_number': titleNumber.text,
      'color': truckColor.text,
      'glider': selectedGlider.value.toLowerCase() == 'yes' ? 1 : 0,
      'licence_plate_number': licensePlateNumber.text,
      "licence_state": {
        "id": selectedState.value?.id,
      },
      'tags_expires_on': tagsExpireOn.text,
      'plates_owned_by': platesOwnedBy.text,
      'owned_by': selectedOwnerShip.value.toString(),
      'lessor': {
        'id': selectedLessor.value?.id,
      },
      'financed_by': financedBy.text,
      'owner_name': ownerName.text,
      'owner_phone': ownerPhone.text,
      'purchase_date': purchaseDate.text,
      'purchase_price': purchasePrice.text,
      'sale_date': saleDate.text,
      'sale_price': salePrice.text,
      'leasing_company': leaseCompany.text,
      'lease_reference': leaseReference.text,
      'lease_end_date': leaseEndDate.text,
      'lease_early_walk_date': leaseEarlyWalkDate.text,
      'lease_monthly_payment': leaseMonthlyPayment.text,
      'lease_maintenance_cpm': leaseMaintenanceCPM.text,
      'lease_mileage_yearly_allowance': leaseMileageYearlyAllowance.text,
      'next_inspection_on': nextInspectionOn.text,
      'in_service_on': inServiceOn.text,
      'next_service_on': nextServiceOn.text,
      'empty_weight': emptyWeight.text,
      'gross_weight': grossWeight.text,
    };

    if (_isUpdate.value == true && truckEntity.value != null) {
      body['id'] = truckEntity.value!.id;
    }

    return body;
  }

  void _setTextControllers(TruckEntity truck) {
    debugPrint('Setting text controllers with truck id: ${truck.id}');
    // General tab fields
    maker.text = truck.maker ?? '';
    identifier.text = truck.identifier?.toString() ?? '';
    model.text = truck.model ?? '';
    year.text = truck.makingYear?.toString() ?? '';
    engineMaker.text = truck.engineMaker ?? '';
    engineModel.text = truck.engineModel ?? '';
    engineYear.text = truck.engineYear?.toString() ?? '';
    vin.text = truck.vin ?? '';
    titleNumber.text = truck.titleNumber ?? '';
    truckColor.text = truck.color ?? '';
    selectedGlider.value = truck.glider.toString() == "1" ? 'Yes' : 'No';

    // Plate tab fields
    licensePlateNumber.text = truck.licencePlateNumber ?? '';
    if (truck.licencePlateStateId != null) {
      selectedState.value = _findItemById(
        createDropdown.value?.states,
        truck.licencePlateStateId.toString(),
      );
    }
    tagsExpireOn.text = DateFormat('yyyy-MM-dd').format(
      truck.tagsExpiresOn!,
    );
    platesOwnedBy.text = truck.platesOwnedBy ?? '';

    // Ownership tab fields
    if (truck.ownedBy != null) {
      selectedOwnerShip.value = truck.ownedBy!.substring(0, 4).toLowerCase();
    }
    financedBy.text = truck.financedBy ?? '';
    ownerName.text = truck.ownerName ?? '';
    ownerPhone.text = truck.ownerPhone ?? '';
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
    if (truck.leaseEndDate != null) {
      leaseEndDate.text = DateFormat('yyyy-MM-dd').format(truck.leaseEndDate!);
    }
    if (truck.leaseEarlyWalkDate != null) {
      leaseEarlyWalkDate.text =
          DateFormat('yyyy-MM-dd').format(truck.leaseEarlyWalkDate!);
    }
    leaseMonthlyPayment.text = truck.leaseMonthlyPayment?.toString() ?? '';
    leaseMaintenanceCPM.text = truck.leaseMaintenanceCpm?.toString() ?? '';
    leaseMileageYearlyAllowance.text =
        truck.leaseMileageYearlyAllowance?.toString() ?? '';

    if (truck.lessorId != null) {
      selectedLessor.value = _findItemById(
        createDropdown.value?.lessors,
        truck.lessorId.toString(),
      );
    }
    // Maintenance tab fields
    if (truck.nextInspectionOn != null) {
      nextInspectionOn.text = DateFormat('yyyy-MM-dd').format(
        truck.nextInspectionOn!,
      );
    }
    if (truck.inServiceOn != null) {
      inServiceOn.text = DateFormat('yyyy-MM-dd').format(truck.inServiceOn!);
    }
    if (truck.nextServiceOn != null) {
      nextServiceOn.text = DateFormat('yyyy-MM-dd').format(
        truck.nextServiceOn!,
      );
    }
    emptyWeight.text = truck.emptyWeight?.toString() ?? '';
    grossWeight.text = truck.grossWeight?.toString() ?? '';
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

class TruckCreationStates {
  static const general = 0;
  static const plate = 1;
  static const ownership = 2;
  static const lease = 3;
  static const maintenance = 4;
  static const values = [
    general,
    plate,
    ownership,
    lease,
    maintenance,
  ];
}
