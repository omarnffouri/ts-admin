import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/shop_suppliers_controller.dart';
import 'components/shop_suppliers_body.dart';
import 'components/shop_suppliers_header.dart';
import 'components/shop_suppliers_loading_view.dart';

class ShopSuppliersView extends GetView<ShopSuppliersController> {
  const ShopSuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          heroTag: 'create_supplier',
          tooltip: 'Add supplier',
          elevation: context.isDark ? 2 : 6,
          highlightElevation: 3,
          backgroundColor: context.floatingButtonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onPressed: () {
            final arg = {
              'isUsedPart': controller.isUsedPart.value,
            };
            Get.toNamed(Routes.CREATE_EDIT_SUPPLIER, arguments: arg);
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'Add supplier'.tr,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const ShopSuppliersHeader(),
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
      return const ShopSuppliersLoadingView(
        key: ValueKey('suppliers_loading'),
      );
    }

    if (controller.filterList.isEmpty) {
      final bool isSearching = controller.txtSearch.value.isNotEmpty;
      return CustomScrollView(
        key: const ValueKey('suppliers_empty'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              icon: isSearching
                  ? Icons.search_off_rounded
                  : Icons.storefront_outlined,
              title: isSearching ? 'No matching suppliers' : 'No suppliers yet',
              message: isSearching
                  ? 'Try changing your search.'
                  : 'Suppliers you add will appear here.',
            ),
          ),
        ],
      );
    }

    return const ShopSuppliersBody(key: ValueKey('suppliers_body'));
  }
}
