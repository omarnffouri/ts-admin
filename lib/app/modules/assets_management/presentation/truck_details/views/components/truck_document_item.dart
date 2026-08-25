import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/media_picker/media_picker.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../controllers/truck_details_controller.dart';

class TruckDocumentItem extends GetView<TruckDetailsController> {
  const TruckDocumentItem({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme.textTheme;
    final document = controller.truckDocuments[index];
    return Stack(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown
              Expanded(
                child: ValueListenableBuilder<String?>(
                  valueListenable: document.selectedTypeNotifier,
                  builder: (_, value, __) {
                    return DropdownButtonFormField<String>(
                      initialValue: value,
                      hint: const Text('Select Document Type'),
                      items: controller.documentTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.formatCollectionType()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        document.selectedTypeNotifier.value = newValue;
                        document.selectedCollectionType.value = newValue!;
                      },
                      focusColor: Colors.grey,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              // File area
              SizedBox(
                width: 80,
                height: double.infinity,
                child: Obx(() {
                  final file = document.selectedFile.value;

                  if (file != null) {
                    final extension = file.path?.split('.').last ?? '';
                    const imageExtensions = ['jpg', 'jpeg', 'png'];
                    final isImage =
                        imageExtensions.contains(extension.toLowerCase());

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (isImage && file.path != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(file.path!),
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade100,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.insert_drive_file,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    file.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Visibility(
                          visible:
                              index != controller.truckDocuments.length - 1,
                          child: Positioned(
                            bottom: -4,
                            right: -2,
                            child: GestureDetector(
                              onTap: () {
                                document.selectedFile.value = null;
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.delete,
                                    size: 16, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // 🟨 Make "Select File" button take full height
                    return InkWell(
                      onTap: () async {
                        final doc = await MediaPicker.pickSingleFile();
                        if (doc != null) {
                          document.selectedFile.value = doc;
                        }
                      },
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                          color: Get.isDarkMode ? Colors.grey.shade100 : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Select File',
                              style: theme.bodyMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            const Icon(Icons.add_box, color: Colors.black),
                          ],
                        ),
                      ),
                    );
                  }
                }),
              ),
              const SizedBox(width: 8),
              if (index != controller.truckDocuments.length - 1)
                GestureDetector(
                  onTap: () {
                    document.selectedFile.value = null;
                    controller.removeTruckDocument(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black54 : null,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.delete_sharp,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
              if (index == controller.truckDocuments.length - 1)
                InkWell(
                  onTap: () {
                    controller.addTruckDocument();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black54 : null,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
