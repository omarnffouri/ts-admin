import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/core/widgets/shimmer_sliver_list.dart';

import '../controllers/leave_requests_history_controller.dart';
import 'components/leave_admin_filter.dart';
import 'components/leave_request_card.dart';
import 'components/leave_status_filter.dart';

class LeaveRequestsHistoryView extends GetView<LeaveRequestsHistoryController> {
  const LeaveRequestsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SafeArea(
              top: false,
              child: _BodyReveal(
                child: SmartRefresher(
                  controller: controller.refreshController,
                  header: const WaterDropMaterialHeader(),
                  onRefresh: controller.handleRefresh,
                  child: CustomScrollView(
                    slivers: [
                      Obx(_buildBodySlivers),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Header (summary + filters) is hidden while the first load is in flight.
  Widget _buildBodySlivers() {
    if (controller.isLoading.value) {
      return _buildLoadingSliver();
    }

    return SliverMainAxisGroup(
      slivers: [
        _buildHeaderSliver(),
        _buildContentSliver(),
      ],
    );
  }

  Widget _buildHeaderSliver() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummarySection(),
            const SizedBox(height: 20),
            _buildFiltersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSliver() {
    if (controller.requestedList.isEmpty) {
      return _buildEmptySliver(false);
    }

    if (controller.filterList.isEmpty) {
      return _buildEmptySliver(true);
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final request = controller.filterList[index];
            return Obx(
              () => LeaveRequestCard(
                key: ValueKey(request.id),
                request: request,
                index: index,
                isExpanded: controller.expandedRequestId.value == request.id,
                onExpanded: () {
                  if (controller.expandedRequestId.value == request.id) {
                    controller.expandedRequestId.value = null;
                  } else {
                    controller.expandedRequestId.value = request.id;
                  }
                },
              ),
            );
          },
          childCount: controller.filterList.length,
        ),
      ),
    );
  }

  Widget _buildLoadingSliver() {
    return const ShimmerSliverList(
      itemCount: 8,
      padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
      itemSpacing: 16,
    );
  }

  Widget _buildEmptySliver(bool isFiltered) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyStateView(
            icon: isFiltered ? Icons.search_off_rounded : Icons.history_rounded,
            title: isFiltered ? 'No Requests Found' : 'No Leave Requests',
            message: isFiltered
                ? 'Nothing matches your filters. Try adjusting them.'
                : 'Your leave request history will appear here.',
          ),
          if (isFiltered)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: TextButton.icon(
                onPressed: () {
                  controller.selectedStatus.value = 'All';
                  controller.selectedAdmin.value = 'All';
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Clear Filters'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Obx(() {
      if (controller.requestedList.isEmpty) {
        return const SizedBox.shrink();
      }

      final total = controller.requestedList.length;
      final approved = controller.requestedList
          .where((r) => r.status?.toLowerCase() == 'approved')
          .length;
      final rejected = controller.requestedList
          .where((r) => r.status?.toLowerCase() == 'rejected')
          .length;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? Colors.white.applyOpacity(0.04)
              : Colors.black.applyOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Get.isDarkMode
                ? Colors.white.applyOpacity(0.08)
                : Colors.black.applyOpacity(0.06),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('Total', total.toString()),
            const _Divider(),
            _buildSummaryItem('Approved', approved.toString(),
                color: Colors.green),
            const _Divider(),
            _buildSummaryItem('Rejected', rejected.toString(),
                color: Colors.red),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryItem(String label, String value, {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Get.theme.textTheme.labelLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Get.theme.textTheme.labelSmall?.copyWith(
            fontSize: 11,
            color: Get.isDarkMode
                ? Colors.white.applyOpacity(0.6)
                : Colors.black.applyOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Filters',
          style: Get.theme.textTheme.labelSmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? Colors.white.applyOpacity(0.6)
                : Colors.black.applyOpacity(0.5),
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: LeaveStatusFilter(),
            ),
            SizedBox(width: 12),
            Expanded(
              child: LeaveAdminFilter(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          final hasFilters = controller.selectedStatus.value != 'All' ||
              controller.selectedAdmin.value != 'All';

          if (!hasFilters) {
            return const SizedBox.shrink();
          }

          return Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                controller.selectedStatus.value = 'All';
                controller.selectedAdmin.value = 'All';
              },
              icon: const Icon(Icons.close_rounded, size: 16),
              label: const Text('Clear Filters'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _Header extends GetView<LeaveRequestsHistoryController> {
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
          _HeaderIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Get.back(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Requests History',
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
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
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

/// One-shot fade + slide reveal for the page content below the header.
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Get.isDarkMode
          ? Colors.white.applyOpacity(0.1)
          : Colors.black.applyOpacity(0.1),
    );
  }
}
