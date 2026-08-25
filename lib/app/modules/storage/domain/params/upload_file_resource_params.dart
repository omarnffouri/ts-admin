import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ts_admin/app/core/utils/functions.dart';

class UploadFileResourceParams {
  final int? parentId;
  final String resourceName;
  final List<File> files;
  final CancelToken cancelToken;
  final void Function(int count, int total) onSendProgress;

  UploadFileResourceParams({
    this.parentId,
    required this.resourceName,
    required this.files,
    required this.cancelToken,
    required this.onSendProgress,
  });

  Map<String, dynamic> _toJson() {
    //
    // passing hard code type of resource "file"
    return {
      'resource_type': "file",
      'parent_id': parentId,
      'resource_name': resourceName
    };
  }

  FormData? getFormData() {
    try {
      Map<String, dynamic> dataMap = _toJson();

      // adding files to dataMap
      for (int i = 0; i < files.length; i++) {
        final multipartFile = MultipartFile.fromFileSync(files[i].path,
            filename: getFileNameWithExtenshion(files[i].path));

        dataMap['files[$i]'] = multipartFile;
      }

      return FormData.fromMap(dataMap);
    } catch (_) {}
    return null;
  }
}
