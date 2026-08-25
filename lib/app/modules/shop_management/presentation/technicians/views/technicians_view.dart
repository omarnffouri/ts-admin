import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/technicians_controller.dart';
import 'components/technicians_body.dart';
import 'components/technicians_header.dart';
import 'components/technicians_loading_view.dart';

class TechniciansView extends GetView<TechniciansController> {
  const TechniciansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          heroTag: 'create_technician',
          tooltip: 'Add technician',
          elevation: context.isDark ? 2 : 6,
          highlightElevation: 3,
          backgroundColor: context.floatingButtonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onPressed: () => Get.toNamed(Routes.CREATE_EDIT_TECHNICIAN),
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'Add technician'.tr,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const TechniciansHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: SmartRefresher(
                  controller: controller.refreshController,
                  header: const WaterDropMaterialHeader(),
                  onRefresh: controller.handleRefresh,
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: _buildBody(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return const TechniciansLoadingView(
        key: ValueKey('technicians_loading'),
      );
    }

    if (controller.filterList.isEmpty) {
      final bool isSearching = controller.txtSearch.value.isNotEmpty;
      return CustomScrollView(
        key: const ValueKey('technicians_empty'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              icon: isSearching
                  ? Icons.search_off_rounded
                  : Icons.engineering_outlined,
              title: isSearching
                  ? 'No matching technicians'
                  : 'No technicians yet',
              message: isSearching
                  ? 'Try changing your search.'
                  : 'Technicians you add will appear here.',
            ),
          ),
        ],
      );
    }

    return const TechniciansBody(key: ValueKey('technicians_body'));
  }
}
