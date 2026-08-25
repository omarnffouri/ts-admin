import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

class PermissionInfoDialog extends StatelessWidget {
  final Permission permissionCode;
  final String message;
  final PermissionStatus permissionStatus;
  final String openSettingText;
  final Function? onOpenSettingsClick;

  const PermissionInfoDialog(
      {super.key,
      required this.permissionCode,
      required this.message,
      required this.permissionStatus,
      this.openSettingText = "Open App Settings",
      this.onOpenSettingsClick});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String permissionName = "Permission";
    String permissionIcon = Assets.images.accessibilityIcon.path;

    switch (permissionCode) {
      case Permission.camera:
        permissionName = "Camera";
        permissionIcon = Assets.images.cameraIcon.path;
        break;

      case Permission.microphone:
        permissionName = "Microphone";
        permissionIcon = Assets.images.micIcon.path;
        break;

      case Permission.location:
        permissionName = "Location";
        permissionIcon = Assets.images.locationIcon.path;
        break;

      case Permission.photos:
        permissionName = "Photos";
        permissionIcon = Assets.images.photosIcon.path;
        break;

      case Permission.storage:
        permissionName = "Storage";
        permissionIcon = Assets.images.foldersIcon.path;
        break;

      case Permission.mediaLibrary:
        permissionName = "Media Library";
        permissionIcon = Assets.images.musicIcon.path;
        break;
    }

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? const Color(0xff82858A) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Get.isDarkMode ? Colors.black87 : Colors.grey,
                //     spreadRadius: 5,
                //     blurRadius: 10,
                //   )
                // ],
              ),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  //
                  // close icon

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  //
                  Text(
                    "$permissionName Permission",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Get.isDarkMode
                          ? Colors.white
                          : AppColorsLight.mainColor,
                    ),
                  ),

                  Text(
                    message,
                    style: theme.textTheme.bodyLarge,
                  ).marginOnly(top: 8, left: 20, right: 20),

                  //
                  //
                  // ios permission image and animation
                  if (permissionCode == Permission.location && Platform.isIOS)
                    Stack(
                      children: [
                        //
                        //
                        // location image
                        Image.asset(
                          Assets.images.locationPermissionIos.path,
                        ),

                        Positioned(
                          bottom: -40,
                          left: 0,
                          right: 0,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Lottie.asset(
                              Assets.jsons.pointingAnimation,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        )
                      ],
                    ).marginOnly(top: 10),

                  //
                  //
                  // android permission image and animation
                  if (permissionCode == Permission.location &&
                      Platform.isAndroid)
                    Stack(
                      children: [
                        //
                        //
                        // location image
                        Image.asset(
                          Assets.images.locationPermissionAndroid.path,
                          height: 300,
                        ),

                        Positioned(
                          top: 75,
                          right: 50,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Lottie.asset(
                              Assets.jsons.pointingAnimation,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        )
                      ],
                    ).marginOnly(top: 10),

                  //
                  //
                  //
                  // open app setting button
                  Row(
                    children: [
                      Expanded(
                        child: MainAppButton(
                          label: openSettingText,
                          onPressed: () {
                            Get.back();
                            if (onOpenSettingsClick != null) {
                              onOpenSettingsClick!();
                            } else {
                              openAppSettings();
                            }
                          },
                        ),
                      ),
                    ],
                  ).marginSymmetric(horizontal: 14, vertical: 8),
                ],
              ),
            ),

            //
            //
            // permission icon
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Image.asset(
                  permissionIcon,
                  width: 50,
                  height: 50,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
