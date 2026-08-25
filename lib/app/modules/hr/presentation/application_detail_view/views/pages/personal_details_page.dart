import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/controllers/application_detail_view_controller.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/views/components/address_tab_bar_item.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class PersonalDetailsPage extends GetView<ApplicationDetailViewController> {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    // theme
    final ThemeData theme = Theme.of(context);

    return SmartRefresher(
      controller: controller.personalRefreshController,
      header: const WaterDropMaterialHeader(),
      onRefresh: () {
        controller.personalRefreshController.refreshCompleted();
        controller.handleRefresh();
      },
      child: Obx(
        () => controller.isLaodingApplicationDetails
            ? _buildLoadingView()
            : controller.personalInformation.value == null
                ? const NoDataView()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      // heading
                      Text(
                        "Personal Information",
                        style: theme.textTheme.titleLarge,
                      ).marginOnly(left: 14, top: 20),

                      Divider(
                        height: 0,
                        color: Get.isDarkMode ? Colors.grey : null,
                      ).marginSymmetric(horizontal: 14),

                      //
                      //
                      Container(
                        margin:
                            const EdgeInsets.only(left: 14, right: 14, top: 20),
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Colors.grey.applyOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            if (!Get.isDarkMode)
                              BoxShadow(
                                color: Colors.grey.applyOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 5,
                              )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    controller
                                            .personalInformation.value?.name ??
                                        "",
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),

                                //
                                //
                                // status
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: 1 == 2
                                        ? Colors.blue
                                        : AppColorsLight.mainColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        (controller.personalInformation.value
                                                    ?.jobCategory ??
                                                "")
                                            .replaceAll("cat", "")
                                            .replaceAll("_", " "),
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (controller.personalInformation.value
                                              ?.isOwnerPartner ==
                                          true)
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                          ),
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "P",
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            //
                            // email
                            _buildDetailRow(
                              Icons.email,
                              controller.personalInformation.value?.email ?? "",
                            ).marginOnly(top: 5),

                            //
                            //
                            // phone
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailRow(
                                    Icons.phone,
                                    controller.personalInformation.value
                                            ?.mobileNumber ??
                                        "",
                                  ),
                                ),
                                if (controller.personalInformation.value
                                        ?.otherMobileNumber !=
                                    null)
                                  Expanded(
                                    child: _buildDetailRow(
                                      Icons.phone,
                                      controller.personalInformation.value
                                              ?.otherMobileNumber ??
                                          "",
                                    ),
                                  ),
                              ],
                            ).marginOnly(top: 5),

                            //
                            // ssn
                            _buildDetailRow(
                              Icons.credit_card_rounded,
                              controller.personalInformation.value?.ssNo ?? "",
                            ).marginOnly(top: 5),

                            //
                            // dob
                            if (controller.personalInformation.value?.dob !=
                                null)
                              _buildDetailRow(
                                Icons.cake_rounded,
                                controller.personalInformation.value?.dob ?? "",
                              ).marginOnly(top: 5),

                            //
                            //
                            // ref by
                            if (controller
                                    .personalInformation.value?.referredBy !=
                                null)
                              _buildDetailRow(
                                null,
                                controller.personalInformation.value
                                        ?.referredBy ??
                                    "",
                                customIcon: Image.asset(
                                  Assets.images.referralIcon.path,
                                  width: 20,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                              ).marginOnly(top: 5),
                          ],
                        ),
                      ),

                      //
                      // heading
                      Text(
                        "Address Information",
                        style: theme.textTheme.titleLarge,
                      ).marginOnly(left: 14, top: 40),

                      Divider(
                        height: 0,
                        color: Get.isDarkMode ? Colors.grey : null,
                      ).marginSymmetric(horizontal: 14),

                      TabBar(
                        indicator: BoxDecoration(
                          color: AppColors.tabBarIndicatorColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        dividerHeight: 0,
                        controller: controller.personalTabController,
                        tabs: const [
                          AddressTabBarItem(tab: AddressTabs.present),
                          AddressTabBarItem(tab: AddressTabs.previous),
                        ],
                      ).marginOnly(top: 10),

                      //
                      //
                      // address tab view

                      Expanded(
                        child: TabBarView(
                          controller: controller.personalTabController,
                          children: const [
                            _PersonalAddressTab(),
                            _PreviousAddressTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildDetailRow(IconData? icon, String details, {Widget? customIcon}) {
    final ThemeData theme = Get.theme;
    return Row(
      children: [
        if (icon != null)
          Icon(
            icon,
            size: 20,
            color: Colors.grey,
          ).marginOnly(right: 5),
        if (customIcon != null) customIcon.marginOnly(right: 5),
        Expanded(
          child: Text(
            details,
            style: theme.textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    final theme = Get.theme;
    return IgnorePointer(
      child: Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white30,
        child: IgnorePointer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                //
                // personal detail loading view
                Text(
                  "Personal Information",
                  style: theme.textTheme.headlineSmall,
                ).marginOnly(left: 14, top: 20),
                Divider(
                  height: 0,
                  color: Get.isDarkMode ? Colors.grey : null,
                ).marginSymmetric(horizontal: 14),
                Container(
                  margin: const EdgeInsets.only(left: 14, right: 14, top: 20),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.grey.applyOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                //
                //
                // address loading view
                Text(
                  "Address Information",
                  style: theme.textTheme.headlineSmall,
                ).marginOnly(left: 14, top: 40),
                Divider(
                  height: 0,
                  color: Get.isDarkMode ? Colors.grey : null,
                ).marginSymmetric(horizontal: 14),

                TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.tabBarIndicatorColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dividerHeight: 0,
                  controller: controller.personalTabController,
                  tabs: const [
                    AddressTabBarItem(tab: AddressTabs.present),
                    AddressTabBarItem(tab: AddressTabs.previous),
                  ],
                ).marginOnly(top: 5),

                Container(
                  margin: const EdgeInsets.only(left: 14, right: 14, top: 20),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.grey.applyOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonalAddressTab extends GetView<ApplicationDetailViewController> {
  const _PersonalAddressTab();

  @override
  Widget build(BuildContext context) {
    //
    // theme
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.applyOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!Get.isDarkMode)
              BoxShadow(
                color: Colors.grey.applyOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
              )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Present Address",
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(),
                if (controller.addressInformation.value
                        ?.getPresentYearsDuration() !=
                    null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorsLight.mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      controller.addressInformation.value
                              ?.getPresentYearsDuration() ??
                          "",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            //
            // address 1

            _buildAddressRow(
              "Address 1 ",
              controller.addressInformation.value?.presentAddress ?? "N/A",
            ).marginOnly(top: 5),

            //
            // address 2
            if (controller.addressInformation.value?.presentAddress2 != null)
              _buildAddressRow(
                "Address 2 ",
                controller.addressInformation.value?.presentAddress2 ?? "",
              ).marginOnly(top: 5),

            Row(
              children: [
                //
                // city
                Expanded(
                  child: _buildAddressRow(
                    "City            ",
                    controller.addressInformation.value?.presentCity ?? "N/A",
                  ),
                ),

                //
                // state
                Expanded(
                  child: _buildAddressRow(
                    "State          ",
                    controller.addressInformation.value?.presentState ?? "N/A",
                  ),
                ),
              ],
            ).marginOnly(top: 5),

            Row(
              children: [
                //
                // country
                Expanded(
                  child: _buildAddressRow(
                    "Country     ",
                    controller.addressInformation.value?.presentCountry ??
                        "N/A",
                  ),
                ),

                //
                // zip
                Expanded(
                  child: _buildAddressRow(
                    "Zip             ",
                    controller.addressInformation.value?.presentZip ?? "N/A",
                  ),
                ),
              ],
            ).marginOnly(top: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressRow(String title, String details) {
    final ThemeData theme = Get.theme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).marginOnly(top: 2),
        Expanded(
          child: Text(
            details,
            style: theme.textTheme.bodyLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PreviousAddressTab extends GetView<ApplicationDetailViewController> {
  const _PreviousAddressTab();

  @override
  Widget build(BuildContext context) {
    //
    // theme
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          left: 14,
          right: 14,
          top: 10,
          bottom: 100,
        ),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.applyOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!Get.isDarkMode)
              BoxShadow(
                color: Colors.grey.applyOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
              )
          ],
        ),
        child: !(controller.addressInformation.value?.havePreviousAddress() ??
                false)
            ? const SizedBox(
                height: 145,
                child: NoDataView(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Previous Address",
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(),
                      if (controller.addressInformation.value
                              ?.getPreviousYearsDuration() !=
                          null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColorsLight.mainColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            controller.addressInformation.value
                                    ?.getPreviousYearsDuration() ??
                                "",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  //
                  // address 1
                  _buildAddressRow(
                    "Address 1 ",
                    controller.addressInformation.value?.previousAddress ?? "",
                  ).marginOnly(top: 5),

                  //
                  // address 2
                  if (controller.addressInformation.value?.previousAddress2 !=
                      null)
                    _buildAddressRow(
                      "Address 2 ",
                      controller.addressInformation.value?.previousAddress2 ??
                          "",
                    ).marginOnly(top: 5),

                  Row(
                    children: [
                      //
                      // city
                      Expanded(
                        child: _buildAddressRow(
                          "City            ",
                          controller.addressInformation.value?.previousCity ??
                              "",
                        ),
                      ),

                      //
                      // state
                      Expanded(
                        child: _buildAddressRow(
                          "State          ",
                          controller.addressInformation.value?.previousState ??
                              "",
                        ),
                      ),
                    ],
                  ).marginOnly(top: 5),

                  Row(children: [
                    //
                    // country
                    Expanded(
                      child: _buildAddressRow(
                        "Country     ",
                        controller.addressInformation.value?.previousCountry ??
                            "",
                      ),
                    ),

                    //
                    // zip
                    Expanded(
                      child: _buildAddressRow(
                        "Zip             ",
                        controller.addressInformation.value?.previousZip ?? "",
                      ),
                    ),
                  ]).marginOnly(top: 5),
                ],
              ),
      ),
    );
  }

  Widget _buildAddressRow(String title, String details) {
    final ThemeData theme = Get.theme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).marginOnly(top: 2),
        Expanded(
          child: Text(
            details,
            style: theme.textTheme.bodyLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
