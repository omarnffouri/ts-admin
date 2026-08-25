import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/controllers/forms_controller.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

class FormListCardView extends GetView<FormsController> {
  final FormEntity formEntity;
  final int index;
  final bool isPending;
  const FormListCardView(
      {super.key,
      required this.formEntity,
      required this.index,
      required this.isPending});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isSigned = formEntity.isSigned ?? false;

    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: index == 0 ? 10 : 5,
        bottom: index ==
                ((isPending
                        ? controller.pendingForms.length
                        : controller.signedForms.length) -
                    1)
            ? 16
            : 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor,
        border: Border.all(
          color: isDark
              ? Colors.white.applyOpacity(0.08)
              : Colors.black.applyOpacity(0.05),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            Get.toNamed(Routes.FORM_DETAIL_VIEW, arguments: formEntity);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        formEntity.applicantName ?? "",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      isSigned
                          ? Icons.check_circle_rounded
                          : Icons.pending_actions_rounded,
                      size: 25,
                      color: isSigned
                          ? Colors.green
                          : isDark
                              ? Colors.white
                              : AppColorsLight.mainColor,
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Assigned by: ${formEntity.assignBy?.firstName ?? ""} ${formEntity.assignBy?.lastName ?? ""}",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      DateFormat('MMM/dd/yyyy \'at\' hh:mm a')
                          .format(formEntity.createdAt ?? DateTime.now()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey : Colors.black54,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
