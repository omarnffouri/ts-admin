import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';

import '../../controllers/service_orders_controller.dart';

class ServiceOrdersHeader extends GetView<ServiceOrdersController> {
  const ServiceOrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.paddingOf(context).top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Back',
                onTap: Get.back,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Service Orders'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => _HeaderIconButton(
                  icon: controller.isSearchEnabled.value
                      ? Icons.search_off_rounded
                      : Icons.search_rounded,
                  tooltip: controller.isSearchEnabled.value
                      ? 'Hide search'
                      : 'Search service orders',
                  onTap: () => controller.isSearchEnabled.toggle(),
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => _HeaderIconButton(
                  icon: Icons.filter_list_alt,
                  tooltip: 'Filter service orders',
                  showIndicator: controller.isAnyFilterSelected.value,
                  onTap: controller.showFiltersBottomSheet,
                ),
              ),
            ],
          ),
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: controller.isSearchEnabled.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _HeaderSearchField(controller: controller),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSearchField extends StatelessWidget {
  const _HeaderSearchField({required this.controller});

  final ServiceOrdersController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            color: Colors.white.applyOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.applyOpacity(0.20),
            ),
          ),
          child: TextField(
            controller: controller.txtSearchController,
            maxLines: 1,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              hintText: 'Search by order type'.tr,
              hintStyle: TextStyle(
                color: Colors.white.applyOpacity(0.70),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: Colors.white.applyOpacity(0.82),
              ),
              suffixIcon: Obx(
                () => controller.txtSearch.value.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: controller.txtSearchController.clear,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.white.applyOpacity(0.82),
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () {
            final int count = controller.filterList.length;
            return Text(
              '$count ${count == 1 ? 'order' : 'orders'} found',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.applyOpacity(0.82),
                    fontWeight: FontWeight.w500,
                  ),
            );
          },
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.showIndicator = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: Colors.white.applyOpacity(0.16),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.applyOpacity(0.22),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(child: Icon(icon, size: 20, color: Colors.white)),
                  if (showIndicator)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
