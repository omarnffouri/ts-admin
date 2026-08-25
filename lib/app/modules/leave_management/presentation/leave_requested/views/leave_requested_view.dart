import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/core/widgets/shimmer_sliver_list.dart';

import '../controllers/leave_requested_controller.dart';
import 'components/leave_request_card.dart';
import 'components/leave_status_filter.dart';

class LeaveRequestedView extends GetView<LeaveRequestedController> {
  const LeaveRequestedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            // Header
            const _Header(),

            // Body
            Expanded(
              child: SafeArea(
                top: false,
                child: _BodyReveal(
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      const _FilterSection(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SmartRefresher(
                          controller: controller.refreshController,
                          header: const WaterDropMaterialHeader(),
                          onRefresh: controller.handleRefresh,
                          child: CustomScrollView(
                            slivers: [
                              Obx(_buildContentSliver),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSliver() {
    if (controller.isLoading.value) {
      return _buildLoadingSliver();
    }

    if (controller.filterList.isEmpty) {
      final bool isFiltering =
          controller.selectedStatus.value != controller.statusOptions.first;

      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          icon: isFiltering
              ? Icons.filter_list_off_rounded
              : Icons.calendar_today_rounded,
          title: "No leave requests found",
          message: isFiltering
              ? "Nothing matches your status filter. Try adjusting it."
              : "Your leave requests will appear here as you submit them.",
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final request = controller.filterList[index];
            return LeaveRequestCard(
              request: request,
              index: index,
              totalCount: controller.filterList.length,
            );
          },
          childCount: controller.filterList.length,
        ),
      ),
    );
  }

  Widget _buildLoadingSliver() {
    return const ShimmerSliverList(itemCount: 6);
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.back(),
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
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Leave Requests",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends GetView<LeaveRequestedController> {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LeaveStatusFilter(
        selectedStatus: controller.selectedStatus,
        statusOptions: controller.statusOptions,
        onStatusChanged: (status) {
          controller.selectedStatus.value = status;
        },
      ),
    );
  }
}

class _BodyReveal extends StatelessWidget {
  const _BodyReveal({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
