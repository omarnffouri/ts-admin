import 'dart:io';

import 'vehicle_details_entity.dart';

class VehicleFile {
  final File? file;
  final DocumentDto? document;
  final bool? isAdded;

  VehicleFile({
    this.file,
    this.document,
    this.isAdded,
  });
}
