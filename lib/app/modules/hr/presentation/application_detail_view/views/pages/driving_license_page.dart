import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/controllers/application_detail_view_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class DrivingLicensePage extends GetView<ApplicationDetailViewController> {
  const DrivingLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.licenseRefreshController,
      header: const WaterDropMaterialHeader(),
      onRefresh: () {
        controller.licenseRefreshController.refreshCompleted();
        controller.handleRefresh();
      },
      child: Obx(
        () => controller.isLaodingApplicationDetails
            ? _buildLoadingView()
            : controller.drivingLicenseInformation.value == null
                ? const NoDataView()
                : const _LicenseDetailsView(),
      ),
    );
  }
}

class _LicenseDetailsView extends GetView<ApplicationDetailViewController> {
  const _LicenseDetailsView();

  @override
  Widget build(BuildContext context) {
    //
    // theme
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // heading
          Text(
            "Driving license Information",
            style: theme.textTheme.titleLarge,
          ).marginOnly(left: 14, top: 20),

          Divider(
            height: 0,
            color: Get.isDarkMode ? Colors.grey : null,
          ).marginSymmetric(horizontal: 14),

          //
          //
          Container(
            margin: const EdgeInsets.only(left: 14, right: 14, top: 20),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  Get.isDarkMode ? Colors.grey.applyOpacity(0.1) : Colors.white,
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
                //
                // name
                _buildDetailsSection(
                  "Name-Exactly as it appears on your drivver's license",
                  controller.drivingLicenseInformation.value?.cdlName ?? "N/A",
                ),

                //
                //
                // cdl type
                _buildDetailsSection(
                  "CDL Type",
                  controller.drivingLicenseInformation.value?.cdlType ?? "N/A",
                ).marginOnly(top: 15),

                //
                //
                // Endorsements
                _buildDetailsSection(
                  "Endorsements",
                  controller.drivingLicenseInformation.value?.cdlEndorsement ??
                      "N/A",
                ).marginOnly(top: 15),

                //
                //
                // Current Driver's License Number
                _buildDetailsSection(
                  "Current Driver's License Number",
                  controller
                          .drivingLicenseInformation.value?.currentLicenseNum ??
                      "N/A",
                ).marginOnly(top: 15),

                //
                //
                // License Expiration Date and Years of CDL Experience
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    // License Expiration Date
                    Expanded(
                      child: _buildDetailsSection(
                        "License Expiration Date",
                        controller.drivingLicenseInformation.value
                                ?.cdlLicenseExpiration ??
                            "N/A",
                      ).marginOnly(top: 15),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    //
                    //
                    // Years of CDL Experience
                    Expanded(
                      child: _buildDetailsSection(
                        "Years of CDL Experience",
                        controller.drivingLicenseInformation.value?.cdlExp ??
                            "N/A",
                      ).marginOnly(top: 15),
                    ),
                  ],
                ),

                //
                //
                // Current DOT Medical Card
                _buildDetailsSection(
                  "Current DOT Medical Card",
                  controller.drivingLicenseInformation.value?.cdlDotMc ?? "N/A",
                ).marginOnly(top: 15),

                //
                //
                // DOT Medical Card Expiration Date
                _buildDetailsSection(
                  "DOT Medical Card Expiration Date",
                  controller.drivingLicenseInformation.value
                          ?.cdlDotMcExpireDate ??
                      "N/A",
                ).marginOnly(top: 15),

                //
                //
                // Issuing State/Province
                _buildDetailsSection(
                  "Issuing State/Province",
                  controller.drivingLicenseInformation.value?.cdlIssuingState ??
                      "N/A",
                ).marginOnly(top: 15),

                //
                //
                // Dry Van Experience and Flatbed Experience
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    // Dry Van Experience
                    Expanded(
                      child: _buildDetailsSection(
                        "Dry Van Experience",
                        controller.drivingLicenseInformation.value
                                ?.cdlDryVanExp ??
                            "N/A",
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    //
                    //
                    // Flatbed Experience
                    Expanded(
                      child: _buildDetailsSection(
                        "Flatbed Experience",
                        controller.drivingLicenseInformation.value
                                ?.cdlFlatbedExp ??
                            "N/A",
                      ),
                    )
                  ],
                ).marginOnly(top: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLoadingView() {
  final theme = Get.theme;
  return IgnorePointer(
    child: Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // heading
            Text(
              "Driving license Information",
              style: theme.textTheme.titleLarge,
            ).marginOnly(left: 14, top: 20),

            Divider(
              height: 0,
              color: Get.isDarkMode ? Colors.grey : null,
            ).marginSymmetric(horizontal: 14),

            //
            //
            Container(
              margin: const EdgeInsets.only(left: 14, right: 14, top: 20),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //
                  // name
                  _buildDetailsSection(
                    "Name-Exactly as it appears on your drivver's license",
                    "N/A",
                  ),

                  //
                  //
                  // cdl type
                  _buildDetailsSection(
                    "CDL Type",
                    "N/A",
                  ).marginOnly(top: 15),

                  //
                  //
                  // Endorsements
                  _buildDetailsSection(
                    "Endorsements",
                    "N/A",
                  ).marginOnly(top: 15),

                  //
                  //
                  // Current Driver's License Number
                  _buildDetailsSection(
                    "Current Driver's License Number",
                    "N/A",
                  ).marginOnly(top: 15),

                  //
                  //
                  // License Expiration Date and Years of CDL Experience
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      //
                      // License Expiration Date
                      Expanded(
                        child: _buildDetailsSection(
                          "License Expiration Date",
                          "N/A",
                        ).marginOnly(top: 15),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      //
                      //
                      // Years of CDL Experience
                      Expanded(
                        child: _buildDetailsSection(
                          "Years of CDL Experience",
                          "N/A",
                        ).marginOnly(top: 15),
                      ),
                    ],
                  ),

                  //
                  //
                  // Current DOT Medical Card
                  _buildDetailsSection(
                    "Current DOT Medical Card",
                    "N/A",
                  ).marginOnly(top: 15),

                  //
                  //
                  // DOT Medical Card Expiration Date
                  _buildDetailsSection(
                    "DOT Medical Card Expiration Date",
                    "N/A",
                  ).marginOnly(top: 15),

                  //
                  //
                  // Issuing State/Province
                  _buildDetailsSection(
                    "Issuing State/Province",
                    "N/A",
                  ).marginOnly(top: 15),

                  //
                  //
                  // Dry Van Experience and Flatbed Experience
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      //
                      // Dry Van Experience
                      Expanded(
                        child: _buildDetailsSection(
                          "Dry Van Experience",
                          "N/A",
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      //
                      //
                      // Flatbed Experience
                      Expanded(
                        child: _buildDetailsSection(
                          "Flatbed Experience",
                          "N/A",
                        ),
                      )
                    ],
                  ).marginOnly(top: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDetailsSection(
  String heading,
  String data,
) {
  final ThemeData theme = Get.theme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //
      //
      // heading
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey.applyOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          heading,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      //
      //
      // data
      Text(
        data,
        style: theme.textTheme.bodyLarge,
      ).marginSymmetric(horizontal: 5),
    ],
  );
}
