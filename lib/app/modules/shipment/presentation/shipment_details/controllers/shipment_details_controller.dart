import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_entity.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/enitities/shipment_details_entity.dart';
import '../../../domain/usecases/get_shipment_details.dart';

class ShipmentDetailsController extends GetxController {
  // body refresh controllers
  RefreshController refreshController = RefreshController();

  // usecases
  final getShipmentDetailsUsecase = sl<GetShipmentDetailsUsecase>();

  // variables
  final Rxn<ShipmentDetails> _shipmentDetails = Rxn(const ShipmentDetails());
  ShipmentDetails? get shipmentDetails => _shipmentDetails.value;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  final shipmentId = 0.obs;
  final title = ''.obs;
  final shipmentStatus = ''.obs;
  final trailerId = ''.obs;
  final dispatchType = RxnString();

  @override
  void onInit() {
    super.onInit();
    debugPrint('ShipmentDetailsController: onInit');

    if (Get.arguments != null) {
      final shipment = Get.arguments as ShipmentEntity;
      shipmentId.value = shipment.id ?? 0;
      title.value = shipment.shipmentNumber ?? '';
      shipmentStatus.value = shipment.status ?? '';
      trailerId.value = shipment.trailerId ?? '';
      dispatchType.value = shipment.type;
      debugPrint(shipmentId.value.toString());
      if (shipmentId.value != 0) {
        getShipmentDetails();
      }
    }
  }

  Future<void> getShipmentDetails() async {
    try {
      isLoading(true);
      errorMessage.value = null;
      final response = await getShipmentDetailsUsecase.call(shipmentId.value);
      response.fold((response) {
        _shipmentDetails.value = response.data!;
        // Entry points that only know the id (e.g. the additional-pay card)
        // arrive with an empty title.
        if (title.value.isEmpty) {
          title.value = response.data?.shipmentNumber ?? '';
        }
      }, (failure) {
        _reportLoadError(failure.message.isNotEmpty
            ? failure.message
            : 'Unable to load shipment details.');
      });
      isLoading(false);
    } catch (e) {
      debugPrint('Error $e');
      _reportLoadError('Unable to load shipment details.');
      isLoading(false);
    }
  }

  /// Failed refresh keeps loaded details on screen — snackbar instead.
  void _reportLoadError(String message) {
    if (_shipmentDetails.value?.shipment != null) {
      CommonWidgets.showSnackBar(
          title: 'Error', message: message, isError: true);
    } else {
      errorMessage.value = message;
    }
  }

  handleShipmentRefresh() async {
    await getShipmentDetails();
    refreshController.refreshCompleted();
  }
}
