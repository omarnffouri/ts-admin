import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/skeleton.dart';
import 'package:ts_admin/app/modules/shipment/presentation/shipments/views/components/shipments_loading_view.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_expanded_widget.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/glass_control.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/menu/controllers/menu_page_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../domain/enitities/shipment_entity.dart';
import '../controllers/shipments_controller.dart';
import 'components/expanded_card.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ShipmentsView extends GetView<ShipmentsController> {
  const ShipmentsView({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: primaryColor,
      floatingActionButton: const FloatingActionButton(),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 10,
              child: Column(
                children: [
                  _Header(
                    controller: controller,
                  ),
                  SizedBox(height: 6.h),
                  Expanded(
                    child: SmartRefresher(
                      controller: controller.refreshController,
                      header: const WaterDropMaterialHeader(),
                      onRefresh: controller.handleShipmentRefresh,
                      child: CustomScrollView(
                        controller: controller.scrollController,
                        slivers: [
                          Obx(
                            () => controller.isLoading.value
                                ? const SliverFillRemaining(
                                    child: ShipmentsLoadingView(),
                                  )
                                : controller.isSearching.value
                                    ? const SliverFillRemaining(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColorsLight.mainColor,
                                          ),
                                        ),
                                      )
                                    : controller.filterList.isEmpty
                                        ? const SliverFillRemaining(
                                            child: NoDataView(),
                                          )
                                        : SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                              (BuildContext context,
                                                  int index) {
                                                return ShipmentListItem(
                                                  index: index,
                                                );
                                              },
                                              childCount:
                                                  controller.filterList.length,
                                            ),
                                          ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(
                    child: controller.isHasMoreLoading.value
                        ? const Column(
                            children: [
                              LinearProgressIndicator(
                                color: AppColorsLight.mainColor,
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//! Header
class _Header extends StatelessWidget {
  final ShipmentsController controller;
  const _Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      padding: EdgeInsets.fromLTRB(10, topInset, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 6.w),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Shipments",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Get.theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        controller
                                .authController.user.value?.designation?.name ??
                            "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Get.theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.applyOpacity(0.82),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.authController.userPermissionHelper
                      .canResolveAdditionalPays(),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GlassControl(
                      icon: const Icon(
                        Icons.monetization_on_rounded,
                        color: Colors.white,
                      ),
                      onTap: () => Get.toNamed(Routes.ADDITIONAL_PAY),
                    ),
                  ),
                ),
              ),
              GlassControl(
                icon: Obx(
                  () => Icon(
                    controller.isSearchEnabled.value
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  controller.isSearchEnabled.value =
                      !controller.isSearchEnabled.value;
                },
              ),
              SizedBox(
                width: 8.w,
              ),
              GlassControl(
                icon: const Icon(
                  Icons.filter_list_alt,
                  color: Colors.white,
                ),
                onTap: () {
                  controller.showFiltersBottomSheet();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Obx(
            () => AnimatedSearchSection(
              expand: controller.isSearchEnabled.value,
            ),
          ),
        ],
      ),
    );
  }
}

//! Animated search section
class AnimatedSearchSection extends GetView<ShipmentsController> {
  const AnimatedSearchSection({
    super.key,
    required this.expand,
  });

  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AppExpandedWidget(
      expand: expand,
      expandController: controller.searchExpandedController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      // Bones, not a live field — search can't run before the
                      // first page lands.
                      ? Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                context.isDark ? Colors.white24 : Colors.white,
                          ),
                          child: const SkeletonBones(
                            child: Row(
                              children: [
                                SkeletonBone(width: 20, height: 20, radius: 10),
                                SizedBox(width: 12),
                                SkeletonBone(width: 90, height: 11, radius: 5),
                              ],
                            ),
                          ),
                        ).marginSymmetric(horizontal: 5)
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                context.isDark ? Colors.white24 : Colors.white,
                          ),
                          child: TextField(
                            onChanged: controller.handleSearchChange,
                            onTapOutside: (value) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            maxLines: 1,
                            controller: controller.txtSearchController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              icon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              suffixIcon: Obx(
                                () => controller.txtSearch.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          controller.txtSearchController
                                              .clear();
                                          controller.txtSearch.value = "";
                                          controller.getAllShipments();
                                        },
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ).marginSymmetric(horizontal: 5),
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, top: 6.h, bottom: 4.h),
            child: Obx(
              () => Text(
                '${controller.filterList.length} item${controller.filterList.length == 1 ? '' : 's'} found',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.white.applyOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//! Shipment List Item
class ShipmentListItem extends GetView<ShipmentsController> {
  const ShipmentListItem({
    super.key,
    required this.index,
  });
  final int index;

  /// Shared with the list skeleton so the two silhouettes can't drift.
  static BoxDecoration decoration(BuildContext context) {
    final bool isDark = context.isDark;
    return BoxDecoration(
      color: isDark ? Colors.white.applyOpacity(0.05) : Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        color: isDark
            ? Colors.white.applyOpacity(0.06)
            : Colors.black.applyOpacity(0.04),
      ),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: Colors.black.applyOpacity(0.2),
                blurRadius: 18,
                offset: const Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShipmentEntity shipment = controller.filterList[index];
    final bool isLast = index == controller.filterList.length - 1;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 18),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, isLast ? 40.h : 0),
        child: Container(
          decoration: decoration(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                splashColor: AppColorsLight.mainColor.applyOpacity(0.06),
                highlightColor: AppColorsLight.mainColor.applyOpacity(0.03),
                onTap: () {
                  Get.toNamed(Routes.SHIPMENT_DETAILS, arguments: shipment);
                },
                child: Obx(
                  () => ExpandedCard(
                    expand: shipment.isExpanded.value,
                    shipment: shipment,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//! Floating Action Button
class FloatingActionButton extends GetView<ShipmentsController> {
  const FloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    // get current tab from main MenuPageController
    final currentTab = Get.put(MenuPageController()).currentActiveTabIndex;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 65),
        child: AnimatedContainer(
          width: 50,
          height: 50,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.diagonal3Values(
            currentTab.value == 4 ? 1.0 : 0.0009,
            currentTab.value == 4 ? 1.0 : 0.0009,
            1,
          ),
          child: InkWell(
            onTap: () async {
              try {
                final bool created = await Get.toNamed(Routes.CREATE_SHIPMENT);
                if (created) {
                  controller.handleShipmentRefresh();
                }
              } catch (_) {}
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorsLight.mainColor,
              ),
              child: const Center(
                child: Icon(Icons.add_rounded, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
