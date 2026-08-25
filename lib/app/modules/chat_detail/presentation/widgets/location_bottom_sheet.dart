import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_admin/app/core/helpers/location_picker.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';

void showLocationBottomSheet(ChatDetailController controller) {
  showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .70),
      builder: (context) {
        return LocationBottomSheetContent(
          controller: controller,
        );
      },
      isDismissible: false,
      enableDrag: false,
      showDragHandle: false,
      backgroundColor: Colors.transparent);
}

class LocationBottomSheetContent extends StatelessWidget {
  final ChatDetailController controller;
  const LocationBottomSheetContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.close_rounded,
              color: Colors.black,
              size: 24,
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  controller.locationAddress.value,
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppColorsLight.mainColor,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          MapPicker(
            // pass icon widget
            iconWidget: const Icon(
              Icons.location_pin,
              size: 40,
              color: AppColorsLight.mainColor,
            ),
            //add map picker controller
            mapPickerController: controller.mapPickerController,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: Get.height * 0.50,
                child: GoogleMap(
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  // hide location button
                  myLocationButtonEnabled: true,

                  mapToolbarEnabled: true,
                  mapType: MapType.normal,
                  //  camera position
                  initialCameraPosition: controller.cameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    // _controller.complete(controller);
                  },
                  onCameraMoveStarted: () {
                    // notify map is moving
                    controller.mapPickerController.mapMoving!();
                    controller.locationAddress.value = "checking ...";
                  },
                  onCameraMove: (cameraPosition) {
                    controller.cameraPosition = cameraPosition;
                  },
                  onCameraIdle: () async {
                    // notify map stopped moving
                    controller.mapPickerController.mapFinishedMoving!();
                    //get address name from camera position
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      controller.cameraPosition.target.latitude,
                      controller.cameraPosition.target.longitude,
                    );

                    // update the ui with the address
                    controller.locationAddress.value =
                        '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: MainAppButton(
                  label: "Send",
                  onPressed: () {
                    debugPrint(
                        "Location ${controller.cameraPosition.target.latitude} ${controller.cameraPosition.target.longitude}");
                    debugPrint("Address: $controller.locationAddress");
                    controller.sendLocationMessageNew();
                    Get.back();
                  },
                  borderRadius: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
