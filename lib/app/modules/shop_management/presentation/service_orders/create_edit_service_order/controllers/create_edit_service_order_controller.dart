import 'dart:io';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/mixins/order_update_mixin.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../../domain/entities/service_details.dart';
import '../../../../domain/entities/service_dropdown_entity.dart';
import '../../../../domain/entities/service_order_entity.dart';
import '../../../../domain/entities/service_order_file.dart';
import '../../../../domain/entities/shop_inventory_entity.dart';
import '../../../../domain/entities/technician_entity.dart';
import '../../../../domain/usecases/get_all_technicians.dart';
import '../../../../domain/usecases/get_carrier_vehicles.dart';
import '../../../../domain/usecases/get_customer_details.dart';
import '../../../../domain/usecases/get_service_dropdown.dart';
import '../../../../domain/usecases/create_edit_service_order.dart';
import '../../../shop_inventories/controllers/shop_inventories_controller.dart';
import '../../service_order_details/controllers/service_order_details_controller.dart';
import '../../service_orders/controllers/service_orders_controller.dart';

class CreateEditServiceOrderController extends GetxController
    with OrderUpdateMixin {
  // usecase
  final getServiceDropdownUsecase = sl<GetServiceDropdownUsecase>();
  final createOrEditServiceOrderUsecase = sl<CreateOrEditServiceOrderUsecase>();
  final getCustomerDetailsUsecase = sl<GetCustomerDetailsUsecase>();
  final getAllTechniciansUsecase = sl<GetAllTechniciansUsecase>();
  final getCarrierVehiclesUsecase = sl<GetCarrierVehiclesUsecase>();

  // leading and variables
  final technicians = RxList<TechnicianEntity>();
  final serviceOrderEntity = Rxn<ServiceOrderEntity>();
  final customerDetails = Rxn<CustomerEntity>();
  final serviceDropdown = Rxn<ServiceDropdownEntity>();
  final refreshController = RefreshController();
  final formKey = GlobalKey<FormState>();
  final serviceDetailsKey = GlobalKey<AnimatedListState>();
  final isLoading = false.obs;
  final isUnitLoading = false.obs;
  final isCustomerDetailsLoading = false.obs;
  final isUpdating = false.obs;
  final isSubmitting = false.obs;

  final isEditEnabled = true.obs;

  // file helper
  final fileExtensionHelper = FileExtensionHelper();

  // add getter showCustomerDetails
  bool get showCustomerDetails =>
      selectedCategory.value != null &&
      selectedModelType.value != null &&
      selectedUnit.value != null;
  // dropdown data lists
  RxList<ItemEntity> dropdownTrailers = RxList();

  RxList<ShopInventoryEntity> dropdownInventory = RxList();

  final selectedTechnicians = RxList<TechnicianEntity>();
  final unitList = RxList<ItemEntity>();
  final selectedCategory = Rxn<String>(null);
  final selectedClient = Rxn<ClientsItemEntity>(null);
  final selectedModelType = Rxn<String>(null);
  final selectedUnit = Rxn<ItemEntity>(null);

  // Text Controllers for  input fields
  final dateController = TextEditingController();
  final completionDateController = TextEditingController();
  final orderNumberController = TextEditingController();
  final htmlController = QuillController.basic();

  // service details
  final serviceDetails = <ServiceDetails>[].obs;

  bool _validateBasicInfo() {
    if (dateController.text.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a order date'.tr,
      );
      return false;
    }

    if (selectedCategory.value == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a category'.tr,
      );
      return false;
    }

    if (selectedModelType.value?.isEmpty ?? true) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a model type'.tr,
      );
      return false;
    }

    if (selectedUnit.value == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a unit'.tr,
      );
      return false;
    }

    if (selectedTechnicians.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select at least one technician'.tr,
      );
      return false;
    }

    return true;
  }

  bool _validateServiceDetail(ServiceDetails detail, int index) {
    final maintenanceType = detail.selectedMaintenanceType?.value?.name;
    if (maintenanceType == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a maintenance type for service ${index + 1}'.tr,
      );
      return false;
    }

    final serviceType = detail.selectedServiceType?.value;
    if (serviceType == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a service type for service ${index + 1}'.tr,
      );
      return false;
    }

    final serviceChargesType = detail.selectedChargesType?.value;
    if (serviceChargesType == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message:
            'Please select a service charges type for service ${index + 1}'.tr,
      );
      return false;
    }

    if (serviceChargesType.toLowerCase() == "hour" &&
        (detail.hoursController.text.isEmpty ||
            detail.hoursController.text == '0')) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please enter hours for service ${index + 1}'.tr,
      );
      return false;
    }

    final partsRequired = detail.isPartRequired.value?.toLowerCase();
    if (partsRequired == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message:
            'Please select if parts are required for service ${index + 1}'.tr,
      );
      return false;
    }

    if (partsRequired == 'yes' &&
        detail.vehiclePartFields
            .any((part) => part.selectedInventory.value.id == null)) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select an inventory item for service ${index + 1}'.tr,
      );
      return false;
    }

    return true;
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;
    if (!_validateBasicInfo()) return false;

    for (var i = 0; i < serviceDetails.length; i++) {
      if (!_validateServiceDetail(serviceDetails[i], i)) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint('CreateEditServiceOrderController onInit');
    if (Get.arguments == null) {
      addServiceDetailsField();
    }
    if (Get.arguments != null) {
      isUpdating.value = true;
    }

    await Future.wait([
      getServiceDropdown(),
      loadingShopInventories(),
    ]);

    getAllTechnicians();

    final serviceOrder = Get.arguments;
    if (Get.arguments != null && serviceOrder is ServiceOrderEntity) {
      serviceOrderEntity.value = serviceOrder;
      _setTextControllers(serviceOrder);
    }
  }

  Future<void> _setTextControllers(ServiceOrderEntity serviceOrder) async {
    orderNumberController.text = serviceOrder.serviceOrderNumber ?? "";
    isEditEnabled.value = serviceOrder.isEnabled();
    dateController.text =
        DateFormat('yyyy-MM-dd').format(serviceOrder.maintenanceDate!);
    if (serviceOrder.completionDate != null) {
      completionDateController.text =
          DateFormat('yyyy-MM-dd').format(serviceOrder.completionDate!);
    }
    selectedCategory.value = serviceOrder.category;

    selectedClient.value = getClientlist().firstWhereOrNull(
      (element) =>
          element.id.toString() == serviceOrder.customer?.client?.id.toString(),
    );

    selectedModelType.value = serviceOrder.modelType;

    await getUnitlist();

    selectedUnit.value = unitList.firstWhereOrNull(
      (element) => element.id.toString() == serviceOrder.modelId.toString(),
    );

    try {
      final html = HtmlToDelta().convert(serviceOrder.customerComplaint ?? '');
      htmlController.document = Document.fromDelta(html);
      FocusScope.of(Get.overlayContext!).unfocus();
    } catch (_) {}

    // Fill the Service Details
    serviceDetails.clear();
    if (serviceOrder.serviceDetails?.isNotEmpty ?? false) {
      for (var detail in serviceOrder.serviceDetails!) {
        final newServiceDetail = ServiceDetails(
          id: Rxn<String>(detail.id?.toString()),
          selectedMaintenanceType: Rxn<ServiceTypeEntity>(),
          selectedServiceType: Rxn<DataEntity>(),
          selectedChargesType: Rxn<String>(),
        );

        // Assign is enabled
        newServiceDetail.isEnabled.value = detail.isPending();

        // Assign Maintenance Type
        newServiceDetail.selectedMaintenanceType?.value =
            serviceDropdown.value?.serviceType?.firstWhereOrNull(
          (element) => element.code == detail.maintenanceType,
        );

        // Assign Service Type
        newServiceDetail.selectedServiceType?.value = newServiceDetail
            .selectedMaintenanceType?.value?.data
            ?.firstWhereOrNull((element) => element.code == detail.serviceType);

        // Assign Service Charges Type
        newServiceDetail.selectedChargesType?.value = detail.serviceChargesType;

        // Assign Numeric Fields
        newServiceDetail.hoursController.text = detail.hours?.toString() ?? "0";
        newServiceDetail.rateController.text = detail.rate?.toString() ?? "0";
        newServiceDetail.taxController.text = detail.tax?.toString() ?? "0";
        newServiceDetail.mileageController.text =
            detail.mileage?.toString() ?? "0";

        // Assign parts required
        newServiceDetail.isPartRequired.value = detail.partsRequired;

        //  Assign Vehicle Parts
        if (detail.vehicleParts?.isNotEmpty ?? false) {
          newServiceDetail.vehiclePartFields.clear();

          for (var part in detail.vehicleParts!) {
            final ShopInventoryEntity? inventory =
                dropdownInventory.firstWhereOrNull(
              (element) =>
                  element.id.toString().trim() ==
                  part.shopInventoryId.toString().trim(),
            );

            if (inventory == null) {
              debugPrint('Inventory not found for ID: ${part.shopInventoryId}');
              continue;
            }

            var vehiclePart = VehiclePart(
              id: Rxn<String>(part.id?.toString()),
              selectedInventory: inventory,
              initialPartsRequired: part.numberOfPartsRequired ?? 0,
              partsPrice: num.tryParse(part.partPrice.toString()) ?? 0,
            );

            vehiclePart.updatePartsToBePurchased();
            newServiceDetail.vehiclePartFields.add(vehiclePart);
          }
        }

        //Assign Files Before Service
        newServiceDetail.filesBeforService.clear();
        newServiceDetail.filesBeforService.addAll(
          detail.files?.map((file) => ServiceOrderFile(
                    isAdd: false,
                    file: null,
                    onlineFile: file,
                  )) ??
              [],
        );
        newServiceDetail.filesBeforService.add(ServiceOrderFile(isAdd: true));

        // Assign Files After Service
        newServiceDetail.filesAfterService.clear();
        newServiceDetail.filesAfterService.addAll(
          detail.filesAfterService?.map((file) => ServiceOrderFile(
                    isAdd: false,
                    file: null,
                    onlineFile: file,
                  )) ??
              [],
        );
        newServiceDetail.filesAfterService.add(ServiceOrderFile(isAdd: true));

        // Add new service detail to the list
        serviceDetails.add(newServiceDetail);
        serviceDetailsKey.currentState?.insertItem(
          0,
          duration: const Duration(milliseconds: 500),
        );
        serviceDetails.refresh();
      }
    }
  }

  Future<void> getServiceDropdown() async {
    selectedCategory.value = null;
    selectedModelType.value = null;
    selectedUnit.value = null;
    try {
      isLoading(true);
      final response = await getServiceDropdownUsecase(const NoParams());
      response.fold((ServiceDropdownEntity response) {
        serviceDropdown.value = response;
        dropdownTrailers.value = response.trailers ?? [];
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
    } finally {
      isLoading(false);
    }
  }

  Future<List<ItemEntity>> getCarrierVehicles() async {
    selectedUnit.value = null;
    try {
      isUnitLoading.value = true;
      final body = {
        'category': selectedCategory.value, // only company
        'client': selectedClient.value?.id,
      };
      final response = await getCarrierVehiclesUsecase(body);
      return response.fold(
        (data) => data,
        (failure) {
          Get.snackbar('Error', failure.message);
          return [];
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    } finally {
      isUnitLoading.value = false;
    }
  }

  Future<void> submitServiceOrder() async {
    // Validate the form
    if (!_validateForm()) return;

    try {
      //
      final dio.FormData? data = await _getServiceFormData();
      if (data == null) {
        return;
      }
      debugPrint('Submitting data: ${data.toString()}');
      isSubmitting(true);
      final response = await createOrEditServiceOrderUsecase.call(data);
      response.fold((result) async {
        // update the service order list
        if (isUpdating.value) {
          await updateOrderDetails();
        } else {
          await Get.find<ServiceOrdersController>().getAllServiceOrders();
        }

        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: isUpdating.value
              ? 'Service Order Updated Successfully'.tr
              : 'Service Order Created Successfully'.tr,
          isError: false,
        );
        Navigator.pop(Get.context!);
      }, (failure) {
        //
        CommonWidgets.showSnackBar(
          title: ''.tr,
          message: failure.message,
        );
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> updateOrderDetails() async {
    final detailsController = Get.isRegistered<ServiceOrderDetailsController>()
        ? Get.find<ServiceOrderDetailsController>()
        : Get.put(ServiceOrderDetailsController());

    final serviceOrderId = serviceOrderEntity.value!.id.toString();
    final updatedOrder = await detailsController.getServiceOrderDetails(
      id: serviceOrderId,
    );

    if (updatedOrder != null) {
      syncServiceOrder(
        id: serviceOrderEntity.value!.id.toString(),
        updatedOrder: updatedOrder,
      );

      detailsController.serviceOrder.value = updatedOrder;
      detailsController.serviceOrder.refresh();
    }
  }

  // prepare form data
  Future<dio.FormData?> _getServiceFormData() async {
    // Prepare basic form data
    final Map<String, dynamic> dataMap = {
      if (serviceOrderEntity.value != null) 'id': serviceOrderEntity.value!.id,
      'maintenance_date': dateController.text,
      'completion_date': completionDateController.text,
      'category': selectedCategory.value!.toLowerCase(),
      'customer_complaint':
          DeltaToHTML.encodeJson(htmlController.document.toDelta().toJson()),
      'model_id': selectedUnit.value!.id,
      'model_type': selectedModelType.value!.toLowerCase(),
      'carrier_id': selectedClient.value?.id,
      'technicians': selectedTechnicians.map((item) => item.id).join(","),
    };

    // Add service details
    if (serviceDetails.isNotEmpty) {
      for (var i = 0; i < serviceDetails.length; i++) {
        final detail = serviceDetails[i];
        final serviceDetailsEntry = 'serviceDetails[$i]';

        debugPrint('serviceDetails id : ${detail.id?.value}');

        // Add basic service detail info
        dataMap.addAll({
          '$serviceDetailsEntry[id]': detail.id?.value,
          '$serviceDetailsEntry[maintenance_type]':
              detail.selectedMaintenanceType?.value?.code,
          '$serviceDetailsEntry[service_type]':
              detail.selectedServiceType?.value?.code,
          '$serviceDetailsEntry[service_charges_type]':
              detail.selectedChargesType?.value,
          '$serviceDetailsEntry[rate]': detail.rateController.text,
          '$serviceDetailsEntry[tax]': detail.taxController.text,
          '$serviceDetailsEntry[hours]': detail.hoursController.text,
          '$serviceDetailsEntry[mileage]': detail.mileageController.text,
          '$serviceDetailsEntry[parts_required]':
              detail.isPartRequired.value?.toLowerCase() == 'yes' ? 1 : 0,
        });

        // Add vehicle parts if required
        if (detail.isPartRequired.value?.toLowerCase() == 'yes') {
          for (var j = 0; j < detail.vehiclePartFields.length; j++) {
            final part = detail.vehiclePartFields[j];
            final partsEntry = '$serviceDetailsEntry[vehicleParts][$j]';

            dataMap.addAll({
              '$partsEntry[id]': part.id?.value,
              '$partsEntry[shop_inventory_id]': part.selectedInventory.value.id,
              '$partsEntry[number_of_parts_available]':
                  part.selectedInventory.value.quantity,
              '$partsEntry[number_of_parts_required]':
                  part.numPartsRequired.value,
              '$partsEntry[parts_to_be_purchased]':
                  part.partsToBePurchased.value,
              '$partsEntry[part_price]': part.price.value,
              '$partsEntry[total_price]': part.totalPrice.value,
            });
          }
        }

        // add the files
        _addFilesToDataMap(
          serviceDetailsEntry,
          detail.filesBeforService,
          'files',
          dataMap,
        );
        _addFilesToDataMap(
          serviceDetailsEntry,
          detail.filesAfterService,
          'filesAfterService',
          dataMap,
        );

        // add the deleted files
        if (detail.filesBeforServiceToBeDeleted.isNotEmpty) {
          _addDeletedFilesToDataMap(
            serviceDetailsEntry,
            detail.filesBeforServiceToBeDeleted,
            'filesToBeDeleted',
            dataMap,
          );
        }

        if (detail.filesAfterServiceToBeDeleted.isNotEmpty) {
          _addDeletedFilesToDataMap(
            serviceDetailsEntry,
            detail.filesAfterServiceToBeDeleted,
            'filesAfterServiceToBeDeleted',
            dataMap,
          );
        }
      }
    }

    return dio.FormData.fromMap(dataMap);
  }

  void _addFilesToDataMap(
    String serviceDetailsEntry,
    List<ServiceOrderFile> files,
    String key,
    Map<String, dynamic> dataMap,
  ) {
    files
        .where((item) => (!item.isAdd) && (item.file != null))
        .map<File>((item) => item.file!)
        .toList()
        .asMap()
        .forEach((index, file) {
      final multipartFile = dio.MultipartFile.fromFileSync(
        file.path,
        filename: getFileNameWithExtenshion(file.path),
      );
      dataMap['$serviceDetailsEntry[$key][$index]'] = multipartFile;
    });
  }

  void _addDeletedFilesToDataMap(String serviceDetailsEntry,
      List<int> filesToBeDeleted, String key, Map<String, dynamic> dataMap) {
    filesToBeDeleted.asMap().forEach((index, fileId) {
      dataMap['$serviceDetailsEntry[$key][$index]'] = fileId;
    });
  }

  Future<void> handleRefresh() async {
    getAllTechnicians();
    await getServiceDropdown();
    loadingShopInventories();
    refreshController.refreshCompleted();
  }

  Future<void> loadingShopInventories() async {
    dropdownInventory.value =
        await Get.put(ShopInventoriesController()).getAllShopInventories();
  }

  Future<void> getAllTechnicians() async {
    technicians.clear();
    try {
      final response = await getAllTechniciansUsecase.call(const NoParams());
      response.fold((response) {
        technicians.value = response;
        if (technicians.isNotEmpty &&
            (serviceOrderEntity.value?.technicians ?? []).isNotEmpty) {
          selectedTechnicians.clear();

          final oldTechs = serviceOrderEntity.value!.technicians!;

          final techsToAdd = technicians.where((item) {
            if (item.id == null) {
              return false;
            }
            return oldTechs.firstWhereOrNull(
                    (item2) => (item2.id != null) && (item2.id == item.id)) !=
                null;
          });

          selectedTechnicians.addAll(techsToAdd);
        }
      }, (_) {
        //
      });
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<CustomerEntity> getCustomerDetails() async {
    try {
      isCustomerDetailsLoading.value = true;
      final body = {
        'category': selectedCategory.value,
        'model_type': selectedModelType.value,
        'model_id': selectedUnit.value?.id,
        'client': selectedClient.value?.id,
      };
      debugPrint('body: $body');
      final response = await getCustomerDetailsUsecase(body);
      response.fold((response) {
        customerDetails.value = response;
      }, (failure) {
        Get.snackbar('Error', failure.message);
      });
    } catch (e) {
      debugPrint('Error $e');
    } finally {
      isCustomerDetailsLoading.value = false;
    }
    return customerDetails.value!;
  }

  Future<void> getUnitlist() async {
    final modelType = selectedModelType.value?.toLowerCase();
    final categoryName = selectedCategory.value?.toLowerCase();

    // Validate selected values
    if (modelType == null || categoryName == null) {
      unitList.value = [];
      return;
    }

    switch (categoryName) {
      case "company":
        await handleCompanyCategory(modelType);
        break;
      case "client":
        handleClientCategory(modelType);
        break;
      default:
        unitList.value = [];
    }

    return;
  }

  Future<void> handleCompanyCategory(String modelType) async {
    switch (modelType) {
      case "truck":
        unitList.value = await getCarrierVehicles();
        break;
      case "trailer":
        unitList.value = dropdownTrailers;
        break;
      default:
        unitList.value = [];
    }
  }

  void handleClientCategory(String modelType) {
    switch (modelType) {
      case "truck":
        unitList.value = selectedClient.value?.trucks ?? [];
        break;
      case "trailer":
        unitList.value = selectedClient.value?.trailers ?? [];
        break;
      default:
        unitList.value = [];
    }
  }

  List<ClientsItemEntity> getClientlist() {
    if (selectedCategory.value == null) {
      return [];
    }

    // Get the category name in lowercase for comparison
    final categoryName = selectedCategory.value?.toLowerCase();

    // Return the appropriate client list based on the category name
    if (categoryName == 'company') {
      return serviceDropdown.value?.clients?.companyClients ?? [];
    }

    if (categoryName == 'client') {
      return serviceDropdown.value?.clients?.shopClients ?? [];
    }

    return [];
  }

  void addServiceDetailsField() {
    serviceDetails.insert(
      0,
      ServiceDetails(
        id: Rxn<String>(null),
        selectedMaintenanceType: Rxn<ServiceTypeEntity>(),
        selectedServiceType: Rxn<DataEntity>(),
        selectedChargesType: Rxn<String>(),
      ),
    );
  }

  void removeServiceDetailsField(int index) {
    serviceDetails.removeAt(index);
    serviceDetails.refresh();
  }

  void showBeforServiceAttachmentBottomSheet(
    ThemeData theme,
    List<ServiceOrderFile> filesBeforService,
  ) {
    MediaPicker.showAttachmentBottomSheet(
      onGalleryPicked: (files) {
        if (files.isEmpty) {
          return;
        }
        if (filesBeforService.isNotEmpty) {
          filesBeforService.removeLast();
        }
        filesBeforService.addAll(
          files.map(
            (item) => ServiceOrderFile(isAdd: false, file: item),
          ),
        );
        filesBeforService.add(ServiceOrderFile(isAdd: true, file: File("")));
      },
      onDocumentPicked: (files) {
        if (files.isEmpty) {
          return;
        }
        if (filesBeforService.isNotEmpty) {
          filesBeforService.removeLast();
        }
        filesBeforService.addAll(
          files.map(
            (item) => ServiceOrderFile(isAdd: false, file: item),
          ),
        );
        filesBeforService.add(ServiceOrderFile(isAdd: true, file: File("")));
      },
      onCameraPicked: (file) {
        if (file != null) {
          if (filesBeforService.isNotEmpty) {
            filesBeforService.removeLast();
          }
          filesBeforService.add(ServiceOrderFile(isAdd: false, file: file));
          filesBeforService.add(ServiceOrderFile(isAdd: true, file: File("")));
        }
      },
    );
  }

  void showAfterServiceAttachmentBottomSheet(
    ThemeData theme,
    List<ServiceOrderFile> filesAfterService,
  ) {
    MediaPicker.showAttachmentBottomSheet(
      onGalleryPicked: (files) {
        if (files.isEmpty) {
          return;
        }
        if (filesAfterService.isNotEmpty) {
          filesAfterService.removeLast();
        }
        filesAfterService.addAll(
          files.map(
            (item) => ServiceOrderFile(isAdd: false, file: item),
          ),
        );
        filesAfterService.add(ServiceOrderFile(isAdd: true, file: File("")));
      },
      onDocumentPicked: (files) {
        if (files.isEmpty) {
          return;
        }
        if (filesAfterService.isNotEmpty) {
          filesAfterService.removeLast();
        }
        filesAfterService.addAll(
          files.map(
            (item) => ServiceOrderFile(isAdd: false, file: item),
          ),
        );
        filesAfterService.add(ServiceOrderFile(isAdd: true, file: File("")));
      },
      onCameraPicked: (file) {
        if (file != null) {
          if (filesAfterService.isNotEmpty) {
            filesAfterService.removeLast();
          }
          filesAfterService.add(ServiceOrderFile(isAdd: false, file: file));
          filesAfterService.add(ServiceOrderFile(isAdd: true, file: File("")));
        }
      },
    );
  }

  @override
  void dispose() {
    try {
      dateController.dispose();
      completionDateController.dispose();
      orderNumberController.dispose();
      htmlController.dispose();
      refreshController.dispose();
    } catch (e) {
      debugPrint('Error during controller disposal: $e');
    } finally {
      super.dispose();
    }
  }
}
