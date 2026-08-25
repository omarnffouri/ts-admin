import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/core/widgets/shimmer_sliver_list.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/presentation/view_all_task/views/components/view_all_tasks_header.dart';

import '../controllers/view_all_task_controller.dart';
import 'components/tasks_error_view.dart';

class ViewAllTaskView extends GetView<ViewAllTaskController> {
  const ViewAllTaskView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Positioned.fill(
                bottom: 10,
                child: Column(
                  children: [
                    //
                    // header
                    const ViewAllTasksHeader(),

                    //
                    // body
                    Expanded(
                      child: SmartRefresher(
                        controller: controller.refreshController,
                        header: const WaterDropMaterialHeader(),
                        primary: false,
                        onRefresh: () {
                          controller.refreshController.refreshCompleted();
                          controller.getAllTasks();
                        },
                        child: CustomScrollView(
                          controller: controller.scrollController,
                          slivers: [
                            Obx(() => _buildContentSliver()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //
              // bottom loading indicator
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Center(
                      child: controller.isHasMoreLoading.value
                          ? const Column(
                              children: [
                                CircularProgressIndicator(
                                  color: AppColorsLight.mainColor,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSliver() {
    if (controller.isLoading.value) {
      return _buildLoadingSliver();
    }

    if (controller.isSearching.value) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: AppColorsLight.mainColor),
        ),
      );
    }

    if (controller.errorWhileLoading.value) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: TasksErrorView(),
      );
    }

    if (controller.tasks.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: NoDataView(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = controller.tasks[index];
          return _TaskItemView(task: task, index: index);
        },
        childCount: controller.tasks.length,
      ),
    );
  }

  /// Skeleton mirroring the task-card anatomy while the first load is in
  /// flight.
  Widget _buildLoadingSliver() {
    return ShimmerSliverList(
      itemCount: 8,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      itemSpacing: 10,
      itemBuilder: (_, __) => const _SkeletonTaskCard(),
    );
  }
}

/// Bones matching [_TaskItemView]: title, category, assignee row, status chip.
class _SkeletonTaskCard extends StatelessWidget {
  const _SkeletonTaskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.applyOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bone(width: 160, height: 13, radius: 6),
                SizedBox(height: 8),
                _Bone(width: 90, height: 10, radius: 5),
                SizedBox(height: 10),
                _Bone(width: 130, height: 9, radius: 5),
              ],
            ),
          ),
          SizedBox(width: 12),
          _Bone(width: 64, height: 24, radius: 8),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _TaskItemView extends GetView<ViewAllTaskController> {
  final TaskEntity task;
  final int index;
  const _TaskItemView({
    required this.task,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    //
    // theme data
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        controller.viewTaskDetails(task);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.applyOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Get.isDarkMode
              ? null
              : Border.all(
                  color: Colors.grey.applyOpacity(0.3),
                ),
        ),
        child: Row(
          children: [
            //
            //
            //
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //
                  // task title
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${task.title}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.white
                                : AppColorsLight.mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //
                  //
                  // category
                  Text(
                    "${task.category}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge,
                  ),

                  //
                  //
                  // due date and view details button
                  Row(
                    children: [
                      //
                      //
                      // report to user name
                      Expanded(
                        child: Row(
                          children: [
                            //
                            //
                            // report to heading
                            Text(
                              "${controller.assignedToMe(task) ? "Report" : "Assigned"} to",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ).marginOnly(right: 4),

                            //
                            //
                            // report to user name
                            Text(
                              controller.getReporterOrAssigne(task)?.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            //
            //
            // progress and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //
                //
                // status

                if (task.isCompleted())
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorsLight.mainColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      "Completed",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                if (task.isPending())
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.applyOpacity(0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      "Pending",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                if (task.isInprogress())
                  Stack(
                    children: [
                      //
                      //
                      // progress value
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(
                          value: ((task.percentage ?? 0) / 100),
                          strokeWidth: 4,
                          strokeCap: StrokeCap.round,
                          color: Get.isDarkMode
                              ? Colors.white70
                              : AppColorsLight.mainColor,
                          backgroundColor: (Get.isDarkMode
                                  ? Colors.white70
                                  : AppColorsLight.mainColor)
                              .applyOpacity(0.2),
                        ),
                      ),

                      //
                      // progress value
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            "${task.percentage}%",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Get.isDarkMode
                                  ? Colors.white70
                                  : AppColorsLight.mainColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                //
                //
                // due date
                Text(
                  task.dueDate.getDDMMMYYYY(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ).marginOnly(top: 10),
              ],
            ),

            //
            //
            const Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: Colors.grey,
            ).marginOnly(left: 5)
          ],
        ),
      ),
    ).marginOnly(
      top: index == 0 ? 20 : 0,
      bottom: index == controller.tasks.length - 1 ? 40 : 0,
    );
  }
}
