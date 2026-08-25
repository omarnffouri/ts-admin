import 'dart:io';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_admin/app/core/helpers/base_response.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_types.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_dropdowns_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/create_shipment_template.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/get_shipment_dropdowns.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class CreateShipmentController extends GetxController {
  //
  //
  // shipment creation current active step
  final RxInt shipmentCreationState = ShipmentCreationStates.general.obs;
  final RxInt shipmentCreationGeneralState =
      ShipmentCreationGeneralStates.pickCustomer.obs;

  final PageController pageController = PageController();

  final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

  //
  //
  // google map related variables
  GoogleMapController? pickupGoogleMapController;
  GoogleMapController? deliveryGoogleMapController;
  GoogleMapController? previewGoogleMapController;
  final RxBool pickupLocationBearingEnabled = false.obs;
  final RxBool deliveryLocationBearingEnabled = false.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxString estimatedDistance = ''.obs;
  final RxString estimatedTime = ''.obs;
  final RxString polylineString = ''.obs;

  //
  //
  // usecases
  final getCSDropdownsUsecase = sl<GetCSDropdownsUsecase>();
  final createShipmentUsecase = sl<CreateShipmentTemplateUsecase>();

  //
  //
  // controllers
  final TextEditingController customerReferenceController =
      TextEditingController();
  final TextEditingController contractedAmountController =
      TextEditingController();
  final TextEditingController trailerIndetifierController =
      TextEditingController();

  final pickupDraggableScrollableController = DraggableScrollableController();
  final deliveryDraggableScrollableController = DraggableScrollableController();

  //
  //
  // pickup location variables
  final TextEditingController pickupDateController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();
  final TextEditingController pickupContactController = TextEditingController();
  final TextEditingController pickupWeightController = TextEditingController();
  final TextEditingController pickupInfoController = TextEditingController();
  final TextEditingController pickupGoodsController = TextEditingController();
  final RxBool pickupStrick = false.obs;

  //
  //
  // delivery location variables
  final TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  final TextEditingController deliveryContactController =
      TextEditingController();
  final TextEditingController deliveryWeightController =
      TextEditingController();
  final TextEditingController deliveryInfoController = TextEditingController();
  final TextEditingController deliveryGoodsController = TextEditingController();
  final RxBool deliveryStrick = false.obs;

  //
  //
  // state variables
  final RxBool _isCreatingShipment = false.obs;
  bool get isCreatingShipment => _isCreatingShipment.value;

  final RxBool _isTruckTrailerSelectionDisabled = true.obs;
  bool get isTruckTrailerSelectionDisabled =>
      _isTruckTrailerSelectionDisabled.value;

  final RxBool _isLoadingDropdownValues = false.obs;
  bool get isLoadingDropdownValues => _isLoadingDropdownValues.value;

  //
  // confirmation file
  final Rxn<File> confirmationFile = Rxn();
  final RxnString confirmationFileSize = RxnString();

  //
  //
  // inline validation error per general sub-step (keyed by
  // ShipmentCreationGeneralStates), shown by the step widget instead of a
  // snackbar so the message sits next to the field it refers to.
  final RxMap<int, String?> generalStepErrors = <int, String?>{}.obs;

  //
  //
  // dropdown data lists
  RxList<CSLocationDropdownEntity> dropdownLocations = RxList();
  RxList<CSCustomerDropdownEntity> dropdownCustomers = RxList();
  RxList<CSCustomerDropdownEntity> dropdownDrivers = RxList();
  RxList<CSTruckDropdownEntity> dropdownTrucks = RxList();
  RxList<CSTrailerDropdownEntity> dropdownTrailers = RxList();

  //
  //
  // selected data
  final Rxn<CSCustomerDropdownEntity> selectedCustomer = Rxn();
  final Rxn<CSCustomerDropdownEntity> selectedDriver = Rxn();
  final Rxn<CSTruckDropdownEntity> selectedTruck = Rxn();
  final Rxn<CSTrailerDropdownEntity> selectedTrailer = Rxn();
  final Rxn<CSLocationDropdownEntity> selectedPickupLocation = Rxn();
  final Rxn<CSLocationDropdownEntity> selectedDeliveryLocation = Rxn();
  final Rxn<String> selectedTrailerType = Rxn();

  @override
  void onInit() {
    super.onInit();
    getCSDropdownValues();
    shipmentCreationState.listen((state) {
      if (state >= 0 && state < 4) {
        pageController.animateToPage(
          state,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
    selectedDriver.listen((driver) {
      _isTruckTrailerSelectionDisabled(driver == null);
    });
    contractedAmountController.addListener(_clearContractedAmountError);
  }

  void _clearContractedAmountError() {
    if (generalStepErrors[ShipmentCreationGeneralStates.contarctedAmount] !=
        null) {
      generalStepErrors[ShipmentCreationGeneralStates.contarctedAmount] = null;
    }
  }

  String getStepName(int step) {
    switch (step) {
      case 0:
        return "General";
      case 1:
        return "Pickup";
      case 2:
        return "Delivery";
      case 3:
        return "Summary";
    }
    return "";
  }

  String getGeneralStepName(int step) {
    switch (step) {
      case ShipmentCreationGeneralStates.pickCustomer:
        return "Customer";
      case ShipmentCreationGeneralStates.pickDriver:
        return "Driver";
      case ShipmentCreationGeneralStates.pickTruckTrailer:
        return "Truck & Trailer";
      case ShipmentCreationGeneralStates.contarctedAmount:
        return "Contracted Amount";
      case ShipmentCreationGeneralStates.confirmationFile:
        return "Confirmation File";
    }
    return "";
  }

  /// Whether the whole page can be popped without losing entered data: only
  /// true while sitting on the very first sub-step of the very first tab.
  bool get canPopWithoutConfirmation =>
      (shipmentCreationState.value == ShipmentCreationStates.general) &&
      (shipmentCreationGeneralState.value ==
          ShipmentCreationGeneralStates.pickCustomer) &&
      (!isCreatingShipment);

  //
  //
  // function to handle the pop scope: steps back through the general
  // sub-stepper first (so a hardware/gesture back never silently discards a
  // partially filled step), only popping the page once nothing is left to
  // undo.
  void onBackPressed(bool didPop) {
    if ((shipmentCreationState.value == ShipmentCreationStates.general) &&
        (shipmentCreationGeneralState.value >
            ShipmentCreationGeneralStates.pickCustomer)) {
      onGeneralStepBackClicked();
    } else if (shipmentCreationState.value >
        ShipmentCreationStates.values.first) {
      shipmentCreationState.value--;
    } else if ((!didPop) && (!isCreatingShipment)) {
      Get.back(canPop: true);
    }
  }

  /// Moves the general sub-stepper back one step, re-applying the same
  /// truck/trailer-skip rule used when stepping forward.
  void onGeneralStepBackClicked() {
    if (shipmentCreationGeneralState.value ==
        ShipmentCreationGeneralStates.pickCustomer) {
      return;
    }

    //
    // if driver is not selected means truck/trailer step is disabled
    // push to select customer step
    else if (shipmentCreationGeneralState.value ==
        ShipmentCreationGeneralStates.contarctedAmount) {
      if (isTruckTrailerSelectionDisabled) {
        shipmentCreationGeneralState.value =
            ShipmentCreationGeneralStates.pickDriver;
        return;
      }
    }
    shipmentCreationGeneralState.value--;
  }

  /// Lets the user tap back into an already-completed (or errored) step
  /// without losing anything they entered further along.
  void goToGeneralStep(int step) {
    if (step < shipmentCreationGeneralState.value) {
      shipmentCreationGeneralState(step);
    }
  }

  String getConformationFileIcon() {
    return fileExtensionHelper.getFileIcon(
      fileExtensionHelper.getFileType(confirmationFile.value?.path ?? "none"),
    );
  }

  bool confirmationFileIsImage() {
    final fileType =
        fileExtensionHelper.getFileType(confirmationFile.value?.path ?? "none");
    return (fileType == FileTypes.jpeg ||
        fileType == FileTypes.jpg ||
        fileType == FileTypes.png);
  }

  String getConformationFileName() {
    return fileExtensionHelper.getFileName(
      confirmationFile.value?.path ?? "none",
      withExtension: true,
    );
  }

  String getConformationFileExtension() {
    return fileExtensionHelper.getFileExtension(
      confirmationFile.value?.path ?? "",
    );
  }

  //
  //
  // compact "what you picked" summaries shown once a step is completed
  String? get customerStepSummary {
    final customer = selectedCustomer.value;
    if (customer == null) return null;
    final reference = customerReferenceController.text;
    return reference.isEmpty ? customer.name : "${customer.name} · $reference";
  }

  String? get driverStepSummary => selectedDriver.value?.name;

  String? get truckTrailerStepSummary {
    final truck = selectedTruck.value?.name;
    if (truck == null) return null;

    String? trailer;
    if (selectedTrailerType.value == TrailerTypes.trailer) {
      trailer = selectedTrailer.value?.identifier?.toString();
    } else if (selectedTrailerType.value == TrailerTypes.thirdPartyTrailer) {
      trailer = trailerIndetifierController.text.isEmpty
          ? null
          : trailerIndetifierController.text;
    }
    return trailer == null ? truck : "$truck · $trailer";
  }

  String? get contractedAmountStepSummary {
    final amount = contractedAmountController.text;
    return amount.isEmpty ? null : "\$$amount";
  }

  String? get confirmationFileStepSummary =>
      confirmationFile.value == null ? null : getConformationFileName();

  Future<void> getCSDropdownValues() async {
    try {
      _isLoadingDropdownValues(true);
      final Either<BaseResponse<ShipmentDropdownsPlayloadEntity>, Failure>
          result = await getCSDropdownsUsecase.call(const NoParams());

      result.fold((BaseResponse<ShipmentDropdownsPlayloadEntity> response) {
        if (response.code == 200 && response.data != null) {
          //
          // loading customers
          dropdownCustomers.clear();
          dropdownCustomers.addAll(response.data?.customers ?? []);

          //
          // loading drivers
          dropdownDrivers.clear();
          dropdownDrivers.addAll(response.data?.drivers ?? []);

          //
          // loading trucks
          dropdownTrucks.clear();
          dropdownTrucks.addAll(response.data?.trucks ?? []);

          //
          // loading trailers
          dropdownTrailers.clear();
          dropdownTrailers.addAll(response.data?.trailers ?? []);

          //
          // loading locations
          dropdownLocations.clear();
          dropdownLocations.addAll(response.data?.locations ?? []);
        }
      }, (Failure r) {
        CommonWidgets.showSnackBar(
          title: ''.tr,
          message: r.message,
          isError: false,
        );
      });
      _isLoadingDropdownValues(false);
    } on Exception catch (e) {
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isLoadingDropdownValues(false);
    }
  }

  void onGeneralStepNextClicked() {
    FocusManager.instance.primaryFocus?.unfocus();
    generalStepErrors[shipmentCreationGeneralState.value] = null;

    //
    // if current step is select customer then validate and proceed
    if (shipmentCreationGeneralState.value ==
        ShipmentCreationGeneralStates.pickCustomer) {
      //
      // check if customer is selected then go to next step else show error
      if (selectedCustomer.value == null) {
        generalStepErrors[ShipmentCreationGeneralStates.pickCustomer] =
            "Please select customer to proceed further.";
      }
      // else if (customerReferenceController.text.isEmpty) {
      //   generalStepErrors[ShipmentCreationGeneralStates.pickCustomer] =
      //       "Please enter customer reference to proceed further.";
      // }
      else {
        shipmentCreationGeneralState.value++;
      }
    }
    //
    // if current step is select driver then validate and proceed
    else if (shipmentCreationGeneralState.value ==
        ShipmentCreationGeneralStates.pickDriver) {
      //
      // check if driver is selected then go to next step else skip trailer step
      if (selectedDriver.value == null) {
        shipmentCreationGeneralState.value =
            ShipmentCreationGeneralStates.contarctedAmount;
      } else {
        shipmentCreationGeneralState.value++;
      }
    }

    //
    // if current step is select truck / trailer then validate and proceed
    else if (shipmentCreationGeneralState.value ==
        ShipmentCreationGeneralStates.pickTruckTrailer) {
      //
      // check if truck is not selected then show error
      if (selectedTruck.value == null) {
        generalStepErrors[ShipmentCreationGeneralStates.pickTruckTrailer] =
            "Please select truck to proceed further.";
      }

      // for now trailer in optional
      // check if trailer is not selected then show error
      // else if (selectedTrailer.value == null) {
      //   generalStepErrors[ShipmentCreationGeneralStates.pickTruckTrailer] =
      //       "Please select trailer to proceed further.";
      // }

      //
      //
      // now truck and trailer is selected proceed to next main step
      else {
        shipmentCreationGeneralState.value++;
      }
    }

    //
    // if current step is contarcted amount then validate and proceed
    else if (shipmentCreationGeneralState.value ==
        ShipmentCreationGeneralStates.contarctedAmount) {
      //
      // check if contracted amount is empty then show error
      if (contractedAmountController.text.isEmpty) {
        generalStepErrors[ShipmentCreationGeneralStates.contarctedAmount] =
            "Please enter amount to proceed further.";
      }

      //
      //
      // proceed to next general step
      else {
        shipmentCreationGeneralState.value++;
      }
    }

    //
    // if current step is confirmation file then validate and proceed
    else if (shipmentCreationGeneralState.value ==
        ShipmentCreationGeneralStates.confirmationFile) {
      ///
      /// for now conformation file is optional,
      ///

      //
      // check if confirmation file is not selected then show error
      // if (confirmationFile.value == null) {
      //   CommonWidgets.showSnackBar(
      //     title: "Missing",
      //     message: "Please select confirmation file to proceed further.",
      //     isError: false,
      //   );
      // }

      //
      //
      // proceed to next main step
      // else {
      shipmentCreationState.value++;
      // }
    }
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/////////////////////////// Picker functions ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  void pickFile() async {
    try {
      //
      // pick file
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (filePickerResult != null) {
        PlatformFile pickedFile = filePickerResult.files.first;
        if (pickedFile.path != null) {
          confirmationFile.value = File(pickedFile.path!);
          confirmationFileSize.value = _formatFileSize(confirmationFile.value!);
        }
      }
    } catch (_) {}
  }

  void removeConfirmationFile() {
    confirmationFile.value = null;
    confirmationFileSize.value = null;
  }

  String? _formatFileSize(File file) {
    try {
      final int bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> pickDate() async {
    return await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Get.theme.copyWith(
            colorScheme: Get.theme.colorScheme.copyWith(
              primary: Colors.redAccent,
              onSurface: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor:
                  Get.isDarkMode ? AppColorsDark.mainColorDark : null,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          // child: child!,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: child!,
          ),
        );
      },
    );
  }

  Future<String?> pickTime() async {
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Get.theme.copyWith(
            colorScheme: Get.theme.colorScheme.copyWith(
              primary: Colors.redAccent,
              onSurface: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor:
                  Get.isDarkMode ? AppColorsDark.mainColorDark : null,
              dayPeriodColor: Get.isDarkMode
                  ? AppColorsDark.mainRedColor
                  : AppColorsLight.mainColor,
              hourMinuteTextStyle: const TextStyle(
                fontSize: 45,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: child!,
          ),
        );
      },
    );

    if (time != null) {
      var hours = time.hour.toString();
      var minutes = time.minute.toString();
      if (time.hour < 10) {
        hours = "0${time.hour}";
      }
      if (time.minute < 10) {
        minutes = "0${time.minute}";
      }
      return '$hours:$minutes';
    }
    return '';
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////// Dropdown on selection callbacks /////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  void onCustomerSelection(CSCustomerDropdownEntity customer) {
    //
    selectedCustomer(customer);
    generalStepErrors[ShipmentCreationGeneralStates.pickCustomer] = null;
  }

  void onDriverSelection(CSCustomerDropdownEntity driver) {
    //
    selectedDriver(driver);
    selectedTruck.value =
        dropdownTrucks.firstWhereOrNull((item) => item.id == driver.truckId);
    shipmentCreationGeneralState.value++;
  }

  void onTruckSelection(CSTruckDropdownEntity truck) {
    //
    selectedTruck(truck);
    generalStepErrors[ShipmentCreationGeneralStates.pickTruckTrailer] = null;
    if (selectedTrailer.value != null) {
      shipmentCreationGeneralState.value++;
    }
  }

  void onTrailerSelection(CSTrailerDropdownEntity trailer) {
    //
    selectedTrailer(trailer);
    if (selectedTruck.value != null) {
      shipmentCreationGeneralState.value++;
    }
  }

  void onTrailerTypeSelection(String trailerType) {
    if (trailerType == selectedTrailerType.value) {
      return;
    }
    //
    selectedTrailerType(trailerType);
    selectedTrailer.value = null;
    trailerIndetifierController.clear();
  }

  void onPickupLocationSelection(CSLocationDropdownEntity location) async {
    //
    // zoom out
    await _zoomOutLocationCamera(pickupGoogleMapController);

    //
    // setting location and bearing
    selectedPickupLocation(location);
    pickupLocationBearingEnabled.toggle();

    //
    // zooming in to location point
    await _animateAndZoomInCameraToLocation(pickupGoogleMapController, location,
        pickupLocationBearingEnabled.value);

    _expandDraggableSheet(pickupDraggableScrollableController);
  }

  void onDeliveryLocationSelection(CSLocationDropdownEntity location) async {
    //
    // zoom out
    await _zoomOutLocationCamera(deliveryGoogleMapController);

    //
    // setting location and bearing
    selectedDeliveryLocation(location);
    deliveryLocationBearingEnabled.toggle();

    //
    // zooming in to location point
    await _animateAndZoomInCameraToLocation(deliveryGoogleMapController,
        location, deliveryLocationBearingEnabled.value);

    _expandDraggableSheet(deliveryDraggableScrollableController);
  }

  void _expandDraggableSheet(DraggableScrollableController controller) {
    if (controller.isAttached) {
      controller.animateTo(
        1.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.linearToEaseOut,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isAttached) {
        return;
      }

      controller.animateTo(
        1.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.linearToEaseOut,
      );
    });
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////// Location and map related functions ///////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  pickupMapControllerCreated(GoogleMapController controller) {
    pickupGoogleMapController = controller;

    //
    // navigating map to old pickup location if already selected
    if (selectedPickupLocation.value != null) {
      onPickupLocationSelection(selectedPickupLocation.value!);
    }
  }

  deliveryMapControllerCreated(GoogleMapController controller) {
    deliveryGoogleMapController = controller;
    //
    // navigating map to old delivery location if already selected
    if (selectedDeliveryLocation.value != null) {
      onDeliveryLocationSelection(selectedDeliveryLocation.value!);
    }
  }

  previewMapControllerCreated(GoogleMapController controller) {
    previewGoogleMapController = controller;
    //
    // navigating map to old delivery location if already selected
    // if (selectedDeliveryLocation.value != null) {
    //   onDeliveryLocationSelection(selectedDeliveryLocation.value!);
    // }
    drawPolyline();
  }

  _animateAndZoomInCameraToLocation(GoogleMapController? googleMapController,
      CSLocationDropdownEntity? location, bool isBearingEnabled,
      {double tilt = 90}) async {
    if (location == null || googleMapController == null) {
      return;
    }

    final latlong = LatLng(
      double.parse(location.latitude ?? "0.0"),
      double.parse(location.longitude ?? "0.0"),
    );

    //
    // zooming in
    try {
      await googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latlong,
            zoom: 15,
            tilt: tilt,
            bearing: isBearingEnabled ? 90 : 0,
          ),
        ),
      );
    } catch (_) {}
  }

  _zoomOutLocationCamera(GoogleMapController? googleMapController) async {
    if (googleMapController != null) {
      //
      // zooming out
      try {
        await googleMapController.animateCamera(CameraUpdate.zoomTo(3));
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> drawPolyline() async {
    if (selectedPickupLocation.value == null ||
        selectedDeliveryLocation.value == null) {
      return;
    }

    if ((selectedPickupLocation.value!.latitude?.isEmpty ?? true) ||
        (selectedPickupLocation.value!.longitude?.isEmpty ?? true) ||
        (selectedDeliveryLocation.value!.latitude?.isEmpty ?? true) ||
        (selectedDeliveryLocation.value!.longitude?.isEmpty ?? true)) {
      return;
    }

    estimatedDistance('');
    estimatedTime('');
    polylines.clear();
    polylineString('');

    try {
      //
      var pickup = PointLatLng(
        double.parse(selectedPickupLocation.value!.latitude ?? "0.0"),
        double.parse(selectedPickupLocation.value!.longitude ?? "0.0"),
      );
      var delivery = PointLatLng(
        double.parse(selectedDeliveryLocation.value!.latitude ?? "0.0"),
        double.parse(selectedDeliveryLocation.value!.longitude ?? "0.0"),
      );
      PolylinePoints polylinePoints = PolylinePoints();
      final request = PolylineRequest(
        origin: pickup,
        destination: delivery,
        mode: TravelMode.driving,
      );
      final result = await polylinePoints.getRouteBetweenCoordinates(
        request: request,
        googleApiKey: "REPLACE_WITH_GOOGLE_API_KEY",
      );

      //
      // setting estimated distance
      if ((result.distanceTexts ?? []).isNotEmpty) {
        estimatedDistance(result.distanceTexts![0]);
      }

      //
      // setting estimated time
      if ((result.durationTexts ?? []).isNotEmpty) {
        estimatedTime(result.durationTexts![0]);
      }

      //
      //
      if (result.overviewPolyline?.isNotEmpty ?? false) {
        polylineString(result.overviewPolyline!);
      }

      //
      // adding polyline
      polylines.add(
        Polyline(
          polylineId: const PolylineId('pickup_to_delivery'),
          color: Colors.blue,
          patterns: <PatternItem>[PatternItem.dash(30), PatternItem.gap(2)],
          jointType: JointType.round,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          points: result.points
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList(),
        ),
      );
      polylines.refresh();

      //
      //
      // move camera to bound locations
      _animateCameraToPolyline(result.points);
    } catch (_) {}
  }

  void _animateCameraToPolyline(List<PointLatLng> points) {
    LatLngBounds bounds;
    if (points.isNotEmpty) {
      double minLat = points[0].latitude;
      double maxLat = points[0].latitude;
      double minLng = points[0].longitude;
      double maxLng = points[0].longitude;

      for (var latLng in points) {
        if (latLng.latitude > maxLat) maxLat = latLng.latitude;
        if (latLng.latitude < minLat) minLat = latLng.latitude;
        if (latLng.longitude > maxLng) maxLng = latLng.longitude;
        if (latLng.longitude < minLng) minLng = latLng.longitude;
      }

      bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      if (previewGoogleMapController != null) {
        previewGoogleMapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100), // padding is optional
        );
      }
    }
  }

  void createShipment() async {
    try {
      //
      final dio.FormData data = _getCreateShipmentFormData();
      _isCreatingShipment(true);
      final response = await createShipmentUsecase.call(data);

      response.fold((result) {
        //
        if ((result.code == 200) && (result.data == true)) {
          Get.back(result: true);

          CommonWidgets.showSnackBar(
            title: 'Success'.tr,
            message: result.message ?? "Shipment created successfully.",
            isError: false,
          );
        }

        _isCreatingShipment(false);
      }, (failure) {
        //
        CommonWidgets.showSnackBar(
          title: ''.tr,
          message: failure.message,
          isError: false,
        );
        _isCreatingShipment(false);
      });
    } catch (e) {
      //
      CommonWidgets.showSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
      debugPrint(e.toString());
      _isCreatingShipment(false);
    }
  }

  dio.FormData _getCreateShipmentFormData() {
    //
    // general details
    final customerId = selectedCustomer.value?.id;
    final customerReference = customerReferenceController.text;
    final driverId = selectedDriver.value?.id;
    final truckId = selectedTruck.value?.id;
    final trailerType =
        TrailerTypes.getTrailerTypeCode(selectedTrailerType.value);
    dynamic trailerId = selectedTrailer.value?.id;
    final contractedAmount = double.parse(contractedAmountController.text);
    final confirmationFile = this.confirmationFile.value?.path;

    if (trailerType ==
        TrailerTypes.getTrailerTypeCode(TrailerTypes.thirdPartyTrailer)) {
      trailerId = trailerIndetifierController.text;
    }

    //
    // pickup details
    final pickupLocationId = selectedPickupLocation.value?.id;
    final pickupDate =
        "${pickupDateController.text} ${pickupTimeController.text}:00"; // adding 00 for seconds
    final pickupStrick = this.pickupStrick.value;
    final pickupContact = pickupContactController.text;
    final pickupWeight = (pickupWeightController.text.isNotEmpty)
        ? double.parse(pickupWeightController.text)
        : '';
    final pickupGoods = pickupGoodsController.text;
    final pickupInfo = pickupInfoController.text;
    //
    // deleivery details
    final deliveryLocationId = selectedDeliveryLocation.value?.id;
    final deliveryDate =
        "${deliveryDateController.text} ${deliveryTimeController.text}:00"; // adding 00 for seconds
    final deliveryStrick = this.deliveryStrick.value;
    final deliveryContact = deliveryContactController.text;
    final deliveryWeight = (deliveryWeightController.text.isNotEmpty)
        ? double.parse(deliveryWeightController.text)
        : '';
    final deliveryGoods = deliveryGoodsController.text;
    final deliveryInfo = deliveryInfoController.text;

    //
    // from data map
    Map<String, dynamic> dataMap = {};

    //
    // adding general data to map
    dataMap['customer_id'] = customerId;
    dataMap['customer_reference'] = customerReference;
    dataMap['driver_id'] = driverId;
    dataMap['truck_id'] = truckId;
    dataMap['trailer_id'] = trailerId;
    dataMap['contract_flat_amount'] = contractedAmount;
    dataMap['estimated_duration'] = estimatedTime.value;
    dataMap['total_mileage'] = _getEstimatedDistance();
    dataMap['original_polyline'] = polylineString.value;

    //
    // adding pickup data to map
    dataMap['pickup_stops[0][location_id]'] = pickupLocationId;
    dataMap['pickup_stops[0][transit_date_time]'] = pickupDate;
    dataMap['pickup_stops[0][strict]'] = pickupStrick ? 1 : 0;
    dataMap['pickup_stops[0][contact_details]'] = pickupContact;
    dataMap['pickup_stops[0][weight]'] = pickupWeight;
    dataMap['pickup_stops[0][goods]'] = pickupGoods;
    dataMap['pickup_stops[0][info]'] = pickupInfo;
    dataMap['pickup_stops[0][stop_type]'] = 'pickup';

    //
    // adding delivery data to map
    dataMap['delivery_stops[0][location_id]'] = deliveryLocationId;
    dataMap['delivery_stops[0][transit_date_time]'] = deliveryDate;
    dataMap['delivery_stops[0][strict]'] = deliveryStrick ? 1 : 0;
    dataMap['delivery_stops[0][contact_details]'] = deliveryContact;
    dataMap['delivery_stops[0][weight]'] = deliveryWeight;
    dataMap['delivery_stops[0][goods]'] = deliveryGoods;
    dataMap['delivery_stops[0][info]'] = deliveryInfo;
    dataMap['delivery_stops[0][stop_type]'] = 'delivery';

    //
    // adding confirmation file to data map
    if ((confirmationFile ?? "").isNotEmpty) {
      final multipartFile = dio.MultipartFile.fromFileSync(confirmationFile!,
          filename: getFileNameWithExtenshion(confirmationFile));
      dataMap['file'] = multipartFile;
    }

    return dio.FormData.fromMap(dataMap);
  }

  double _getEstimatedDistance() {
    if (estimatedDistance.value.isEmpty) {
      return 0.0;
    }

    final values = estimatedDistance.split(' ');
    if (values.length != 2) {
      return 0.0;
    }
    try {
      return double.parse(values.first);
    } catch (_) {
      return 0.0;
    }
  }

  @override
  void onClose() {
    contractedAmountController.removeListener(_clearContractedAmountError);

    //
    // disposde pickup controllers
    if (pickupDraggableScrollableController.isAttached) {
      pickupDraggableScrollableController.dispose();
    }
    pickupContactController.dispose();
    pickupDateController.dispose();
    pickupGoodsController.dispose();
    pickupGoogleMapController?.dispose();
    pickupInfoController.dispose();
    pickupTimeController.dispose();
    pickupWeightController.dispose();

    //
    // dispose delivery controllers
    if (deliveryDraggableScrollableController.isAttached) {
      deliveryDraggableScrollableController.dispose();
    }
    deliveryContactController.dispose();
    deliveryDateController.dispose();
    deliveryGoodsController.dispose();
    deliveryGoogleMapController?.dispose();
    deliveryInfoController.dispose();
    deliveryTimeController.dispose();
    deliveryWeightController.dispose();

    //
    // summary controller disponse
    previewGoogleMapController?.dispose();

    super.onClose();
  }
}

//
//
//
// states that represents the shipment creation state
class ShipmentCreationStates {
  static const general = 0;
  static const pickup = 1;
  static const delivery = 2;
  static const preview = 3;

  static const values = [general, pickup, delivery, preview];
}

class ShipmentCreationGeneralStates {
  static const pickCustomer = 0;
  static const pickDriver = 1;
  static const pickTruckTrailer = 2;
  static const contarctedAmount = 3;
  static const confirmationFile = 4;

  static const values = [
    pickCustomer,
    pickDriver,
    pickTruckTrailer,
    contarctedAmount,
    confirmationFile
  ];
}

class TrailerTypes {
  static const trailer = 'Trailer';
  static const thirdPartyTrailer = 'Third Party Trailer';
  static const bobTil = 'Bobtail';

  static String getTrailerTypeCode(String? type) {
    if (type == trailer) {
      return "trailer";
    } else if (type == thirdPartyTrailer) {
      return "thirdPartyTrailer";
    } else {
      return "bobtail";
    }
  }

  static const values = [trailer, thirdPartyTrailer, bobTil];
}
