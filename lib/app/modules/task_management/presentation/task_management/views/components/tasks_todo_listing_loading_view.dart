// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/controllers/task_management_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class TasksListingLoadingView extends GetView<TaskManagementController> {
  final String headerTitle;
  final String bodyTitle;
  const TasksListingLoadingView({
    super.key,
    required this.headerTitle,
    required this.bodyTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UpCommingLoadingView(
          upcomingHeading: headerTitle,
        ).marginOnly(top: 10),
        Expanded(
            child: _AllLoadingView(
          allHeading: bodyTitle,
        ).marginOnly(top: 10)),
      ],
    );
  }
}

class _UpCommingLoadingView extends GetView<TaskManagementController> {
  final String upcomingHeading;
  const _UpCommingLoadingView({required this.upcomingHeading});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor:
          Get.isDarkMode ? AppColorsDark.shimmerBaseColor : Colors.black12,
      highlightColor: Colors.white30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          // upcoming heading
          Text(
            upcomingHeading,
            style: theme.textTheme.headlineSmall,
          ).marginOnly(left: 14),

          //
          //
          // upcoming delines list
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                //
                //
                // item view
                return Container(
                  margin: EdgeInsets.only(
                    left: Get.isDarkMode ? 15 : 20,
                    top: 10,
                    bottom: 10,
                  ),
                  padding: const EdgeInsets.all(10),
                  width: Get.width * 0.60,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.grey.applyOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _AllLoadingView extends GetView<TaskManagementController> {
  final String allHeading;
  const _AllLoadingView({required this.allHeading});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor:
          Get.isDarkMode ? AppColorsDark.shimmerBaseColor : Colors.black12,
      highlightColor: Colors.white30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          // todos heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                allHeading,
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                "view all",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColorsLight.mainColor,
                ),
              )
            ],
          ).marginSymmetric(horizontal: 14),

          // Divider(
          //   color: Colors.grey.applyOpacity(0.3),
          //   thickness: 0.5,
          //   height: 5,
          // ).marginSymmetric(horizontal: 14),

          //
          //
          // todos list
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                //
                //
                // item view
                return Container(
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 10,
                    right: 10,
                    bottom: index == 9 ? 100 : 0,
                  ),
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.grey.applyOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Get.isDarkMode
                        ? null
                        : Border.all(
                            color: Colors.grey.applyOpacity(0.3),
                          ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
