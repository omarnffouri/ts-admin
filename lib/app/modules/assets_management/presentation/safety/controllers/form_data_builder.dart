import 'package:dio/dio.dart' as dio;
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';

import '../../../domain/entities/vehicle_document.dart';
import '../../../domain/entities/vehicle_file.dart';

class FormDataBuilder {
  static Future<dio.FormData?> buildDocumentsFormData({
    required String truckId,
    required List<VehicleDocuments> documents,
    bool isTrailer = false,
  }) async {
    final Map<String, dynamic> dataMap = {};

    if (documents.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Validation Error',
        message: 'Please add at least one document.',
      );
      return null;
    }

    for (int i = 0; i < documents.length; i++) {
      final detail = documents[i];
      final file = detail.selectedFile.value;
      final type = detail.selectedCollectionType.value;

      if (file == null || type.isEmpty) {
        CommonWidgets.showSnackBar(
          title: 'Validation Error',
          message: 'Please fill all required fields for document #${i + 1}',
        );
        return null;
      }

      try {
        final multipartFile = dio.MultipartFile.fromFileSync(
          file.path!,
          filename: getFileNameWithExtenshion(file.path!),
        );

        final prefix = 'data[$i]';
        if (isTrailer) {
          dataMap.addAll({
            '$prefix[trailer_id]': truckId,
          });
        } else {
          dataMap.addAll({
            '$prefix[truck_id]': truckId,
          });
        }
        dataMap.addAll({
          '$prefix[collection_type]': type,
          '$prefix[file]': multipartFile,
        });
      } catch (e) {
        CommonWidgets.showSnackBar(
          title: 'File Error',
          message: 'Failed to process file for document #${i + 1}',
        );
        return null;
      }
    }

    if (isTrailer) {
      dataMap['isTrailer'] = true;
    }

    return dio.FormData.fromMap(dataMap);
  }

  /// Builds FormData for updating a single truck document
  static Future<dio.FormData?> buildUpdateDocumentFormData({
    required String truckId,
    required VehicleFile? updateTruckDocument,
  }) async {
    final Map<String, dynamic> dataMap = {};

    if (updateTruckDocument == null || updateTruckDocument.file == null) {
      CommonWidgets.showSnackBar(
        title: 'Validation Error',
        message: 'Please select a file to update.',
      );
      return null;
    }

    final filePath = updateTruckDocument.file!.path;

    try {
      final multipartFile = dio.MultipartFile.fromFileSync(
        filePath,
        filename: getFileNameWithExtenshion(filePath),
      );

      dataMap.addAll({
        'id': truckId,
        'collection_type': updateTruckDocument.document?.collectionType ?? '',
        'file': multipartFile,
      });
    } catch (e) {
      CommonWidgets.showSnackBar(
        title: 'File Error',
        message: 'Failed to process the file.',
      );
      return null;
    }

    return dio.FormData.fromMap(dataMap);
  }

  static Future<dio.FormData?> buildPicturesFormData({
    required String truckId,
    required List<VehicleFile> pictures,
  }) async {
    final Map<String, dynamic> dataMap = {};

    final picturesToUpload =
        pictures.where((e) => e.isAdded == true && e.file != null).toList();

    if (picturesToUpload.isEmpty) {
      CommonWidgets.showSnackBar(
        title: 'Validation Error',
        message: 'Please add at least one picture.',
      );
      return null;
    }

    // Add base data
    dataMap.addAll({
      'truck': truckId,
      'collection_name': 'truck_pictures',
    });

    // Attach files
    for (int i = 0; i < picturesToUpload.length; i++) {
      final file = picturesToUpload[i].file!;
      try {
        final multipartFile = dio.MultipartFile.fromFileSync(
          file.path,
          filename: getFileNameWithExtenshion(file.path),
        );
        dataMap['pictureDocuments[$i]'] = multipartFile;
      } catch (e) {
        CommonWidgets.showSnackBar(
          title: 'File Error',
          message: 'Skipped a file due to an error.',
        );
        continue;
      }
    }

    return dio.FormData.fromMap(dataMap);
  }
}
