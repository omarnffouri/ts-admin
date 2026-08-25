import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/views/tabs/completed_tasks_tab.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/views/tabs/pending_tasks_tab.dart';
import 'package:ts_admin/app/modules/task_management/presentation/task_management/views/tabs/requested_tasks_tab.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../controllers/task_management_controller.dart';

class TaskManagementView extends GetView<TaskManagementController> {
  const TaskManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: Column(
          children: [
            _TaskManagementHeader(
              controller: controller.tabController,
            ),
            Expanded(
              child: _BodyReveal(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.r),
                      bottomRight: Radius.circular(25.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.r),
                      bottomRight: Radius.circular(25.r),
                    ),
                    child: TabBarView(
                      controller: controller.tabController,
                      children: const [
                        PendingTasksTab(),
                        RequestedTasksTab(),
                        CompletedTasksTab(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 65),
          child: InkWell(
            onTap: () {
              Get.toNamed(Routes.CREATE_TASK);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: AppColorsLight.mainColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _TaskManagementHeader extends StatelessWidget {
  const _TaskManagementHeader({
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      radius: 30.r,
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task Management",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.08,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Text(
                      "Track work across todo, requested, and completed tasks.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.applyOpacity(0.78),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: Colors.white.applyOpacity(0.16),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _TaskSegmentedTabs(controller: controller),
        ],
      ),
    );
  }
}

class _BodyReveal extends StatelessWidget {
  const _BodyReveal({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _TaskSegmentedTabs extends StatelessWidget {
  const _TaskSegmentedTabs({
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    // In light mode, mirror the Messages header: a solid white pill for the
    // selected segment with the brand-red label. Dark mode keeps its existing
    // shadow-only treatment.
    final bool isLight = !Get.isDarkMode;

    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white.applyOpacity(0.15),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.applyOpacity(0.20),
        ),
      ),
      child: TabBar(
        controller: controller,
        dividerHeight: 0,
        labelPadding: EdgeInsets.zero,
        splashBorderRadius: BorderRadius.circular(14.r),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: isLight ? Colors.white : null,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.applyOpacity(isLight ? 0.12 : 0.14),
              blurRadius: isLight ? 8 : 18,
              offset: Offset(0, isLight ? 3 : 8),
            ),
          ],
        ),
        labelColor: isLight ? AppColorsLight.mainColor : AppColorsLight.white,
        unselectedLabelColor: isLight
            ? Colors.white.applyOpacity(0.9)
            : Colors.grey.applyOpacity(0.9),
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          _SegmentTab(label: "Todo"),
          _SegmentTab(label: "Requested"),
          _SegmentTab(label: "Completed"),
        ],
      ),
    );
  }
}

class _SegmentTab extends StatelessWidget {
  const _SegmentTab({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40.h,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        style: DefaultTextStyle.of(context).style,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CreateTaskButton extends StatefulWidget {
  const _CreateTaskButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_CreateTaskButton> createState() => _CreateTaskButtonState();
}

class _CreateTaskButtonState extends State<_CreateTaskButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            borderRadius: BorderRadius.circular(999),
            child: Ink(
              padding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 13.h,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColorsLight.mainColorLight,
                    AppColorsLight.mainColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: Colors.white.applyOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
