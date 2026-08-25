import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/widgets/pdf_render.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/pdf_viewer.dart';

import '../../domain/entities/service_order_entity.dart';

class FilesListView extends StatelessWidget {
  const FilesListView({super.key, required this.files});
  final List<FileElementEntity> files;

  @override
  Widget build(BuildContext context) {
    if (files.length < 2) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ListView.builder(
          itemCount: files.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            // get the extension of the file
            final path = files[index].url;
            final extension = path?.split('.').last ?? '';
            // check if the file is a pdf
            if (extension == 'pdf') {
              return Container(
                margin: const EdgeInsets.all(5),
                height: Get.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PdfRender(url: path ?? ''),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => PdfViewer(
                              title: files[index].fileName ?? '',
                              path: path ?? '',
                              fileLoaded: () {},
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColorsLight.mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Show PDF',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return InkWell(
              onTap: () {
                showImageDialog(
                  context,
                  files[index].url ?? '',
                  title: files[index].fileName,
                );
              },
              child: CachedNetworkImage(
                imageUrl: files[index].url ?? '',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.black12,
                    highlightColor: Colors.white30,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      margin:
                          const EdgeInsets.only(top: 14, left: 14, right: 14),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.white10 : Colors.black12,
          borderRadius: BorderRadius.circular(5),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: files.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // get the extension of the file
            final path = files[index].url;
            final extension = path?.split('.').last ?? '';
            // check if the file is a pdf or image
            if (extension == 'pdf') {
              return Container(
                margin: const EdgeInsets.all(5),
                height: Get.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PdfRender(url: path ?? ''),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => PdfViewer(
                              title: files[index].fileName ?? '',
                              path: path ?? '',
                              fileLoaded: () {},
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColorsLight.mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Show PDF',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return InkWell(
              onTap: () {
                showImageDialog(
                  context,
                  files[index].url ?? '',
                  title: files[index].fileName,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                height: Get.height * 0.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: CachedNetworkImage(
                  imageUrl: files[index].url ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.black12,
                      highlightColor: Colors.white30,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        margin:
                            const EdgeInsets.only(top: 14, left: 14, right: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
