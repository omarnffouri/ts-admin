import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_custom_switch.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_dropdowns_entity.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/controllers/create_shipment_controller.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';

class SCDeliveryTab extends GetView<CreateShipmentController> {
  const SCDeliveryTab({super.key});

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
                try {
                  controller.deliveryMapControllerCreated(googleMapController);
                } catch (_) {}
              },
              markers: controller.selectedDeliveryLocation.value != null
                  ? {
                      Marker(
                        markerId: const MarkerId("shipment_delivery_location"),
                        infoWindow: InfoWindow(
                          title: controller
                              .selectedDeliveryLocation.value!.address,
                        ),
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
              // polylines: polylines.toSet(),
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.725870, 46.664764),
                zoom: 13,
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.30,
            minChildSize: 0.30,
            maxChildSize: 0.60,
            controller: controller.deliveryDraggableScrollableController,
            snap: true,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? AppColorsDark.mainColorDark
                      : Colors.white,
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
                            children: [
                              //
                              //
                              // location
                              Obx(() => controller.isLoadingDropdownValues
                                  ? const DropdownLoadingWidget()
                                  : SearchableDropDown<
                                      CSLocationDropdownEntity>(
                                      list: controller.dropdownLocations,
                                      bottomSheetLabel:
                                          'Select Delivery Location',
                                      searchHint: 'search by location name',
                                      fieldLabel: 'Location',
                                      fieldHint: 'location',
                                      isRequired: true,
                                      showOnlyLetters: true,
                                      getName: (p0) =>
                                          "${p0.companyName}, ${p0.address}",
                                      getImage: (p0) => p0.companyName ?? "",
                                      selectedItem: controller
                                          .selectedDeliveryLocation.value,
                                      dropdownSearchDecoration:
                                          SearchableDropdownDecoration.bordered,
                                      dropdownDecoration:
                                          SearchableDropdownDecoration.line,
                                      onItemSelected:
                                          (CSLocationDropdownEntity? item) {
                                        if (item != null) {
                                          controller
                                              .onDeliveryLocationSelection(
                                                  item);
                                        }
                                      },
                                      itemAsString: (item) {
                                        return "${item.companyName}, ${item.address}";
                                      },
                                      compareFunction: (item_1, item_2) {
                                        return item_1 == item_2;
                                      },
                                    )).marginSymmetric(
                                  horizontal: 14, vertical: 10),

                              //
                              //
                              // date time picker and strict toggle button
                              Row(
                                children: [
                                  //
                                  //
                                  // date time picker
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          controller.deliveryDateController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        label: RichText(
                                          text: TextSpan(
                                            text: "Date",
                                            style: theme.textTheme.titleSmall,
                                            children: const [
                                              TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        final DateTime? pickedDate =
                                            await controller.pickDate();
                                        if (pickedDate != null) {
                                          final formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          controller.deliveryDateController
                                              .text = formattedDate;
                                        }
                                      },
                                    ),
                                  ),

                                  //
                                  //
                                  // spacer
                                  const SizedBox(
                                    width: 50,
                                  ),

                                  //
                                  //
                                  // tmie input view
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          controller.deliveryTimeController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        label: RichText(
                                          text: TextSpan(
                                            text: "Timer",
                                            style: theme.textTheme.titleSmall,
                                            children: const [
                                              TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        final String? pickedTime =
                                            await controller.pickTime();
                                        if ((pickedTime ?? "").isNotEmpty) {
                                          controller.deliveryTimeController
                                              .text = pickedTime!;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ).marginSymmetric(horizontal: 14, vertical: 10),

                              //
                              //
                              //  contact input field
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      controller:
                                          controller.deliveryContactController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        label: RichText(
                                          text: TextSpan(
                                            text: "Contact",
                                            style: theme.textTheme.titleSmall,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //
                                  //
                                  // spacer
                                  const SizedBox(
                                    width: 50,
                                  ),

                                  //
                                  //
                                  // strick toggle button
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //
                                        // switch text
                                        const Text(
                                          "Strict",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),

                                        //
                                        // switch
                                        Obx(
                                          () => CustomSwitch(
                                            value:
                                                controller.deliveryStrick.value,
                                            onChanged: (value) {
                                              controller.deliveryStrick(value);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).marginSymmetric(horizontal: 14, vertical: 10),

                              //
                              //
                              //  weight and goods input field
                              Row(
                                children: [
                                  //
                                  //
                                  // weight input
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          controller.deliveryWeightController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        label: RichText(
                                          text: TextSpan(
                                            text: "Weight",
                                            style: theme.textTheme.titleSmall,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //
                                  //
                                  // spacer
                                  const SizedBox(
                                    width: 50,
                                  ),

                                  //
                                  //
                                  // goods input
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          controller.deliveryGoodsController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        label: RichText(
                                          text: TextSpan(
                                            text: "Goods",
                                            style: theme.textTheme.titleSmall,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).marginSymmetric(horizontal: 14, vertical: 10),

                              //
                              //
                              //  info input field
                              TextField(
                                controller: controller.deliveryInfoController,
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: TextSpan(
                                      text: "Info",
                                      style: theme.textTheme.titleSmall,
                                    ),
                                  ),
                                ),
                              ).marginSymmetric(horizontal: 14, vertical: 10),

                              //
                              //
                              // next/back button
                              Row(
                                children: [
                                  Expanded(
                                    child: RoundedBorderButton(
                                      label: "Previous",
                                      startIcon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: AppColorsLight.mainColor,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        controller
                                            .shipmentCreationState.value--;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: RoundedFillButton(
                                      label: "Next",
                                      onPressed: () {
                                        if (controller.selectedDeliveryLocation
                                                .value ==
                                            null) {
                                          CommonWidgets.showSnackBar(
                                            title: "Missing",
                                            message:
                                                "Please select delivery location to proceed further.",
                                            isError: false,
                                          );
                                        } else if (controller
                                            .deliveryDateController
                                            .text
                                            .isEmpty) {
                                          CommonWidgets.showSnackBar(
                                            title: "Missing",
                                            message:
                                                "Please select delivery date to proceed further.",
                                            isError: false,
                                          );
                                        } else if (controller
                                            .deliveryTimeController
                                            .text
                                            .isEmpty) {
                                          CommonWidgets.showSnackBar(
                                            title: "Missing",
                                            message:
                                                "Please select delivery time to proceed further.",
                                            isError: false,
                                          );
                                        } else {
                                          controller
                                              .shipmentCreationState.value++;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ).marginSymmetric(horizontal: 14, vertical: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
