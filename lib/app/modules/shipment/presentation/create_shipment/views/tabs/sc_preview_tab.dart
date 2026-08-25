import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/controllers/create_shipment_controller.dart';

class SCPreviewTab extends GetView<CreateShipmentController> {
  const SCPreviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    // theme
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        //
        //
        // map view
        SizedBox(
          height: Get.height * 0.65,
          child: Obx(
            () => GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (googleMapController) {
                controller.previewMapControllerCreated(googleMapController);
              },
              markers: (controller.selectedPickupLocation.value != null) &&
                      (controller.selectedPickupLocation.value != null)
                  ? {
                      Marker(
                        markerId: const MarkerId("shipment_pickup_location"),
                        infoWindow: InfoWindow(
                            title: controller
                                .selectedPickupLocation.value!.address,
                            snippet: "Pickup Location"),
                        position: LatLng(
                          double.parse(controller
                                  .selectedPickupLocation.value!.latitude ??
                              "0.0"),
                          double.parse(controller
                                  .selectedPickupLocation.value!.longitude ??
                              "0.0"),
                        ),
                      ),
                      Marker(
                        markerId: const MarkerId("shipment_delivery_location"),
                        infoWindow: InfoWindow(
                            title: controller
                                .selectedDeliveryLocation.value!.address,
                            snippet: "Delivery Location"),
                        position: LatLng(
                          double.parse(controller
                                  .selectedDeliveryLocation.value!.latitude ??
                              "0.0"),
                          double.parse(controller
                                  .selectedDeliveryLocation.value!.longitude ??
                              "0.0"),
                        ),
                      ),
                    }
                  : {},
              polylines: controller.polylines.toSet(),
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.725870, 46.664764),
                zoom: 13,
              ),
            ),
          ),
        ),

        DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.30,
          maxChildSize: 0.80,
          snap: true,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color:
                    Get.isDarkMode ? AppColorsDark.mainColorDark : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    offset: const Offset(0, 5),
                    spreadRadius: 5,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  //
                  //
                  // scroll top bar indicator
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 8,
                    width: Get.width * .33,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Colors.grey.shade500
                          : Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        // Remove overscroll effect
                        overscroll.disallowIndicator();
                        return false;
                      },
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "General",
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppColorsLight.mainColor,
                              ),
                            ).marginOnly(top: 10),
                            const Divider(),

                            //
                            //
                            // customer details
                            _buildDetailRow(
                              "Customer",
                              controller.selectedCustomer.value?.name ?? "",
                            ).marginOnly(top: 10),

                            if (controller
                                .customerReferenceController.text.isNotEmpty)
                              _buildDetailRow(
                                "Customer Reference",
                                controller.customerReferenceController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // driver details
                            Obx(
                              () => Visibility(
                                visible:
                                    controller.selectedDriver.value != null,
                                child: _buildDetailRow(
                                  "Driver",
                                  controller.selectedDriver.value?.name ?? "",
                                ).marginOnly(top: 5),
                              ),
                            ),

                            //
                            //
                            // truck details
                            Obx(
                              () => Visibility(
                                visible: controller.selectedTruck.value != null,
                                child: _buildDetailRow(
                                  "Truck",
                                  controller.selectedTruck.value?.name ?? "",
                                ).marginOnly(top: 5),
                              ),
                            ),

                            //
                            //
                            // trailer details

                            Obx(
                              () => Visibility(
                                visible:
                                    (controller.selectedTrailerType.value ?? "")
                                        .isNotEmpty,
                                child: _buildDetailRow(
                                  "Trailer Type",
                                  controller.selectedTrailerType.value ?? "",
                                ).marginOnly(top: 5),
                              ),
                            ),

                            //
                            //
                            // trailer details
                            Obx(
                              () => Visibility(
                                  visible: ((controller
                                                  .selectedTrailerType.value ==
                                              TrailerTypes.trailer) &&
                                          (controller.selectedTrailer.value !=
                                              null)) ||
                                      ((controller.selectedTrailerType.value ==
                                              TrailerTypes.thirdPartyTrailer) &&
                                          (controller
                                              .trailerIndetifierController
                                              .text
                                              .isNotEmpty)),
                                  child: _buildDetailRow(
                                    "Trailer",
                                    controller.selectedTrailerType.value ==
                                            TrailerTypes.trailer
                                        ? (controller.selectedTrailer.value
                                                    ?.identifier ??
                                                0)
                                            .toString()
                                        : controller
                                            .trailerIndetifierController.text,
                                  ).marginOnly(top: 5)),
                            ),

                            //
                            //
                            // contracted amount details
                            _buildDetailRow(
                              "Contracted Amount",
                              "\$${controller.contractedAmountController.text}",
                            ).marginOnly(top: 5),

                            //
                            //
                            // estimated distance
                            Obx(
                              () => Visibility(
                                visible:
                                    controller.estimatedDistance.isNotEmpty,
                                child: _buildDetailRow(
                                  "Estimated Distance",
                                  controller.estimatedDistance.value,
                                ),
                              ),
                            ).marginOnly(top: 5),

                            //
                            //
                            // estimated time
                            Obx(
                              () => Visibility(
                                visible: controller.estimatedTime.isNotEmpty,
                                child: _buildDetailRow(
                                  "Estimated Time",
                                  controller.estimatedTime.value,
                                ),
                              ),
                            ).marginOnly(top: 5),

                            //
                            //
                            // pickup details
                            Text(
                              "Pickup Details",
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppColorsLight.mainColor,
                              ),
                            ).marginOnly(top: 20),
                            const Divider(),

                            //
                            //
                            // pickup address
                            _buildDetailRow(
                              "Address",
                              controller
                                      .selectedPickupLocation.value!.address ??
                                  "",
                            ).marginOnly(top: 10),

                            //
                            //
                            // pickup date
                            if (controller.pickupDateController.text.isNotEmpty)
                              _buildDetailRow(
                                "Date",
                                "${controller.pickupDateController.text}  at  ${controller.pickupTimeController.text}",
                              ).marginOnly(top: 5),

                            //
                            //
                            // pickup strict
                            _buildDetailRow(
                              "Appointment Strict",
                              controller.pickupStrick.value ? "Yes" : "No",
                            ).marginOnly(top: 5),

                            //
                            //
                            // pickup contact
                            if (controller
                                .pickupContactController.text.isNotEmpty)
                              _buildDetailRow(
                                "Contact",
                                controller.pickupContactController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // pickup weight
                            if (controller
                                .pickupWeightController.text.isNotEmpty)
                              _buildDetailRow(
                                "Weight",
                                controller.pickupWeightController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // pickup goods
                            if (controller
                                .pickupGoodsController.text.isNotEmpty)
                              _buildDetailRow(
                                "Goods",
                                controller.pickupGoodsController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // pickup info
                            if (controller.pickupInfoController.text.isNotEmpty)
                              _buildDetailRow(
                                "Info",
                                controller.pickupInfoController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // delivery details
                            Text(
                              "Delivery Details",
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppColorsLight.mainColor,
                              ),
                            ).marginOnly(top: 20),
                            const Divider(),

                            //
                            //
                            // delivery address
                            _buildDetailRow(
                              "Address",
                              controller.selectedDeliveryLocation.value!
                                      .address ??
                                  "",
                            ).marginOnly(top: 10),

                            //
                            //
                            // delivery date
                            if (controller
                                .deliveryDateController.text.isNotEmpty)
                              _buildDetailRow(
                                "Date",
                                "${controller.deliveryDateController.text}  at  ${controller.deliveryTimeController.text}",
                              ).marginOnly(top: 5),

                            //
                            //
                            // delivery strict
                            _buildDetailRow(
                              "Appointment Strict",
                              controller.deliveryStrick.value ? "Yes" : "No",
                            ).marginOnly(top: 5),

                            //
                            //
                            // delivery contact
                            if (controller
                                .deliveryContactController.text.isNotEmpty)
                              _buildDetailRow(
                                "Contact",
                                controller.deliveryContactController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // delivery weight
                            if (controller
                                .deliveryWeightController.text.isNotEmpty)
                              _buildDetailRow(
                                "Weight",
                                controller.deliveryWeightController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // delivery goods
                            if (controller
                                .deliveryGoodsController.text.isNotEmpty)
                              _buildDetailRow(
                                "Goods",
                                controller.deliveryGoodsController.text,
                              ).marginOnly(top: 5),

                            //
                            //
                            // delivery info
                            if (controller
                                .deliveryInfoController.text.isNotEmpty)
                              _buildDetailRow(
                                "Info",
                                controller.deliveryInfoController.text,
                              ).marginOnly(top: 5),

                            Obx(
                              () => MainAppButton(
                                label: "Create Shipment",
                                isLoading: controller.isCreatingShipment,
                                onPressed: () {
                                  if (!controller.isCreatingShipment) {
                                    controller.createShipment();
                                  }
                                },
                              ),
                            ).marginSymmetric(vertical: 20)
                          ],
                        ).marginSymmetric(horizontal: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildDetailRow(String heading, String details) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        // headings
        Expanded(
          child: Text(
            "$heading :",
            style: Theme.of(Get.context!).textTheme.labelLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),

        //
        //
        Expanded(
          child: Text(
            details,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
