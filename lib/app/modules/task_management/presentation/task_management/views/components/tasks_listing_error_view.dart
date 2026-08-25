import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/controllers/task_management_controller.dart';

class TasksListingErrorView extends GetView<TaskManagementController> {
  const TasksListingErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //
        // error
        Text(
          "Something went wrong while loading tasks..!",
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),

        MainAppButton(
          label: "Try Again",
          onPressed: () {
            //
            controller.getTasksListing();
          },
        ).marginOnly(top: 50)
      ],
    ).marginSymmetric(horizontal: 20);
  }
}
