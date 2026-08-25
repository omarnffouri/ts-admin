import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/mixins/order_update_mixin.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/services/injection_service.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../domain/entities/service_order_entity.dart';
import '../../../../domain/entities/service_order_file.dart';
import '../../../../domain/usecases/change_service_order_status.dart';
import '../../../../domain/usecases/complete_service_order.dart';
import '../../../../domain/usecases/get_service_order_details.dart';

class ServiceOrderDetailsController extends GetxController
    with OrderUpdateMixin {
  // Use cases
  final getServiceOrderDetailsUsecase = sl<GetServiceOrderDetailsUsecase>();
  final changeServiceOrderStatusUsecase = sl<ChangeServiceOrderStatusUsecase>();
  final completeServiceOrderUsecase = sl<CompleteServiceOrderUsecase>();

  // variables and State Management
  final RefreshController refreshController = RefreshController();
  final completionDateController = TextEditingController();
  final Rxn<ServiceOrderEntity> serviceOrder = Rxn<ServiceOrderEntity>();
  final formKey = GlobalKey<FormState>();
  final orderId = ''.obs;
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final statusToChange = ''.obs;
  final showUpdateButton = false.obs;
  final enableEndDate = true.obs;
  final enableTotalAmountToDeduct = true.obs;
  final selectedCategory = Rxn<String>(null);
  final selectedFrequency = Rxn<String>(null);

  final fileExtensionHelper = FileExtensionHelper();

  // text controllers
  final completionParams = <CompleteServiceParams>[].obs;
  final TextEditingController descController = TextEditingController();
  final TextEditingController freqStartDateController = TextEditingController();
  final TextEditingController freqEndDateController = TextEditingController();
  final TextEditingController deductionAmountController =
      TextEditingController();
  final TextEditingController maxOneTimeAmountController =
      TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    debugPrint('ShopOrderDetailsController onInit');
    final order = Get.arguments;
    if (order != null && order is ServiceOrderEntity) {
      orderId.value = order.id.toString();
      init();

      // set listener for enableEndDate
      freqEndDateController.addListener(() {
        if (freqEndDateController.text.isNotEmpty) {
          enableTotalAmountToDeduct.value = false;
        } else {
          enableTotalAmountToDeduct.value = true;
        }
      });

      // set listener for enableTotalAmountToDeduct
      totalAmountController.addListener(() {
        if (totalAmountController.text.isNotEmpty) {
          enableEndDate.value = false;
        } else {
          enableEndDate.value = true;
        }
      });
    }
  }

  Future<void> init() async {
    serviceOrder.value =
        await getServiceOrderDetails(id: orderId.value.toString());
    showUpdateButton.value =
        serviceOrder.value?.status == 'pending_confirmation' ||
            serviceOrder.value?.status == 'shop_pending' ||
            serviceOrder.value?.status == 'shop_in_process';

    statusToChange.value = _getNextStatus(serviceOrder.value?.status);

    if (serviceOrder.value?.completionDate != null) {
      completionDateController.text = DateFormat('yyyy-MM-dd').format(
        serviceOrder.value!.completionDate!,
      );
    }

    syncServiceOrder(
      id: serviceOrder.value!.id.toString(),
      updatedOrder: serviceOrder.value!,
    );

    _setTextControllers(serviceOrder.value!);
  }

  Future<void> _setTextControllers(ServiceOrderEntity serviceOrder) async {
    completionParams.clear();
    if (serviceOrder.serviceDetails?.isNotEmpty ?? false) {
      for (var detail in serviceOrder.serviceDetails!) {
        final newServiceDetail =
            CompleteServiceParams(id: Rxn<String>(detail.id.toString()));

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
        completionParams.add(newServiceDetail);
        completionParams.refresh();
      }
    }
  }

  Future<void> handleRefresh() async {
    await init();
    refreshController.refreshCompleted();
  }

  Future<ServiceOrderEntity?> getServiceOrderDetails({
    required String id,
  }) async {
    try {
      final body = {'id': id};
      isLoading.value = true;
      final response = await getServiceOrderDetailsUsecase(body);
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

  Future<void> changeServiceStatus() async {
    if (serviceOrder.value == null) return;

    try {
      final body = {
        'id': serviceOrder.value?.id.toString(),
        'status': statusToChange.value,
      };
      isUpdating.value = true;
      final response = await changeServiceOrderStatusUsecase.call(body);
      response.fold((result) async {
        // refresh the order details and update the order in the list
        await init();
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: 'Service Order Updated Successfully'.tr,
          isError: false,
        );
      }, (failure) {
        CommonWidgets.showSnackBar(title: ''.tr, message: failure.message);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> completeServiceOrder() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      //
      final dio.FormData? data = await _getServiceFormData();
      if (data == null) {
        return;
      }
      debugPrint('data: ${data.toString()}');

      isUpdating.value = true;
      final response = await completeServiceOrderUsecase.call(data);
      response.fold((result) async {
        // refresh the order details and update the order in the list
        await init();
        // close the bottom sheet
        Navigator.of(Get.context!).pop();
        CommonWidgets.showSnackBar(
          title: 'Success'.tr,
          message: 'Service Order Completed Successfully'.tr,
          isError: false,
        );

        clearTextControllers();
      }, (failure) {
        //
        CommonWidgets.showSnackBar(title: ''.tr, message: failure.message);
      });
    } catch (e) {
      CommonWidgets.showSnackBar(title: 'Error'.tr, message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  String _getNextStatus(String? status) {
    if (status == null) return '';
    return switch (status) {
      'pending_confirmation' => 'shop_pending',
      'shop_pending' => 'shop_in_process',
      _ => '',
    };
  }

  Future<dio.FormData?> _getServiceFormData() async {
    final completionDate = completionDateController.text;
    if (completionDate.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a completion date'.tr,
      );
      return null;
    }

    if (selectedCategory.value == null) {
      CommonWidgets.showSnackBar(
        title: 'Required'.tr,
        message: 'Please select a payment method'.tr,
      );
      return null;
    }

    // from data map
    Map<String, dynamic> dataMap = {};
    if (serviceOrder.value != null) {
      dataMap['id'] = serviceOrder.value?.id;
    }

    if (completionParams.isNotEmpty) {
      for (var i = 0; i < completionParams.length; i++) {
        final detail = completionParams[i];
        final serviceDetailsEntry = 'serviceDetails[$i]';

        debugPrint('serviceDetails id : ${detail.id?.value}');

        // Add basic service detail info
        dataMap.addAll({'$serviceDetailsEntry[id]': detail.id?.value});

        _addFilesToDataMap(
          serviceDetailsEntry,
          detail.filesAfterService,
          'filesAfterService',
          dataMap,
        );

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

    dataMap['completion_date'] = completionDate;
    dataMap['payment_method'] = formatPaymentMethod(selectedCategory.value!);

    if (selectedCategory.value?.toLowerCase() == 'payroll') {
      if (freqStartDateController.text.isEmpty) {
        CommonWidgets.showSnackBar(
          title: 'Required'.tr,
          message: 'Please select a start date'.tr,
        );
        return null;
      }
      final deductionForm = {
        'start': freqStartDateController.text,
        'end': freqEndDateController.text,
        'frequency': formatFrequency(selectedFrequency.value!),
        'description': descController.text,
        'deduct_amount': deductionAmountController.text, //! review this
        'max_one_time_amount': maxOneTimeAmountController.text,
        'total_amount_to_deduct': totalAmountController.text, //! review this
      };

      dataMap['deductionForm'] = deductionForm;
    }

    return dio.FormData.fromMap(dataMap);
  }

  String formatPaymentMethod(String payment) {
    switch (payment) {
      case 'Bank Transfer':
        return 'bank_transfer';
      case 'Payroll':
        return 'payroll';
      default:
        return '';
    }
  }

  String formatFrequency(String frequency) {
    switch (frequency) {
      case 'One Time':
        return 'one_time';
      case 'Weekly':
        return 'weekly';
      case 'Monthly':
        return 'monthy';
      case 'Every Set':
        return 'eveset';
      default:
        return '';
    }
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

  void clearTextControllers() {
    completionDateController.clear();
    selectedCategory.value = null;
    selectedFrequency.value = null;
    freqStartDateController.clear();
    freqEndDateController.clear();
    descController.clear();
    deductionAmountController.clear();
    maxOneTimeAmountController.clear();
    totalAmountController.clear();
  }

  void disposeTextControllers() {
    totalAmountController.dispose();
    maxOneTimeAmountController.dispose();
    deductionAmountController.dispose();
    descController.dispose();
    freqEndDateController.dispose();
    freqStartDateController.dispose();
    completionDateController.dispose();
    refreshController.dispose();
  }

  @override
  void onClose() {
    disposeTextControllers();
    super.onClose();
    debugPrint('ShopOrderDetailsController onClose');
  }
}

class CompleteServiceParams {
  Rxn<String>? id;
  CompleteServiceParams({
    this.id,
  });

  // file after service
  final RxList<ServiceOrderFile> filesAfterService = RxList(
    [ServiceOrderFile(isAdd: true)],
  );

  // service order files to be removed
  final RxList<int> filesAfterServiceToBeDeleted = RxList();
}
