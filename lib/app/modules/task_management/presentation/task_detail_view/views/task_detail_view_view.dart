import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/views/components/task_time_view.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewView extends GetView<TaskDetailViewController> {
  const TaskDetailViewView({super.key});
  @override
  Widget build(BuildContext context) {
    //

    final ThemeData theme = Theme.of(context);

    //
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              //
              // header
              const _Header(),

              //
              //
              // body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      //
                      // assigned at and complted at / due date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //
                          //
                          // assigned at
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "assigned at",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  controller.task.value?.createdAt
                                          ?.getDDMMMYYYY() ??
                                      "",
                                  style: theme.textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),

                          //
                          //
                          // completed / due date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Obx(
                                () => Text(
                                  (controller.task.value?.isCompleted() ??
                                          false)
                                      ? "completed at"
                                      : "due date",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Obx(
                                () => Text(
                                  (controller.task.value?.isCompleted() ??
                                          false)
                                      ? (controller.task.value?.updatedAt
                                              .getDDMMMYYYY() ??
                                          "")
                                      : (controller.task.value?.dueDate
                                              .getDDMMMYYYY() ??
                                          ""),
                                  style: theme.textTheme.labelLarge,
                                ),
                              ),
                            ],
                          )
                        ],
                      ).marginOnly(left: 14, right: 14, top: 15),

                      //
                      //
                      // remaining time
                      Obx(
                        () => Visibility(
                          visible: controller.haveDuration() &&
                              !(controller.task.value?.isCompleted() ?? true),
                          child: const TaskTimeView()
                              .marginOnly(left: 14, right: 14, top: 20),
                        ),
                      ),

                      //
                      //
                      // report to user view
                      Obx(
                        () => Text(
                          "${controller.assignedToMe() ? "Report" : "Assigned"} to",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ).marginOnly(left: 14, top: 20),

                      //
                      //
                      // report to user view
                      Row(
                        children: [
                          //
                          // user image
                          Obx(
                            () => ProfileImage.network(
                              url: controller.getReporterOrAssigne()?.image,
                              width: 30,
                              height: 30,
                            ),
                          ),

                          //
                          // user name
                          Obx(
                            () => Text(
                              controller.getReporterOrAssigne()?.name ?? "",
                              style: theme.textTheme.bodyLarge,
                            ).marginOnly(left: 5),
                          )
                        ],
                      ).marginSymmetric(horizontal: 14),

                      //
                      //
                      // category
                      Text(
                        "Catgory",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.grey,
                        ),
                      ).marginOnly(left: 14, top: 20),

                      //
                      //
                      // task category
                      Obx(
                        () => Text(
                          controller.task.value?.category ?? "",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.justify,
                        ),
                      ).marginSymmetric(horizontal: 14),

                      //
                      //
                      // description heading
                      Text(
                        "Description",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.grey,
                        ),
                      ).marginOnly(left: 14, top: 20),

                      //
                      //
                      // task description
                      Obx(
                        () => Text(
                          controller.task.value?.description ?? "",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.justify,
                        ),
                      ).marginSymmetric(horizontal: 14),

                      //
                      //
                      // progress heading
                      Row(
                        children: [
                          Text(
                            "Progress",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),

                          //
                          // progress
                          Obx(
                            () => Visibility(
                              visible: controller.assignedToMe() &&
                                  !(controller.task.value?.isCompleted() ??
                                      true),
                              child: Text(
                                "${(controller.progress * 100).round()}%",
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                          ).marginOnly(left: 5),

                          //
                          // progress
                          Obx(
                            () => Visibility(
                              visible: controller.isUpdatingProgress,
                              child: const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeCap: StrokeCap.round,
                                  strokeWidth: 4,
                                  color: AppColorsLight.mainColor,
                                ),
                              ),
                            ),
                          ).marginOnly(left: 10),
                        ],
                      ).marginOnly(left: 14, top: 20),

                      //
                      //
                      // progress bar view
                      Obx(
                        () => Visibility(
                          visible: controller.assignedToMe() &&
                              !(controller.task.value?.isCompleted() ?? true),
                          child: SliderTheme(
                            data: const SliderThemeData(
                              trackHeight: 10,
                            ),
                            child: Slider(
                              value: controller.progress.value,
                              thumbColor: AppColorsLight.mainColor,
                              activeColor: AppColorsLight.mainColor,
                              inactiveColor:
                                  AppColorsLight.mainColor.applyOpacity(0.2),
                              semanticFormatterCallback: (value) {
                                return "$value %";
                              },
                              onChanged: (value) {
                                if (controller.assignedToMe() &&
                                    (controller.task.value?.isInprogress() ??
                                        false) &&
                                    (!controller.isUpdatingProgress)) {
                                  controller.progress.value = value;
                                }
                              },
                              onChangeEnd: (value) {
                                if (controller.assignedToMe() &&
                                    (controller.task.value?.isInprogress() ??
                                        false) &&
                                    (!controller.isUpdatingProgress)) {
                                  controller.updateProgress(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //
                      //
                      // progress presenter
                      Obx(
                        () => Visibility(
                          visible: !controller.assignedToMe() ||
                              (controller.task.value?.isCompleted() ?? false),
                          child: Stack(
                            children: [
                              //
                              //
                              // progress bar
                              LinearProgressIndicator(
                                value: controller.progress.value,
                                minHeight: 20,
                                color: AppColorsLight.mainColor,
                                backgroundColor:
                                    AppColorsLight.mainColor.applyOpacity(0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),

                              //
                              //
                              // progress value
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: Text(
                                    "${(controller.progress * 100).toInt()}%",
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : controller.progress < 0.5
                                              ? Colors.black
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ).marginOnly(left: 14, right: 14, top: 5),
                        ),
                      ),

                      //
                      //
                      // Attachment view
                      Obx(
                        () => Visibility(
                          visible: controller.task.value?.file != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              //
                              // attachment heading
                              Text(
                                "Attachment",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.grey,
                                ),
                              ).marginOnly(left: 14, top: 20),

                              //
                              //
                              //
                              InkWell(
                                onTap: () {
                                  controller.openAttachmentFile();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.applyOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      //
                                      //
                                      // file icon
                                      Image.asset(
                                        controller.getFileIcon(),
                                        width: 25,
                                        height: 25,
                                      ).marginOnly(right: 10),

                                      Expanded(
                                        child: Text(
                                          controller.getFileName(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      //
                                      //
                                      // download
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                              .isDownloadingAttachment,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${(controller.downloadProgress.value * 100).toStringAsFixed(2)} %",
                                                style:
                                                    theme.textTheme.labelMedium,
                                              ).marginOnly(right: 5),
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  value: controller
                                                      .downloadProgress.value,
                                                  strokeWidth: 4,
                                                  strokeCap: StrokeCap.round,
                                                  color: Get.isDarkMode
                                                      ? Colors.white
                                                      : AppColorsLight
                                                          .mainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ).marginOnly(left: 14),
                                    ],
                                  ),
                                ),
                              ).marginOnly(left: 14, right: 14, top: 10)
                            ],
                          ),
                        ),
                      ),

                      //
                      //
                      // button
                      Obx(
                        () => Visibility(
                          visible: controller.assignedToMe() &&
                              (controller.task.value != null) &&
                              !controller.task.value!.isCompleted(),
                          child: RoundedBorderButton(
                            label: controller.task.value!.isPending()
                                ? "Start"
                                : "Complete",
                            onPressed: () {
                              controller.showUpdateTaskBottomSheet();
                            },
                          ).marginOnly(left: 14, right: 14, top: 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<TaskDetailViewController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Retrieve specific theme colors
    Color primaryColor = theme.primaryColor;
    //
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.applyOpacity(Get.isDarkMode ? 0.3 : 1),
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // back icon, name , edit icon
          Row(
            children: [
              //
              //
              // back icon
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ).paddingOnly(right: 15),

              //
              //
              // dropdown title
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.task.value?.title ?? "",
                          style: theme.textTheme.titleLarge
                              ?.copyWith(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 100,
              ),

              //
              //
              // edit icon
              Obx(
                () => Visibility(
                  visible: controller.assignedByMe() &&
                      (controller.task.value?.isPending() ?? false),
                  child: IconButton(
                    onPressed: () {
                      if (controller.task.value == null) {
                        return;
                      }
                      Get.toNamed(Routes.CREATE_TASK,
                          arguments: controller.task.value!);
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).marginSymmetric(horizontal: 10)
            ],
          ),

          //
          //
          // status
          GestureDetector(
            onTap: () {
              controller.showTaskStatusesBottomSheet();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 35, top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.task.value?.getStatus() ?? "",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.remove_red_eye_rounded,
                      size: 20,
                      color: Colors.white,
                    ).marginOnly(left: 8)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
