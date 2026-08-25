import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/shop_inventories_controller.dart';
import 'components/shop_inventories_body.dart';
import 'components/shop_inventories_header.dart';
import 'components/shop_inventories_loading_view.dart';

class ShopInventoriesView extends GetView<ShopInventoriesController> {
  const ShopInventoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          heroTag: 'create_inventory',
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
            Get.toNamed(Routes.CREATE_EDIT_INVENTORY, arguments: arg);
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'New item'.tr,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const ShopInventoriesHeader(),
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
      return const ShopInventoriesLoadingView(
        key: ValueKey('inventories_loading'),
      );
    }

    if (controller.filterList.isEmpty) {
      final bool isSearching = controller.txtSearch.value.isNotEmpty;
      return CustomScrollView(
        key: const ValueKey('inventories_empty'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              icon: isSearching
                  ? Icons.search_off_rounded
                  : Icons.inventory_2_outlined,
              title:
                  isSearching ? 'No matching items' : 'No inventory items yet',
              message: isSearching
                  ? 'Try changing your search.'
                  : 'Items you add will appear here.',
            ),
          ),
        ],
      );
    }

    return const ShopInventoriesBody(key: ValueKey('inventories_body'));
  }
}
