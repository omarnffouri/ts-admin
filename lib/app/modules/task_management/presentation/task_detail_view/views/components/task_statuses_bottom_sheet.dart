import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/controllers/task_detail_view_controller.dart';

class TaskStatusesBottomSheet extends GetView<TaskDetailViewController> {
  const TaskStatusesBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        //
        // top header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: 50,
          decoration: const BoxDecoration(
            color: AppColorsLight.mainColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Row(
            children: [
              const Text(
                "Task Comments",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Obx(
                () => Visibility(
                  visible: controller.task.value?.isInprogress() ?? false,
                  child: IconButton(
                    onPressed: () {
                      controller.showAddCommentBottomSheet();
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).marginOnly(left: 8),

              const Spacer(),

              //
              //
              // close button
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: 25,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),

        //
        //
        // no data view

        Obx(
          () => (controller.task.value?.statuses?.isNotEmpty ?? false)
              ? Container(
                  constraints: BoxConstraints(
                    maxHeight: Get.height * 0.75,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.task.value!.statuses!.length,
                    itemBuilder: (context, index) {
                      // status
                      final status = controller.task.value!.statuses![index];

                      return _StatusItemView(
                        status: status,
                        index: index,
                      ).marginOnly(
                          top: index == 0 ? 10 : 0,
                          bottom: index ==
                                  (controller.task.value!.statuses!.length - 1)
                              ? 30
                              : 0);
                    },
                  ),
                )
              : const NoDataView(),
        ),
      ],
    );
  }
}

class _StatusItemView extends StatelessWidget {
  final TaskStatusEntity status;
  final int index;
  const _StatusItemView({
    required this.status,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.applyOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          //
          // status and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              //
              // status
              Text(
                status.getStatus(),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColorsLight.mainColor,
                ),
              ),

              //
              //
              // date
              Text(
                status.createdAt.getDDMMMYYYY(),
                style: theme.textTheme.labelMedium,
              )
            ],
          ),

          //
          //
          // reason
          Row(
            children: [
              Expanded(
                child: Text(
                  status.reason ?? "N/A",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
