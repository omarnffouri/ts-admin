import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/map_utils.dart';
import 'package:ts_admin/app/core/values/constants.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';

class MapBottomSheetView extends StatefulWidget {
  const MapBottomSheetView({super.key});

  @override
  State<MapBottomSheetView> createState() => _MapBottomSheetViewState();
}

class _MapBottomSheetViewState extends State<MapBottomSheetView> {
  @override
  void initState() {
    super.initState();
  }

  final user = Get.find<AuthController>().user.value;
  final controller = Get.find<ClockInOutController>();
  final collectionUUID = CommonVariables.tracking.read(uuId);
  final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final rootLogs = ApiConstants.isProduction
      ? "user_tracking_logs"
      : "user_tracking_logs_Staging";

  Completer<GoogleMapController> googleMapController = Completer();
  StreamSubscription<Position>? locationSubscription;

  // rx marker
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final List<LatLng> latLngList = [];
  final List<LatLng> livelatLngList = [];

  //
  final databaseReference = FirebaseDatabase.instance.ref('user_tracking_logs');

  Future<void> onMapCreated(GoogleMapController controller) async {
    if (!googleMapController.isCompleted) {
      googleMapController.complete(controller);
    }

    // delay 1 second to get the current location
    Future.delayed(const Duration(seconds: 1), () async {
      goToMyLocation();
      await getTrackingRecordsOnce();
      trackingDriverMovment();
    });
  }

  Future<void> goToMyLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    try {
      final locationData = await Geolocator.getCurrentPosition();
      final target = LatLng(locationData.latitude, locationData.longitude);
      googleMapController.future.then(
        (value) => value.animateCamera(CameraUpdate.newLatLngZoom(target, 17)),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Function to get data once from Firebase
  Future<void> getTrackingRecordsOnce() async {
    latLngList.clear();
    // Reference to the database
    final logsRef = FirebaseDatabase.instance
        .ref()
        .child(rootLogs)
        .child(today)
        .child(user!.id.toString())
        .child(collectionUUID)
        .orderByChild("timestamp");

    // Getting data once
    DatabaseEvent event = await logsRef.once();
    DataSnapshot snapshot = event.snapshot;

    // Handling the data
    if (!snapshot.exists) {
      debugPrint("No data available.");
      return;
    }
    debugPrint("Data: ${snapshot.value}");
    // Convert the data to a list and sort it by timestamp in descending order
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(snapshot.value as Map);
    List<MapEntry<String, dynamic>> dataList = data.entries.toList();
    dataList.sort((a, b) => int.parse(b.value["timestamp"].toString())
        .compareTo(int.parse(a.value["timestamp"].toString())));

    // Create list of LatLng from sorted data
    for (var entry in dataList) {
      final latLng = LatLng(entry.value["lat"], entry.value["lng"]);
      latLngList.add(latLng);
    }

    debugPrint("latLngList length: ${latLngList.length}");
    if (latLngList.isNotEmpty) {
      livelatLngList.add(latLngList.first);
    }
    // create polyline from latlng list
    addFirebasePolyline();
    // bounds of polyline
    googleMapController.future.then(
      (value) => value.animateCamera(
        CameraUpdate.newLatLngBounds(boundsFromLatLngList(latLngList), 80),
      ),
    );
  }

  void addFirebasePolyline() {
    final polyline = Polyline(
      polylineId: const PolylineId("firebase_tracking"),
      color: Colors.blue,
      width: 5,
      points: latLngList,
    );
    polylines.add(polyline);
    polylines.refresh();
  }

  void addLivePolyline() {
    final polyline = Polyline(
      polylineId: const PolylineId("live_tracking"),
      color: Colors.blue,
      width: 5,
      points: livelatLngList,
    );
    polylines.add(polyline);
    polylines.refresh();
  }

  // Function to get the current location and move the camera
  Future<void> trackingDriverMovment() async {
    locationSubscription =
        Geolocator.getPositionStream().listen((Position location) async {
      livelatLngList.add(LatLng(location.latitude, location.longitude));
      addLivePolyline();
      googleMapController.future.then(
        (v) => v.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 17,
            ),
          ),
        ),
      );
      if (controller.autoClosBtn.value == true) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // top header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: 50,
          decoration: const BoxDecoration(
            color: AppColorsLight.mainColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "On My Way",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () async {
                if (controller.autoClosBtn.value == false) {
                  Navigator.pop(context);
                }
              },
              child: const Icon(
                Icons.close_rounded,
                size: 25,
                color: Colors.white,
              ),
            )
          ]),
        ),

        SizedBox(
          height: 200,
          child: Obx(
            () => GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: onMapCreated,
              markers: markers,
              polylines: polylines.toSet(),
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.725870, 46.664764),
                zoom: 13,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    googleMapController.future.then((value) => value.dispose());
    super.dispose();
  }
}
