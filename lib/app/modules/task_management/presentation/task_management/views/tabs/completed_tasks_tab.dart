import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/controllers/task_management_controller.dart';
import 'package:ts_admin/app/core/widgets/tasks_empty_state.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/views/components/tasks_listing_error_view.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/views/components/tasks_todo_listing_loading_view.dart';

class CompletedTasksTab extends GetView<TaskManagementController> {
  const CompletedTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SmartRefresher(
        enablePullDown: !controller.isLoadingTasksListing,
        physics: const ClampingScrollPhysics(),
        controller: controller.completedRefreshController,
        header: const WaterDropMaterialHeader(),
        onRefresh: () async {
          controller.completedRefreshController.refreshCompleted();
          await controller.refreshTasksListing("completed");
        },
        child: Obx(
          () => controller.isLoadingTasksListing ||
                  controller.isRefreshingCompletedTasks
              ? const TasksListingLoadingView(
                  headerTitle: "Recently Achieved",
                  bodyTitle: "Completed",
                )
              : controller.errorWhileLoadingTasksListing
                  ? const TasksListingErrorView()
                  : (controller.recentlyAchived.isEmpty &&
                          controller.completed.isEmpty)
                      ? const TasksEmptyState(
                          padding: 28,
                          radius: 28,
                          title: "No tasks here",
                          descrption:
                              "Tasks for this status will appear here when they are available.",
                        )
                      : const Column(
                          children: [
                            _RecentlyCompletedView(),
                            Expanded(child: _CompletedView()),
                          ],
                        ),
        ),
      ),
    );
  }
}

class _RecentlyCompletedView extends GetView<TaskManagementController> {
  const _RecentlyCompletedView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        //
        //
        // recently completed heading
        Text(
          "Recently Achieved",
          style: theme.textTheme.headlineSmall,
        ).marginOnly(left: 14),

        //
        //
        // recently completed list
        SizedBox(
          height: 220,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentlyAchived.length,
              itemBuilder: (context, index) {
                //
                // task item
                final task = controller.recentlyAchived.elementAt(index);
                //
                //
                // item view
                return InkWell(
                  onTap: () {
                    controller.viewTaskDetails(task);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: Get.isDarkMode ? 15 : 20,
                      right: index == (controller.recentlyAchived.length - 1)
                          ? 20
                          : 0,
                      top: 10,
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    width: Get.width *
                        (controller.recentlyAchived.length == 1 ? 0.75 : 0.6),
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
                        // remaining days and hrs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //
                            //
                            // task title
                            Expanded(
                              child: Text(
                                task.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColorsLight.mainColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
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
                          ],
                        ),

                        //
                        //
                        // category
                        Text(
                          task.category ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge,
                        ),

                        //
                        //
                        // description
                        Expanded(
                          child: Text(
                            task.description ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),

                        //
                        //
                        // report to user
                        Row(
                          children: [
                            //
                            //
                            // report to heading
                            Text(
                              "Reported to:",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ).marginOnly(right: 4),

                            //
                            //
                            // report to user name
                            Expanded(
                              child: Text(
                                task.reportsTo?.name ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),

                        //
                        //
                        // progress bar
                        Row(
                          children: [
                            //
                            // progress value
                            Expanded(
                              child: LinearProgressIndicator(
                                value: ((task.percentage ?? 0) / 100),
                                borderRadius: BorderRadius.circular(999),
                                color: AppColorsLight.mainColor,
                                backgroundColor: Colors.red.applyOpacity(0.2),
                              ),
                            ),

                            //
                            // progress value
                            Text(
                              "${(task.percentage ?? 0)} %",
                              style: theme.textTheme.labelMedium,
                            ).marginOnly(left: 15)
                          ],
                        ),

                        //
                        //
                        // due date and view details button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //
                            //
                            // due date
                            Text(
                              task.dueDate.getDDMMMYYYY(),
                              style: theme.textTheme.labelLarge,
                            ),

                            //
                            //
                            // view details button
                            Row(
                              children: [
                                Text(
                                  "View Details",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColorsLight.mainColor,
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColorsLight.mainColor,
                                  size: 20,
                                )
                              ],
                            )
                          ],
                        ).marginOnly(top: 5)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class _CompletedView extends GetView<TaskManagementController> {
  const _CompletedView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        //
        //
        // completed heading
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Completed",
              style: theme.textTheme.headlineSmall,
            ),
            GestureDetector(
              onTap: () {
                //
              },
              child: Row(
                children: [
                  InkWell(
                    onTap: controller.viewAllTasks,
                    child: Text(
                      "view all",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColorsLight.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ).marginSymmetric(horizontal: 14),

        // Divider(
        //   color: Colors.grey.applyOpacity(0.3),
        //   thickness: 0.5,
        //   height: 5,
        // ).marginSymmetric(horizontal: 14),

        //
        //
        // completed list
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: controller.completed.length,
              itemBuilder: (context, index) {
                //
                // task item
                final task = controller.completed.elementAt(index);
                //
                //
                // item view
                return InkWell(
                  onTap: () {
                    controller.viewTaskDetails(task);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 15,
                      left: 10,
                      right: 10,
                      bottom:
                          index == (controller.completed.length - 1) ? 100 : 0,
                    ),
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    width: Get.width * 0.60,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Colors.grey.applyOpacity(0.1)
                          : Colors.white,
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
                                      task.title ?? "",
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
                                task.category ?? "",
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
                                  // report to heading
                                  Text(
                                    "Reported to:",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ).marginOnly(right: 4),

                                  //
                                  //
                                  // report to user name
                                  Expanded(
                                    child: Text(
                                      task.reportsTo?.name ?? "N/A",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
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
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
