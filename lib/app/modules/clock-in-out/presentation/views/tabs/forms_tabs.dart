import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../../core/widgets/tasks_empty_state.dart';

class FormsTab extends GetView<ClockInOutController> {
  const FormsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Obx(
        () => controller.isLoadingForms
            ? _buildLoadingView()
            : controller.forms.isEmpty
                ? const TasksEmptyState(
                    bgColor: Colors.transparent,
                    title: "Thank You!",
                    descrption: "All Done for the Moment",
                    radius: 0,
                    padding: 0,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.forms.length,
                    itemBuilder: (context, index) {
                      final form = controller.forms[index];
                      return InkWell(
                        onTap: () async {
                          await Get.toNamed(Routes.FORM_DETAIL_VIEW,
                              arguments: form);
                          controller.getAllForms();
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: index == 0 ? 15 : 5,
                            bottom: 5,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: context.isDark
                                ? context.tileColor
                                : Colors.grey.shade200,
                            border: context.isDark
                                ? Border.all(color: context.hairlineBorderColor)
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      form.applicantName ?? "",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                  Icon(
                                    Icons.pending_actions_rounded,
                                    size: 25,
                                    color: context.isDark
                                        ? Colors.white
                                        : AppColorsLight.mainColor,
                                  )
                                ],
                              ),
                              Text(
                                "Assigned by: ${form.assignBy?.firstName ?? ""} ${form.assignBy?.lastName ?? ""}",
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  Text(
                                    DateFormat('MMM/dd/yyyy \'at\' hh:mm a')
                                        .format(
                                            form.createdAt ?? DateTime.now()),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: context.isDark
                                          ? Colors.grey
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColorsLight.shimmerBaseColor,
          highlightColor: Colors.grey.shade300,
          child: Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: index == 0 ? 15 : 5,
              bottom: 5,
            ),
            width: Get.width * 1,
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.isDark ? Colors.white12 : Colors.grey.shade200,
            ),
            constraints: const BoxConstraints(minHeight: 70),
          ),
        );
      },
    );
  }
}
