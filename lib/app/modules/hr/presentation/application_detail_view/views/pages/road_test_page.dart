import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/inspection_request_entity.dart';
import 'package:ts_admin/app/modules/hr/presentation/application_detail_view/controllers/application_detail_view_controller.dart';

class RoadTestPage extends GetView<ApplicationDetailViewController> {
  const RoadTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.roadTestRefreshController,
      header: const WaterDropMaterialHeader(),
      onRefresh: () {
        controller.roadTestRefreshController.refreshCompleted();
        controller.handleRefresh();
      },
      child: CustomScrollView(
        slivers: [
          Obx(() {
            if (controller.isLaodingApplicationDetails) {
              return _buildLoadingSliver();
            }
            if (controller.roadTests.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: NoDataView(),
              );
            }
            return SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Road Tests',
                        style: Get.theme.textTheme.titleLarge,
                      ).marginOnly(left: 14, top: 20),
                      Divider(
                        height: 0,
                        color: Get.isDarkMode ? Colors.grey : null,
                      ).marginSymmetric(horizontal: 14),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 50),
                  sliver: SliverList.separated(
                    itemCount: controller.roadTests.length,
                    itemBuilder: (context, index) {
                      final roadTest = controller.roadTests.elementAt(index);
                      return _RoadTestItemView(
                        roadTest: roadTest,
                        index: 1,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingSliver() {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Road Tests',
              style: Get.theme.textTheme.titleLarge,
            ).marginOnly(left: 14, top: 20),
            Divider(
              height: 0,
              color: Get.isDarkMode ? Colors.grey : null,
            ).marginSymmetric(horizontal: 14),
            ...List<Widget>.generate(
              10,
              (index) => Container(
                width: double.infinity,
                height: (index % 2 == 0) ? 50 : 80,
                margin: EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: index == 0 ? 20 : 10,
                  bottom: index == 9 ? 50 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoadTestItemView extends GetView<ApplicationDetailViewController> {
  final RoadTestInspectionEntity roadTest;
  final int index;
  const _RoadTestItemView({
    required this.roadTest,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    //
    //
    // theme
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.applyOpacity(0.1),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Column(
        children: [
          //
          //
          // requested at and status
          Row(
            children: [
              //
              //
              // requested at
              Expanded(
                child: Text(
                  roadTest.requestedDate ?? "",
                  style: theme.textTheme.titleLarge,
                ),
              ),

              //
              //
              // status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      roadTest.status == "done" ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  roadTest.status?.capitalizeFirst ?? "",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),

          //
          //
          // inspector, done date, file
          if (roadTest.status == "done")
            Row(
              children: [
                //
                //
                //inspector, done date,
                Expanded(
                  child: Column(
                    children: [
                      //
                      //
                      // ispector
                      Row(
                        children: [
                          Text(
                            "Inspector: ",
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),

                          //
                          //
                          // inspected by
                          Expanded(
                            child: Text(
                              roadTest.inspector ?? "N/A",
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),

                      //
                      //
                      // done date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Done at:    ",
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              roadTest.doneDate?.getDDMMMYYYY() ?? "N/A",
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ).marginOnly(top: 5),
                    ],
                  ),
                ),

                //
                //
                // file
                // if (roadTest.file != null)
                //   Icon(
                //     Icons.file_open_rounded,
                //     size: 30,
                //     color: AppColorsLight.mainColor,
                //   )
              ],
            ).marginOnly(top: 5)
        ],
      ),
    );
  }
}
