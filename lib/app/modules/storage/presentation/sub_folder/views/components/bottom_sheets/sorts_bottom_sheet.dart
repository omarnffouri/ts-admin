import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/enums/sorting_enums.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/sub_folder_controller.dart';

class SubFolderSortsBottomSheet extends StatelessWidget {
  final SubFolderController controller;
  const SubFolderSortsBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              // heading
              Text(
                "Sort By",
                style: textTheme.headlineSmall,
              ),

              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.close_rounded,
                  color: Get.isDarkMode ? Colors.white : theme.primaryColor,
                ),
              ),
            ],
          ),

          //
          //
          // resource date sort
          // Text(
          //   "By Date",
          //   style: textTheme.titleMedium,
          // ).marginOnly(top: 20),

          //
          //
          // resource date sorting options
          // Wrap(
          //   spacing: 10,
          //   runSpacing: 10,
          //   children: [
          //     buildResourceDateSortItem(ResourceSortByDate.newToOld),
          //     buildResourceDateSortItem(ResourceSortByDate.oldToNew),
          //   ],
          // ).marginOnly(top: 5),

          //
          //
          // resource name sort
          // Text(
          //   "By Name",
          //   style: textTheme.titleMedium,
          // ).marginOnly(top: 20),

          //
          //
          // resource name sorting options
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              buildResourceSortItem(ResourceSorts.newToOld),
              buildResourceSortItem(ResourceSorts.oldToNew),
              buildResourceSortItem(ResourceSorts.nameAZ),
              buildResourceSortItem(ResourceSorts.nameZA),
            ],
          ).marginOnly(top: 5, bottom: 50)
        ],
      ),
    );
  }

  Widget buildResourceSortItem(ResourceSorts type) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.resourceSortBy.value = type;
          controller.filterAndSortResources();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: controller.resourceSortBy.value == type
                ? AppColorsLight.mainColor
                : null,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: controller.resourceSortBy.value == type
                  ? AppColorsLight.mainColor
                  : Colors.grey,
            ),
          ),
          child: Text(
            type.name,
            style: TextStyle(
              color: controller.resourceSortBy.value == type
                  ? Colors.white
                  : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
