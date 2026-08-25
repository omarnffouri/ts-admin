import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/helpers/date_helper.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../controllers/create_task_controller.dart';
import 'components/task_assignment_fields.dart';
import 'components/task_attachment_picker.dart';
import 'components/task_form_section.dart';
import 'components/task_text_field.dart';

class CreateTaskView extends GetView<CreateTaskController> {
  const CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            //
            // header
            const _Header(),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        // task information
                        TaskFormSection(
                          icon: Icons.assignment_outlined,
                          title: 'Task Information',
                          children: [
                            KeyedSubtree(
                              key: controller.titleFieldKey,
                              child: TaskTextField(
                                controller: controller.titleController,
                                focusNode: controller.titleFocusNode,
                                label: 'Title',
                                hintText: 'Enter task title',
                                isRequired: true,
                                prefixIcon: Icons.title_rounded,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(controller.categoryFocusNode),
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "Title is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const _CategoryDueDateRow(),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //
                        // assignment
                        const TaskFormSection(
                          icon: Icons.groups_outlined,
                          title: 'Assignment',
                          children: [TaskAssignmentFields()],
                        ),

                        const SizedBox(height: 20),

                        //
                        // description
                        TaskFormSection(
                          icon: Icons.notes_rounded,
                          title: 'Description',
                          children: [
                            KeyedSubtree(
                              key: controller.descriptionFieldKey,
                              child: TaskTextField(
                                controller: controller.descriptionController,
                                focusNode: controller.descriptionFocusNode,
                                label: 'Description',
                                hintText: 'Describe the task…',
                                isRequired: true,
                                maxLength: 1500,
                                maxLines: 5,
                                minLines: 4,
                                showCounter: true,
                                textInputAction: TextInputAction.newline,
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "Description is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //
                        // attachments — creation only, matching the
                        // existing behavior of hiding the picker on update
                        Obx(
                          () => controller.task.value == null
                              ? const TaskFormSection(
                                  icon: Icons.attach_file_rounded,
                                  title: 'Attachment',
                                  children: [TaskAttachmentPicker()],
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 24),

                        //
                        // create/update task button
                        Obx(
                          () => Semantics(
                            button: true,
                            label: controller.task.value == null
                                ? 'Create Task'
                                : 'Update Task',
                            child: MainAppButton(
                              label: controller.task.value == null
                                  ? "Create Task"
                                  : "Update Task",
                              isLoading: controller.isSubmitting.value,
                              onPressed: () => _onSubmit(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (controller.isSubmitting.value) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final bool isValid = controller.formKey.currentState?.validate() ?? false;
    if (!isValid) {
      final GlobalKey? invalidFieldKey = controller.firstInvalidFieldKey;
      final BuildContext? invalidContext = invalidFieldKey?.currentContext;
      if (invalidContext != null) {
        Scrollable.ensureVisible(
          invalidContext,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: 0.1,
        );
      }
    }

    if (controller.task.value == null) {
      controller.createTask();
    } else {
      controller.updateTask();
    }
  }
}

/// Category and Due Date share a row when there's enough width and the
/// text isn't scaled up too far; otherwise they stack to avoid overflow.
class _CategoryDueDateRow extends GetView<CreateTaskController> {
  const _CategoryDueDateRow();

  @override
  Widget build(BuildContext context) {
    final bool largeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;

    final Widget category = KeyedSubtree(
      key: controller.categoryFieldKey,
      child: TaskTextField(
        controller: controller.categoryController,
        focusNode: controller.categoryFocusNode,
        label: 'Category',
        hintText: 'Enter category',
        isRequired: true,
        prefixIcon: Icons.category_outlined,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
        ],
        validator: (p0) {
          if (p0 == null || p0.isEmpty) {
            return "Category is required";
          }
          return null;
        },
      ),
    );

    final Widget dueDate = KeyedSubtree(
      key: controller.dueDateFieldKey,
      child: TaskTextField(
        controller: controller.dueDateController,
        label: 'Due Date',
        hintText: 'Select date',
        isRequired: true,
        readOnly: true,
        prefixIcon: Icons.calendar_today_outlined,
        validator: (p0) {
          if (p0 == null || p0.isEmpty) {
            return "Due date is required";
          }
          return null;
        },
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          controller.pickedDate = await DateHelper.pickDate(
            DateTime.now(),
            DateTime(2050),
            controller.pickedDate ?? DateTime.now(),
          );
          if (controller.pickedDate != null) {
            final String formattedDate =
                DateFormat('yyyy-MM-dd').format(controller.pickedDate!);
            controller.dueDateController.text = formattedDate;
          }
        },
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool stack = largeText || constraints.maxWidth < 340;
        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [category, const SizedBox(height: 16), dueDate],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: category),
            const SizedBox(width: 14),
            Expanded(flex: 2, child: dueDate),
          ],
        );
      },
    );
  }
}

class _Header extends GetView<CreateTaskController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, topInset + 10.h, 16.w, 16.h),
      child: Row(
        children: [
          //
          // back button
          Semantics(
            button: true,
            label: 'Back',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: Colors.white.applyOpacity(0.16),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.applyOpacity(0.22),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          //
          // heading
          Expanded(
            child: Obx(
              () => Text(
                "${controller.task.value != null ? "Update" : "Create"} Task",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
