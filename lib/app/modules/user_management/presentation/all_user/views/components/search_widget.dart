import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

import '../../controllers/all_user_controller.dart';

class SearchWidget extends GetView<AllUserController> {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color idleBorderColor = isDark
        ? Colors.white.applyOpacity(0.08)
        : Colors.black.applyOpacity(0.06);

    final idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: idleBorderColor),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: isDark ? Colors.white.applyOpacity(0.3) : theme.primaryColor,
        width: 1.4,
      ),
    );

    return Obx(
      () => controller.isLoading.value
          ? Shimmer.fromColors(
              baseColor: isDark ? Colors.white10 : Colors.black12,
              highlightColor: isDark ? Colors.white24 : Colors.white30,
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.cardColor,
                  isDense: true,
                  hintText: 'Search users',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: Icon(Icons.search_rounded,
                      size: 20, color: theme.hintColor),
                  border: idleBorder,
                  enabledBorder: idleBorder,
                  focusedBorder: focusedBorder,
                ),
              ),
            )
          : TextFormField(
              onChanged: controller.handleSearchChange,
              controller: controller.txtSearchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.cardColor,
                isDense: true,
                hintText: 'Search users',
                hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                prefixIcon: Icon(Icons.search_rounded,
                    size: 20, color: theme.hintColor),
                suffixIcon: Obx(
                  () => controller.txtSearch.isNotEmpty
                      ? IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            controller.txtSearchController.clear();
                            controller.txtSearch.value = "";
                            controller.getAllUsers();
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                border: idleBorder,
                enabledBorder: idleBorder,
                focusedBorder: focusedBorder,
              ),
            ),
    );
  }
}
