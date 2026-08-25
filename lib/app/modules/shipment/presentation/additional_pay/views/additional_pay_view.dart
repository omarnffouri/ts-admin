import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_expanded_widget.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/glass_control.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';

import 'package:ts_admin/app/core/enum/additional_pay_status.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/additional_pay_entity.dart';

import '../controllers/additional_pay_controller.dart';
import 'components/additional_pay_loading_view.dart';
import 'components/additional_pay_request_card.dart';

class AdditionalPayView extends GetView<AdditionalPayController> {
  const AdditionalPayView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Container(
        width: double.infinity,
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            _Header(controller: controller),
            SizedBox(height: 12.h),
            _StatusTabs(controller: controller),
            SizedBox(height: 4.h),
            Expanded(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: controller.isLoading.value
                      ? AdditionalPayLoadingView(
                          status: controller.selectedStatus.value,
                        )
                      : _RequestsList(controller: controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//! Request list
class _RequestsList extends StatelessWidget {
  const _RequestsList({required this.controller});

  final AdditionalPayController controller;

  @override
  Widget build(BuildContext context) {
    // SmartRefresher must wrap the scrollable directly.
    return Obx(
      () {
        final List<AdditionalPayEntity> items = controller.visible;
        final bool loadingMore = controller.isLoadingMore.value;
        return SmartRefresher(
          controller: controller.refreshController,
          header: const WaterDropMaterialHeader(),
          onRefresh: controller.handleRefresh,
          child: items.isEmpty
              ? const NoDataView()
              : ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.only(top: 2.h),
                  itemCount: items.length + (loadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const _LoadMoreIndicator();
                    }
                    final AdditionalPayEntity request = items[index];
                    return AdditionalPayRequestCard(
                      key: ValueKey(request.id),
                      request: request,
                      isLast: !loadingMore && index == items.length - 1,
                      onOpenShipment: () => controller.openShipment(request),
                      onApprove: () =>
                          controller.showActionSheet(request, isApprove: true),
                      onReject: () =>
                          controller.showActionSheet(request, isApprove: false),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 40.h),
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppColorsLight.mainColor,
          ),
        ),
      ),
    );
  }
}

//! Header
class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final AdditionalPayController controller;

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      padding: EdgeInsets.fromLTRB(10, topInset, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              GlassControl(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
                onTap: Get.back,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Additional Pay',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Obx(
                      () {
                        final AdditionalPayStatus s =
                            controller.selectedStatus.value;
                        final String suffix = s == AdditionalPayStatus.pending
                            ? 'awaiting review'
                            : s.label.toLowerCase();
                        return Text(
                          controller.isLoading.value
                              ? 'Loading requests…'
                              : '${controller.selectedCount} $suffix',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.applyOpacity(0.82),
                                    fontWeight: FontWeight.w500,
                                  ),
                        );
                      },
                    ),
                  ],
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
            ],
          ),
          Obx(
            () => AppExpandedWidget(
              expand: controller.isSearchEnabled.value,
              expandController: controller.searchExpandedController,
              child: _SearchSection(controller: controller),
            ),
          ),
        ],
      ),
    );
  }
}

//! Search section
class _SearchSection extends StatelessWidget {
  const _SearchSection({required this.controller});

  final AdditionalPayController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Get.isDarkMode ? Colors.white24 : Colors.white,
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
              hintText: 'Search driver, truck, or shipment',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: Obx(
                () => controller.txtSearch.isNotEmpty
                    ? GestureDetector(
                        onTap: controller.clearSearch,
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
        Padding(
          padding: EdgeInsets.only(left: 8.w, top: 6.h, bottom: 4.h),
          child: Obx(
            () {
              final int found = controller.visible.length;
              return Text(
                '$found request${found == 1 ? '' : 's'} found',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.white.applyOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//! Status filter tabs
class _StatusTabs extends StatelessWidget {
  const _StatusTabs({required this.controller});

  final AdditionalPayController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Obx(
        () {
          // Counts unknown only on the very first load — skeleton then.
          if (controller.isLoading.value && controller.statusCounts.isEmpty) {
            return const AdditionalPayTabsSkeleton();
          }
          final AdditionalPayStatus selected = controller.selectedStatus.value;
          return Row(
            children: AdditionalPayStatus.values.map((status) {
              final bool isSelected = selected == status;
              // API's statusCounts — every tab shows its total.
              final int? count = controller.statusCounts[status];

              return Padding(
                padding: EdgeInsets.only(
                  right: status == AdditionalPayStatus.values.last ? 0 : 8.w,
                ),
                child: _StatusTab(
                  status: status,
                  count: count,
                  isSelected: isSelected,
                  onTap: () => controller.selectStatus(status),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({
    required this.status,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final AdditionalPayStatus status;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            color: context.flatCardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: isSelected ? 1.4 : 1,
              color: isSelected
                  ? status.color
                  : isDark
                      ? Colors.white.applyOpacity(0.08)
                      : Colors.black.applyOpacity(0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: status.color.applyOpacity(0.14),
                ),
                child: Icon(status.icon, size: 16, color: status.color),
              ),
              SizedBox(width: 8.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.label,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textTheme.bodySmall?.color?.applyOpacity(0.75),
                    ),
                  ),
                  if (count != null)
                    Text(
                      '$count',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
