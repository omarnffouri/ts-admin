import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleDocuments {
  final truckId = 0.obs;
  Rx<PlatformFile?> selectedFile = Rx<PlatformFile?>(null);
  final selectedCollectionType = "".obs;
  final ValueNotifier<String?> selectedTypeNotifier = ValueNotifier(null);
}
