import 'dart:io';

import 'service_order_entity.dart';

class ServiceOrderFile {
  final bool isAdd;
  final File? file;
  final FileElementEntity? onlineFile;

  ServiceOrderFile({
    required this.isAdd,
    this.file,
    this.onlineFile,
  });
}
