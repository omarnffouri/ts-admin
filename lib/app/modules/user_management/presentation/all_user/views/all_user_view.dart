import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/user_management/domain/entities/user_entity.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/all_user_controller.dart';
import 'components/filter_by_role_widget.dart';
import 'components/search_widget.dart';
import 'components/user_card_widget.dart';

class AllUserView extends GetView<AllUserController> {
  const AllUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: primaryColor,
      floatingActionButton: Obx(
        () => Visibility(
          visible:
              controller.authController.userPermissionHelper.canCreateUsers(),
          child: FloatingActionButton.extended(
            backgroundColor: context.floatingButtonColor,
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: () {
              Get.toNamed(Routes.NEW_ACCOUNT);
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(
              "New User",
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: AppRedHeader(
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        //
                        // header (title + search + role filter)
                        AppRedHeader(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "All Users",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // search + filter row
                        const Padding(
                          padding: EdgeInsets.fromLTRB(12, 14, 12, 4),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: SearchWidget()),
                              SizedBox(width: 10),
                              Expanded(flex: 2, child: FilterByRoleWidget()),
                            ],
                          ),
                        ),

                        // body
                        Expanded(
                          child: Obx(
                            () => controller.isLoading.value
                                ? ListView.builder(
                                    padding: const EdgeInsets.only(top: 8),
                                    itemCount: 12,
                                    itemBuilder: (context, index) {
                                      return Shimmer.fromColors(
                                        baseColor: Get.isDarkMode
                                            ? Colors.white10
                                            : Colors.black12,
                                        highlightColor: Get.isDarkMode
                                            ? Colors.white24
                                            : Colors.white30,
                                        child: UserCardWidget(
                                          user: UserEntity(
                                            name: "Name",
                                            email: "abc@email.com",
                                            phone: "0123456789",
                                            address:
                                                "street, state, country etc",
                                          ),
                                          index: index,
                                        ),
                                      );
                                    },
                                  )
                                : controller.errorWhileLoadingUsers.value
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.error_outline_rounded,
                                            size: 48,
                                            color: AppColorsLight.mainColor,
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                              'Error while loading users'),
                                          MainAppButton(
                                            label: "Try Again",
                                            onPressed: () {
                                              controller.getAllUsers();
                                            },
                                          ).marginOnly(top: 30),
                                        ],
                                      ).marginSymmetric(horizontal: 20)
                                    // SlidableAutoCloseBehavior stays above
                                    // SmartRefresher — its child must BE the
                                    // scrollable or the drag never reaches it.
                                    : SlidableAutoCloseBehavior(
                                        child: SmartRefresher(
                                          controller:
                                              controller.refreshController,
                                          header:
                                              const WaterDropMaterialHeader(),
                                          onRefresh:
                                              controller.handleShipmentRefresh,
                                          child: CustomScrollView(
                                            controller:
                                                controller.scrollController,
                                            slivers: [
                                              Obx(
                                                () => controller
                                                        .isSearching.value
                                                    ? const SliverFillRemaining(
                                                        hasScrollBody: false,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                AppColorsLight
                                                                    .mainColor,
                                                          ),
                                                        ),
                                                      )
                                                    : controller.users.isEmpty
                                                        ? const SliverFillRemaining(
                                                            hasScrollBody:
                                                                false,
                                                            child: NoDataView(),
                                                          )
                                                        : SliverList(
                                                            delegate:
                                                                SliverChildBuilderDelegate(
                                                              (context, index) {
                                                                final user =
                                                                    controller
                                                                            .users[
                                                                        index];
                                                                return Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: index ==
                                                                            0
                                                                        ? 8
                                                                        : 0,
                                                                    bottom: index ==
                                                                            (controller.users.length -
                                                                                1)
                                                                        ? 100
                                                                        : 0,
                                                                  ),
                                                                  child:
                                                                      UserCardWidget(
                                                                    user: user,
                                                                    index:
                                                                        index,
                                                                  ),
                                                                );
                                                              },
                                                              childCount:
                                                                  controller
                                                                      .users
                                                                      .length,
                                                            ),
                                                          ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // load-more indicator
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Center(
                          child: controller.isHasMoreLoading.value
                              ? const CircularProgressIndicator(
                                  color: AppColorsLight.mainColor,
                                )
                              : const SizedBox.shrink(),
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
