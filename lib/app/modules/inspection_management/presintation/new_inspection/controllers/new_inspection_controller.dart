import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:signature/signature.dart';
import 'package:ts_admin/app/services/injection_service.dart';

import '../../../domain/entities/inspection_entity.dart';
import '../../../domain/usecases/get_inspection_fields_usecase.dart';
import '../../../domain/usecases/submit_inspection_request_usecase.dart';
import '../../driver_inspection/controllers/driver_inspection_controller.dart';
import '../../truck_trailer_inspection/controllers/truck_trailer_inspection_controller.dart';

class NewInspectionController extends GetxController {
  final getInspectionFieldsUsecase = sl<GetInspectionFieldsUsecase>();
  final submitInspectionUsecase = sl<SubmitInspectionUsecase>();

  final TextEditingController remarksTxtController = TextEditingController();
  final TextEditingController milesTxtController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final inspectionFields = <InspectionEntity>[].obs;

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Get.isDarkMode ? Colors.white : Colors.black,
    exportBackgroundColor: Colors.grey[100],
  );

  final RxInt expandedIndex = (-1).obs;

  final type = "".obs;
  final value = "".obs;
  final id = "".obs;

  final showTimeWidget = false.obs;

  final showInspection = false.obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  /// Presentation-only signal naming the field that failed the checks in
  /// [submitInspectionRequest] ("checks", "date", "miles", "signature"), so the
  /// form can scroll it into view. Nothing in the validation itself reads it.
  final invalidField = "".obs;
  // final isInspectionTypesLoading = false.obs;

  // add list of strings
  final selectedInspectionType = "Inspection Management".obs;
  final selectedOption = "Yes".obs;

  final dropdownOption = [
    "Yes",
    "No",
  ].obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('DriverInspectionController onInit');
    if (Get.arguments != null) {
      // get the value from the arguments as map
      final Map<String, dynamic> args = Get.arguments;
      // get the value from the map
      type.value = args['type'] ?? "";
      value.value = args['value'] ?? "";
      id.value = args['id'] ?? "";
      selectedInspectionType.value = type.value;
      loadInspectionData();
    }
  }

  Future<void> loadInspectionData() async {
    inspectionFields.clear();
    try {
      isLoading.value = true;
      showInspection.value = false;
      final body = {"type": type.value};
      final result = await getInspectionFieldsUsecase.call(body);
      isLoading.value = false;
      showInspection.value = true;
      result.fold(
        (inspectionList) {
          inspectionFields.assignAll(inspectionList);
        },
        (failure) {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Error loading inspection types",
            isError: true,
          );
        },
      );
    } catch (_) {
      isLoading.value = false;
      showInspection.value = true;
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Error loading inspection types",
        isError: true,
      );
    }
  }

  Future<void> submitInspectionRequest() async {
    invalidField.value = "";
    final isDriver = type.value == "driver";
    // get all the passed inspections ids
    final passedInspections = inspectionFields
        .map((e) => e.checks!
            .where((element) => element.isPassed == true)
            .map((e) => e.id))
        .expand((element) => element)
        .toList();
    // least one inspection should be passed
    if (passedInspections.isEmpty) {
      isSubmitting.value = false;
      invalidField.value = "checks";
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Please select at least one inspection",
        isError: true,
      );
      return;
    }
    if (dateController.text.isEmpty) {
      invalidField.value = "date";
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Please add date",
        isError: true,
      );
      return;
    }
    if (type.value == "driver" && milesTxtController.text.isEmpty) {
      invalidField.value = "miles";
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Please add miles",
        isError: true,
      );
      return;
    }
    // add signature validation
    if (signatureController.isEmpty) {
      invalidField.value = "signature";
      CommonWidgets.showSnackBar(
        title: "Error",
        message: "Please add signature",
        isError: true,
      );
      return;
    }
    try {
      isSubmitting.value = true;
      // convert signature to base64
      final Uint8List? bytes = await signatureController.toPngBytes();
      String base64Image = getSignatureBase64(bytes);
      final body = {
        "type": type.value,
        "id": id.value,
        // "remarks": remarksTxtController.text,
        "roadtest_miles": milesTxtController.text,
        "inspection_date": dateController.text,
        "inspection_time": timeController.text,
        "signed": "data:image/png;base64,$base64Image",
        "checks": passedInspections,
      };
      // check if type is driver add remarks
      if (isDriver) {
        body['explanation'] = remarksTxtController.text;
        body['qualified'] = selectedOption.value == "Yes" ? 1 : 0;
      } else {
        body['remarks'] = remarksTxtController.text;
        body['satisfactory'] = selectedOption.value == "Yes" ? 1 : 0;
      }

      final result = await submitInspectionUsecase.call(body);
      result.fold(
        (succ) {
          if (succ == false) {
            return;
          }
          CommonWidgets.showSnackBar(
            title: "Success",
            message: "Inspection submitted successfully",
            isError: false,
          );

          if (isDriver) {
            Get.put(DriverInspectionController()).getAllDriverInspections();
          } else {
            Get.put(TruckTrailerInspectionController())
                .getAllTruckTrailerInspections();
          }
          Navigator.pop(Get.context!);
        },
        (failure) {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: failure.message,
            isError: true,
          );
        },
      );
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: "Error",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  int getTitlePassStatus(InspectionEntity inspectionM) {
    final passedInspections = inspectionM.checks!
        .where(
          (element) => element.isPassed == true,
        )
        .length;
    return passedInspections;
  }

  void handleSwitchSelection(InspectionEntity inspectionM) {
    final passedInspections = inspectionM.checks!
        .where(
          (element) => element.isPassed == true,
        )
        .length;
    if (passedInspections == inspectionM.checks!.length) {
      inspectionM.isSelectedAll = true;
    } else {
      inspectionM.isSelectedAll = false;
    }
    inspectionFields.refresh();
  }

  onTileExpantionChanged(int index, bool expanded) {
    if (!expanded) {
      if (index == expandedIndex.value) {
        expandedIndex.value = -1;
      }
      return;
    }

    for (int i = 0; i < inspectionFields.length; i++) {
      if (i != index) {
        inspectionFields[i].tileController.collapse();
      }
    }
    expandedIndex.value = index;
  }

  String getInspectionTitle() {
    if (type.value == "driver") {
      return "Road Tests list for driver :";
    } else if (type.value == "truck") {
      return "Inspections list for Truck :";
    } else if (type.value == "trailer") {
      return "Inspections list for Trailer :";
    }
    return "Inspection Management";
  }
}
