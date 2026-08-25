import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_detail_view/controllers/task_detail_view_controller.dart';

class TaskTimeView extends GetView<TaskDetailViewController> {
  const TaskTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return displayRemainingTime();
  }

  Widget displayRemainingTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //
        //
        // days view
        Obx(
          () => _getTimeBox(
            (controller.task.value?.getDueDays() ?? 0).toString(),
            "days",
          ),
        ),

        Container(
          width: 10,
          height: 1,
          color: AppColorsLight.mainColor,
        ),

        //
        //
        // hrs view
        Obx(
          () => _getTimeBox(
            (controller.task.value?.getDueHours() ?? 0).toString(),
            "hours",
          ),
        ),

        Container(
          width: 10,
          height: 1,
          color: AppColorsLight.mainColor,
        ),

        //
        //
        // minutes view
        Obx(
          () => _getTimeBox(
            (controller.task.value?.getDueMinutes() ?? 0).toString(),
            "minutes",
          ),
        ),
      ],
    );
  }

  Widget _getTimeBox(String time, String label) {
    return Container(
      width: 120,
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColorsLight.mainColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _getTimeView(time),
          _getTimeLabel(label),
        ],
      ),
    );
  }

  Widget _getTimeLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _getTimeView(String time) {
    return Text(
      time,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
