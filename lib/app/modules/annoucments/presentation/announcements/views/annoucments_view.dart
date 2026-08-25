import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/core/widgets/glass_control.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/annoucments_controller.dart';
import 'components/announcement_card.dart';

const EdgeInsets _kListPadding = EdgeInsets.fromLTRB(16, 14, 16, 112);

class AnnoucmentsView extends GetView<AnnoucmentsController> {
  const AnnoucmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool canCreate =
        Get.find<AuthController>().userPermissionHelper.isSuperAdmin();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButton: !canCreate
          ? null
          : SafeArea(
              minimum: const EdgeInsets.only(bottom: 8),
              child: FloatingActionButton.extended(
                heroTag: 'create_announcement',
                elevation: context.isDark ? 2 : 6,
                highlightElevation: 3,
                backgroundColor: context.floatingButtonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () async {
                  await Get.toNamed(Routes.CREATE_ANNOUNCEMENT);
                  controller.getAllAnnoucements();
                },
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  'New announcement'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SafeArea(
              top: false,
              child: SmartRefresher(
                controller: controller.refreshController,
                header: const WaterDropMaterialHeader(),
                onRefresh: controller.handleRefresh,
                child: CustomScrollView(
                  slivers: [
                    Obx(() => _buildContentSliver()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSliver() {
    final AnnoucmentsController c = controller;

    if (c.isLoadingAnnoucements) {
      return SliverPadding(
        padding: _kListPadding,
        sliver: SliverList.separated(
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const AnnouncementCardSkeleton(),
        ),
      );
    }

    if (c.annoucements.isEmpty && c.errorWhileLoadingAnnoucements.value) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          icon: Icons.cloud_off_rounded,
          title: 'Unable to load announcements',
          message: 'Something went wrong while loading announcements.',
          actionLabel: 'Try again',
          onAction: c.getAllAnnoucements,
        ),
      );
    }

    if (c.annoucements.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          icon: Icons.campaign_rounded,
          title: 'No announcements yet',
          message: 'New announcements will appear here once they are sent.',
        ),
      );
    }

    return SliverPadding(
      padding: _kListPadding,
      sliver: SliverList.separated(
        itemCount: c.annoucements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => AnnouncementCard(
          announcement: c.annoucements[index],
          index: index,
          controller: c,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.paddingOf(context).top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
          GlassControl(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onTap: Get.back,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Announcements'.tr,
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
