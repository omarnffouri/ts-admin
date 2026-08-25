import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/pdf_render.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../../domain/entities/vehicle_details_entity.dart';
import '../../domain/entities/vehicle_file.dart';

class UpdateVehicleDocumentButtomsheet extends StatelessWidget {
  const UpdateVehicleDocumentButtomsheet({
    super.key,
    required this.document,
    required this.isUploading,
    required this.onPressed,
    required this.currentUpdatingDocument,
  });
  final DocumentDto document;
  final RxBool isUploading;
  final void Function() onPressed;
  final Rxn<VehicleFile> currentUpdatingDocument;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FileItemView(
            document: document,
            currentUpdatingDocument: currentUpdatingDocument,
          ),
          const SizedBox(height: 16),
          Obx(
            () => MainAppButton(
              label: "Update",
              isLoading: isUploading.value,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _FileItemView extends StatelessWidget {
  const _FileItemView({
    required this.document,
    required this.currentUpdatingDocument,
  });
  final DocumentDto document;
  final Rxn<VehicleFile> currentUpdatingDocument;
  static const imageExtensions = ['jpg', 'jpeg', 'png'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Obx(() {
        final updateDoc = currentUpdatingDocument.value;
        final path = updateDoc?.file?.path;
        final extension = path?.split('.').last.toLowerCase() ?? '';
        final isImage = imageExtensions.contains(extension);

        return Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: updateDoc == null
                    ? () => showFilePickerAttachmentBottomSheet(document)
                    : null,
                child: _buildFileView(updateDoc, path, extension, isImage),
              ),
            ),
            if (updateDoc != null)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    currentUpdatingDocument.value = null;
                  },
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildFileView(
    dynamic updateDoc,
    String? path,
    String extension,
    bool isImage,
  ) {
    final extension = path?.split('.').last ?? '';
    const imageExtensions = ['jpg', 'jpeg', 'png'];
    final isImage = imageExtensions.contains(extension.toLowerCase());
    final fileExtensionHelper = FileExtensionHelper();
    final fileName = fileExtensionHelper.getFileName(
      path ?? document.collectionName ?? 'file',
      withExtension: true,
    );

    return Container(
      margin: const EdgeInsets.only(right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (updateDoc == null) const Icon(Icons.add_rounded, size: 50),
          if (isImage && path != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(path),
                width: 80,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          if (extension == 'pdf' && path != null)
            Container(
              margin: const EdgeInsets.all(4),
              height: 60,
              child: PdfRender(file: File(path)),
            ),
          const SizedBox(height: 4),
          Text(
            updateDoc == null ? "Add File" : fileName,
            style: Get.textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void showFilePickerAttachmentBottomSheet(DocumentDto document) {
    MediaPicker.showAttachmentBottomSheet(
      onGalleryPicked: (files) {
        if (files.isEmpty) {
          return;
        }

        currentUpdatingDocument.value = VehicleFile(
          file: files.first,
          document: document,
        );
      },
      onDocumentPicked: (files) {
        if (files.isEmpty) {
          return;
        }
        currentUpdatingDocument.value = VehicleFile(
          file: files.first,
          document: document,
        );
      },
      onCameraPicked: (file) {
        if (file != null) {
          currentUpdatingDocument.value = VehicleFile(
            file: file,
            document: document,
          );
        }
      },
    );
  }
}
