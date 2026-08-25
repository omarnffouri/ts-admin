import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../trucks/views/components/trucks_loading_view.dart';
import '../controllers/trailers_controller.dart';
import 'components/trailers_body.dart';
import 'components/trailers_empty_state.dart';
import 'components/trailers_search_and_filter.dart';

class TrailersView extends GetView<TrailersController> {
  const TrailersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          heroTag: 'create_trailer',
          tooltip: 'Add trailer',
          elevation: context.isDark ? 2 : 6,
          highlightElevation: 3,
          backgroundColor: context.floatingButtonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onPressed: () => Get.toNamed(Routes.CREATE_TRAILER),
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'Add trailer'.tr,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            AppRedHeader(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
              child: Row(
                children: [
                  Semantics(
                    button: true,
                    label: 'Back'.tr,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: Get.back,
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
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'All Trailers'.tr,
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
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    const TrailersSearchAndFilter(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SlidableAutoCloseBehavior(
                        child: SmartRefresher(
                          controller: controller.refreshController,
                          header: const WaterDropMaterialHeader(),
                          onRefresh: controller.handleRefresh,
                          child: CustomScrollView(
                            controller: controller.scrollController,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            slivers: [
                              Obx(_buildContentSliver),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
      return const TrucksLoadingView();
    }

    if (controller.trailers.isEmpty) {
      final bool isSearching = controller.txtSearch.value.isNotEmpty;
      final bool isFiltering =
          controller.selectedStatus.value.toLowerCase() != 'all';

      return SliverFillRemaining(
        hasScrollBody: false,
        child: TrailersEmptyState(
          isSearching: isSearching,
          isFiltering: isFiltering,
          onAddTrailer: () => Get.toNamed(Routes.CREATE_TRAILER),
          onClearSearch: () {
            controller.txtSearchController.clear();
            controller.txtSearch.value = '';
            controller.onSearch();
          },
          onClearFilter: () => controller.handleStatusChange('all'),
        ),
      );
    }

    return const TrailersBody();
  }
}
