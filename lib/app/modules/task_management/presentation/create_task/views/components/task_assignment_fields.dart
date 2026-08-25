import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';

import '../../../../domain/entities/task_dropdown_entity.dart';
import '../../controllers/create_task_controller.dart';

/// "Assign to" and "Report to" — the same shared searchable dropdown widget
/// used twice with identical styling, preserving the existing user list,
/// self-exclusion for "Assign to", and default "Report to" selection.
class TaskAssignmentFields extends GetView<CreateTaskController> {
  const TaskAssignmentFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Assign to, optional',
          child: Obx(
            () => LoadingWrapperWidget(
              isLoading: controller.isLoading.value,
              child: _buildField(
                context,
                fieldLabel: 'Assign to',
                fieldHint: 'assign to',
                emptyMessage: 'No team members available to assign.',
                list: controller.taskDropdowns
                    .where((user) =>
                        user.id != controller.authController.user.value?.id)
                    .toList(),
                selectedItem: controller.selectedAssignTo.value,
                onItemSelected: (item) {
                  if (item != null) controller.selectedAssignTo(item);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          label: 'Report to, optional',
          child: Obx(
            () => LoadingWrapperWidget(
              isLoading: controller.isLoading.value,
              child: _buildField(
                context,
                fieldLabel: 'Report to',
                fieldHint: 'report to',
                emptyMessage: 'No team members available to report to.',
                list: controller.taskDropdowns,
                selectedItem: controller.selectedReportTo.value,
                onItemSelected: (item) {
                  if (item != null) controller.selectedReportTo(item);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String fieldLabel,
    required String fieldHint,
    required String emptyMessage,
    required List<TaskDropdownsEntity> list,
    required TaskDropdownsEntity? selectedItem,
    required void Function(TaskDropdownsEntity?) onItemSelected,
  }) {
    if (!controller.isLoading.value && list.isEmpty) {
      return _EmptyDropdownState(
        message: emptyMessage,
        onRetry: controller.getTaskDropdowns,
      );
    }

    return SearchableDropDown<TaskDropdownsEntity>(
      list: list,
      bottomSheetLabel: 'Select user',
      searchHint: 'search by name',
      fieldLabel: fieldLabel,
      fieldHint: fieldHint,
      isRequired: false,
      selectedItem: selectedItem,
      dropdownSearchDecoration: SearchableDropdownDecoration.bordered,
      dropdownDecoration: SearchableDropdownDecoration.bordered,
      onItemSelected: onItemSelected,
      itemAsString: (item) => item.name ?? '',
      compareFunction: (item1, item2) => item1 == item2,
      getName: (p0) => p0.name ?? '',
      getImage: (p0) => p0.image ?? '',
      getSubTitle: (p0) => p0.designation ?? '',
    );
  }
}

class _EmptyDropdownState extends StatelessWidget {
  const _EmptyDropdownState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.tertiaryTextColor,
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Retry loading team members',
            child: TextButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded,
                  size: 16, color: context.brandColor),
              label: Text(
                'Retry',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: context.brandColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
