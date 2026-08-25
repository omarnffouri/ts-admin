import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/pdf_render.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../../../../domain/entities/vehicle_file.dart';
import '../../controllers/truck_details_controller.dart';

class UploadPicturesButtomsheet extends GetView<TruckDetailsController> {
  const UploadPicturesButtomsheet({
    super.key,
    required this.uploadTruckPictures,
  });
  final RxList<VehicleFile> uploadTruckPictures;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                mainAxisExtent: 100,
              ),
              shrinkWrap: true,
              primary: false,
              itemCount: controller.uploadTruckPictures.length,
              itemBuilder: (context, index) {
                final file = controller.uploadTruckPictures.elementAt(index);

                return _FileItemView(
                  file: file.obs,
                  uploadTruckPictures: controller.uploadTruckPictures,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => MainAppButton(
              label: "Upload",
              isLoading: controller.isUploading.value,
              onPressed: () {
                if (controller.isUploading.value) {
                  return;
                }
                controller.uploadPictures();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FileItemView extends StatelessWidget {
  const _FileItemView({required this.file, required this.uploadTruckPictures});
  static const imageExtensions = ['jpg', 'jpeg', 'png'];
  final Rx<VehicleFile> file;
  final RxList<VehicleFile> uploadTruckPictures;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final path = file.value.file?.path;
      final extension = path?.split('.').last.toLowerCase() ?? '';
      final isImage = imageExtensions.contains(extension);

      return SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: file.value.isAdded == false
                    ? () {
                        showUploadPicturesAttachmentBottomSheet(
                          uploadTruckPictures,
                        );
                      }
                    : null,
                child: _buildFileView(file.value, path, extension, isImage),
              ),
            ),
            if (file.value.isAdded == true)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    uploadTruckPictures.remove(file.value);
                  },
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFileView(
    VehicleFile file,
    String? path,
    String extension,
    bool isImage,
  ) {
    final extension = path?.split('.').last ?? '';
    const imageExtensions = ['jpg', 'jpeg', 'png'];
    final isImage = imageExtensions.contains(extension.toLowerCase());
    final fileExtensionHelper = FileExtensionHelper();
    final fileName = fileExtensionHelper.getFileName(
      path ?? 'file',
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (file.isAdded == false) const Icon(Icons.add_rounded, size: 50),
          if (isImage && path != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Image.file(
                  File(path),
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (extension == 'pdf' && path != null)
            Container(
              margin: const EdgeInsets.all(4),
              height: 60,
              child: PdfRender(file: File(path)),
            ),
          Text(
            file.isAdded == false ? "Add File" : fileName,
            style: Get.textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void showUploadPicturesAttachmentBottomSheet(
    List<VehicleFile> pictures,
  ) {
    MediaPicker.showAttachmentBottomSheet(
      onGalleryPicked: (files) {
        if (files.isEmpty) {
          return;
        }
        if (pictures.isNotEmpty) {
          pictures.removeLast();
        }
        pictures.addAll(
          files.map(
            (item) => VehicleFile(isAdded: true, file: item),
          ),
        );
        pictures.add(VehicleFile(isAdded: false, file: File("")));
      },
      onDocumentPicked: (files) {
        if (files.isEmpty) {
          return;
        }
        if (pictures.isNotEmpty) {
          pictures.removeLast();
        }
        pictures.addAll(
          files.map(
            (item) => VehicleFile(isAdded: true, file: item),
          ),
        );
        pictures.add(VehicleFile(isAdded: false, file: File("")));
      },
      onCameraPicked: (file) {
        if (file != null) {
          if (pictures.isNotEmpty) {
            pictures.removeLast();
          }
          pictures.add(VehicleFile(isAdded: true, file: file));
          pictures.add(VehicleFile(isAdded: false, file: File("")));
        }
      },
    );
  }
}
