import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/enums/filtering_enums.dart';
import 'package:ts_admin/app/modules/storage/presentation/sub_folder/controllers/sub_folder_controller.dart';

class SubFolderFiltersBottomSheet extends StatelessWidget {
  final SubFolderController controller;
  const SubFolderFiltersBottomSheet({
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
                "Filters",
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
          // resource type filter
          Text(
            "Type",
            style: textTheme.titleMedium,
          ).marginOnly(top: 20),

          //
          //
          // resource type filter options
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              buildResourceTypeFilterItem(ResourceTypeFilters.all),
              buildResourceTypeFilterItem(ResourceTypeFilters.files),
              buildResourceTypeFilterItem(ResourceTypeFilters.folders),
            ],
          ).marginOnly(top: 5),

          //
          //
          // resource ownership filter
          Text(
            "Ownership",
            style: textTheme.titleMedium,
          ).marginOnly(top: 20),

          //
          //
          // resource ownership filter options
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              buildResourceOwnershipFilterItem(ResourceOwnershipFilters.any),
              buildResourceOwnershipFilterItem(
                  ResourceOwnershipFilters.myResources),
              buildResourceOwnershipFilterItem(
                  ResourceOwnershipFilters.sharedWithOther),
              buildResourceOwnershipFilterItem(
                  ResourceOwnershipFilters.sharedByOthers),
            ],
          ).marginOnly(top: 5, bottom: 50)
        ],
      ),
    );
  }

  Widget buildResourceTypeFilterItem(ResourceTypeFilters type) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.resourceTypeFilter.value = type;
          controller.filterAndSortResources();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: controller.resourceTypeFilter.value == type
                ? AppColorsLight.mainColor
                : null,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: controller.resourceTypeFilter.value == type
                  ? AppColorsLight.mainColor
                  : Colors.grey,
            ),
          ),
          child: Text(
            type.name,
            style: TextStyle(
              color: controller.resourceTypeFilter.value == type
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

  Widget buildResourceOwnershipFilterItem(ResourceOwnershipFilters type) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.resourceOwnershipFilter.value = type;
          controller.filterAndSortResources();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: controller.resourceOwnershipFilter.value == type
                ? AppColorsLight.mainColor
                : null,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: controller.resourceOwnershipFilter.value == type
                  ? AppColorsLight.mainColor
                  : Colors.grey,
            ),
          ),
          child: Text(
            type.name,
            style: TextStyle(
              color: controller.resourceOwnershipFilter.value == type
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
