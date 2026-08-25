import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/pdf_files_manager.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:ts_admin/app/core/widgets/pdf_render.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    super.key,
    required this.title,
    required this.path,
    this.file,
    required this.fileLoaded,
    this.downloadable = false,
  });
  final String title;
  final String path;
  final File? file;
  final Function() fileLoaded;
  final bool downloadable;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  Future<bool> checkInternetConnectivity() async {
    InternetConnectionStatus connectivityResult =
        await InternetConnectionChecker().connectionStatus;
    return connectivityResult != InternetConnectionStatus.disconnected;
  }

  final PdfFilesManager pdfFilesManager = PdfFilesManager();

  final isDownloading = false.obs;
  final downloadProgress = (0.0).obs;

  @override
  Widget build(BuildContext context) {
    log('PdfViewer ${widget.path}');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColorsLight.mainColor,
            AppColorsLight.mainColor,
          ],
          stops: [0.0, 1.0],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: Get.theme.textTheme.titleMedium
                  ?.copyWith(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Get.theme.primaryColor,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              if (widget.downloadable)
                Obx(
                  () => isDownloading.value
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: Obx(
                            () => CircularProgressIndicator(
                              value: downloadProgress.value,
                              color: Colors.white,
                              strokeCap: StrokeCap.round,
                              strokeWidth: 4,
                            ),
                          ),
                        ).marginOnly(right: 15)
                      : IconButton(
                          onPressed: () {
                            downloadPdf();
                          },
                          icon: const Icon(
                            Icons.download_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                )
            ],
          ),
          body: PdfRender(
            file: widget.file,
            url: widget.path,
            onReady: widget.fileLoaded,
          ),
        ),
      ),
    );
  }

  downloadPdf() async {
    try {
      //
      // setting downloading true
      isDownloading.value = true;

      //
      //
      // downloading file and updating download progress from callback
      final filePath = await pdfFilesManager.getDocumentFile(
        widget.path,
        onReceiveProgress: (received, total) {
          isDownloading.value = true;
          downloadProgress.value = received / total;
        },
        onFailure: (message) {
          CommonWidgets.showSnackBar(title: "Error", message: message);
        },
      );

      //
      //
      // resetting downlod progress and states etc
      isDownloading.value = false;
      downloadProgress.value = 0.0;

      //
      // if file exist then open that file
      if (filePath != null) {
        await FileOpener.openFile(filePath);
      }
    } catch (_) {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }
}
