import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:ts_admin/app/core/helpers/file_helpers/chat_videos_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_opener.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/common_widget.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ChatVideoPlayer extends StatefulWidget {
  ChatVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
    this.videoFile,
    FileManager? fileManager,
  }) : fileManager = fileManager ?? Get.find<ChatVideosManager>();

  final String videoUrl;
  File? videoFile;
  final String title;
  FileManager fileManager;

  @override
  State<ChatVideoPlayer> createState() => _ChatVideoPlayerState();
}

class _ChatVideoPlayerState extends State<ChatVideoPlayer> {
  late VideoPlayerController _controller;

  final isError = false.obs;
  final isLoading = true.obs;
  final isDownloading = false.obs;
  final downloadProgress = (0.0).obs;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  void initializeVideo() {
    if (widget.videoFile != null) {
      _controller = VideoPlayerController.file(widget.videoFile!)
        ..initialize().then((_) {
          isLoading.value = false;
          setState(() {});
        }).catchError((error) {
          handleError(error);
        });
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          isLoading.value = false;
          setState(() {});
        }).catchError((error) {
          handleError(error);
        });
    }

    _controller.addListener(() {
      if (_controller.value.hasError) {
        handleError(_controller.value.errorDescription);
      }
    });
  }

  void handleError(String? error) {
    isLoading.value = false;
    isError.value = true;
    debugPrint("VideoPlayer Error: $error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 70,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color: Colors.white,
            )),
        actions: [
          if (widget.videoFile != null || widget.videoUrl.isNotEmpty)
            Obx(
              () => isDownloading.value
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(downloadProgress.value * 100).toStringAsFixed(2)} %",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ).marginOnly(right: 5),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            value: downloadProgress.value,
                            color: Colors.white,
                            strokeCap: StrokeCap.round,
                            strokeWidth: 4,
                          ),
                        ),
                      ],
                    ).marginOnly(right: 15)
                  : IconButton(
                      onPressed: () {
                        try {
                          if (widget.videoFile != null) {
                            FileOpener.openFile(widget.videoFile!.path);
                          } else {
                            downloadVideo();
                          }
                        } catch (_) {}
                      },
                      icon: const Icon(
                        Icons.download_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
            ),
        ],
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Obx(
              () => Container(
                color: Colors.black,
                child: isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColorsLight.mainColor,
                        ),
                      )
                    : isError.value
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Error while loading the video",
                                style: Get.theme.textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : _controller.value.isInitialized
                            ? Chewie(
                                controller: ChewieController(
                                  allowedScreenSleep: false,
                                  videoPlayerController: _controller,
                                  autoPlay: true,
                                  looping: false,
                                  showOptions: true,
                                  showControls: true,
                                  allowFullScreen: true,
                                  showControlsOnInitialize: true,
                                  deviceOrientationsOnEnterFullScreen: [
                                    DeviceOrientation.landscapeLeft,
                                    DeviceOrientation.landscapeRight,
                                  ],
                                  routePageBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondAnimation,
                                    provider,
                                  ) {
                                    return AnimatedBuilder(
                                      animation: animation,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Scaffold(
                                          resizeToAvoidBottomInset: false,
                                          body: Container(
                                            alignment: Alignment.center,
                                            color: Colors.black,
                                            child: provider,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  materialProgressColors: ChewieProgressColors(
                                    playedColor: AppColorsLight.mainColor,
                                  ),
                                  cupertinoProgressColors: ChewieProgressColors(
                                    playedColor: AppColorsLight.mainColor,
                                  ),
                                  deviceOrientationsAfterFullScreen: [
                                    DeviceOrientation.portraitUp,
                                  ],
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Video not available",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> downloadVideo() async {
    try {
      //
      //
      // check if video already exist in system then open from
      // systems instead of downloading new one
      final file = await widget.fileManager.getFile(
        widget.fileManager.getFileName(
          widget.videoUrl,
          withExtension: true,
        ),
      );

      if (file != null) {
        widget.videoFile = file;
        FileOpener.openFile(file.path);
        return;
      }

      //
      // setting downloading true
      isDownloading.value = true;
      //
      //
      // downloading file and updating download progress from callback
      final filePath = await widget.fileManager.downloadFile(
        widget.videoUrl,
        onReceiveProgress: (received, total) {
          downloadProgress.value = (received / total);
        },
        onFailure: (message) {
          CommonWidgets.showSnackBar(
            title: "Error",
            message: "Something went wrong while downloading",
          );
        },
      );

      //
      //
      // resetting download progress and states etc
      isDownloading.value = false;
      downloadProgress.value = 0.0;

      //
      // if file exist then open that file
      if (filePath != null) {
        if ((await widget.fileManager.fileExist(widget.fileManager.getFileName(
          filePath,
          withExtension: true,
        )))) {
          widget.videoFile = File(filePath);
          await FileOpener.openFile(filePath);
        }
      }
    } catch (_) {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
