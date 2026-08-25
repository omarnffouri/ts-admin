import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/app_text.dart';
import 'package:ts_admin/app/core/widgets/inline_error_retry.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/modules/leave_management/presentation/new_leave_request/views/components/select_alternatives_widget.dart';

import '../../../domain/entities/remaining_leave_category_entity.dart';
import '../controllers/new_leave_request_controller.dart';
import 'components/date_range_picker_widget.dart';
import 'components/leave_type_widget.dart';
import 'components/profile_details_widget.dart';
import 'components/select_manager_widget.dart';
import 'components/signature_widget.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class NewLeaveRequestView extends GetView<NewLeaveRequestController> {
  const NewLeaveRequestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SmartRefresher(
              controller: controller.refreshController,
              header: const WaterDropMaterialHeader(),
              onRefresh: controller.handleRefresh,
              child: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                    sliver: SliverToBoxAdapter(
                      child: KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) {
                          if (isKeyboardVisible) {
                            controller.scrollToTop();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SectionCard(
                                title: 'Leave Balance',
                                child: _RemainingLeavesStrip(
                                    controller: controller),
                              ),
                              const SizedBox(height: 16),
                              const _SectionCard(
                                title: 'Employee Information',
                                child: ProfileDetailsWidget(),
                              ),
                              const SizedBox(height: 16),
                              _SectionCard(
                                title: 'Leave Details',
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 4),
                                    const LeaveTypeWidget(),
                                    const DateRangePickerWidget(),
                                    _EligibilityStatus(controller: controller),
                                  ],
                                ),
                              ),
                              Obx(
                                () => Visibility(
                                  visible: controller.isEligible.value &&
                                      !controller
                                          .isCheckEligibilityLoading.value,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 16),
                                      _SectionCard(
                                        title: 'Duration',
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text:
                                                  "${controller.eligibility.value.totalDaysOff ?? 0} ${controller.eligibility.value.totalDaysOff == 1 ? "Day" : "Days"}",
                                              size: 22,
                                              weight: FontWeight.bold,
                                            ),
                                            if (controller.fromDateController
                                                    .text.isNotEmpty &&
                                                controller.toDateController.text
                                                    .isNotEmpty)
                                              DateRangeViewWidget(
                                                  controller: controller),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _SectionCard(
                                        title: 'Approval & Reason',
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const SizedBox(height: 6),
                                            const SelectManagerWidget(),
                                            const SelectAlternativesWidget(),
                                            const SizedBox(height: 4),
                                            ReasonTextWidget(
                                                controller: controller),
                                            const SizedBox(height: 16),
                                            const SignatureWidget(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Obx(
                                        () => MainAppButton(
                                          label: 'Submit',
                                          height: 52,
                                          borderRadius: 14,
                                          isLoading: controller.isSubmitting,
                                          onPressed:
                                              controller.submitLeaveRequest,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Brand-red app header (matches the rest of the app) with a back button and
/// the screen title.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      radius: 32,
      padding: EdgeInsets.fromLTRB(12, topInset + 12, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Request Leave',
              maxLines: 1,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable card that gives every section the same premium container styling
/// used across the app (rounded, subtly bordered, soft shadow, theme-aware).
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.applyOpacity(0.08)
              : const Color(0xFFEDEDED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.applyOpacity(0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Eligibility feedback (loading bar + eligible/not-eligible message) shown
/// right under the date range field.
class _EligibilityStatus extends StatelessWidget {
  const _EligibilityStatus({required this.controller});

  final NewLeaveRequestController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCheckEligibilityLoading.value) {
        return const Padding(
          padding: EdgeInsets.only(top: 4),
          child: LinearProgressIndicator(
            color: AppColorsLight.mainColor,
            backgroundColor: Colors.transparent,
          ),
        );
      }
      if (controller.elegibilityText.isEmpty) return const SizedBox.shrink();

      final bool eligible = controller.isEligible.value;
      final Color color = eligible ? Colors.green : AppColorsLight.mainColor;
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Icon(
              eligible ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                controller.elegibilityText.value,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

const double _kCalRowHeight = 32;
const double _kCalDowHeight = 16;

/// Read-only visualization of the selected leave range. When the range spans
/// multiple months, the months are shown side by side (mirroring the old
/// multi-view date picker).
class DateRangeViewWidget extends StatelessWidget {
  const DateRangeViewWidget({
    super.key,
    required this.controller,
  });

  final NewLeaveRequestController controller;

  List<DateTime> _monthsBetween(DateTime from, DateTime to) {
    final months = <DateTime>[];
    var cursor = DateTime(from.year, from.month);
    final last = DateTime(to.year, to.month);
    while (!cursor.isAfter(last)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return months;
  }

  int _weekRows(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final days = DateTime(month.year, month.month + 1, 0).day;
    return ((first.weekday % 7) + days + 6) ~/ 7;
  }

  String _label(List<DateTime> months) {
    final fmt = DateFormat('MMMM yyyy');
    return months.length == 1
        ? fmt.format(months.first)
        : '${fmt.format(months.first)} - ${fmt.format(months.last)}';
  }

  @override
  Widget build(BuildContext context) {
    final from = DateTime.parse(controller.fromDateController.text);
    final to = DateTime.parse(controller.toDateController.text);
    final months = _monthsBetween(from, to);
    final isDark = Get.isDarkMode;
    final maxRows = months.map(_weekRows).reduce((a, b) => a > b ? a : b);
    final calHeight = maxRows * _kCalRowHeight + _kCalDowHeight + 2;
    const monthGap = 16.0;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.applyOpacity(0.04) : const Color(0xFFF4F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              _label(months),
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Months side by side with a gap between them (mirrors the old
          // multi-view). Two fit the width; three or more scroll horizontally.
          SizedBox(
            height: calHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final monthWidth = months.length == 1
                    ? constraints.maxWidth
                    : (constraints.maxWidth - monthGap) / 2;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: months.length <= 2
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      for (var i = 0; i < months.length; i++) ...[
                        if (i > 0) const SizedBox(width: monthGap),
                        SizedBox(
                          width: monthWidth,
                          child: _MonthRangeView(
                            month: months[i],
                            from: from,
                            to: to,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A single read-only month with the portion of [from]..[to] that falls inside
/// it highlighted.
class _MonthRangeView extends StatelessWidget {
  const _MonthRangeView({
    required this.month,
    required this.from,
    required this.to,
  });

  final DateTime month;
  final DateTime from;
  final DateTime to;

  @override
  Widget build(BuildContext context) {
    const accent = AppColorsLight.mainColor;
    final isDark = Get.isDarkMode;
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    // Off-range days are muted so the highlighted range stands out, the way the
    // old multi-view did.
    final mutedColor = isDark ? Colors.grey.shade500 : Colors.grey.shade600;
    const dayStyle = TextStyle(fontSize: 12.5);
    final mutedDayStyle = dayStyle.copyWith(color: mutedColor);
    const endpointDeco = BoxDecoration(color: accent, shape: BoxShape.circle);
    const rangeText = TextStyle(color: Colors.white, fontSize: 12.5);

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: firstDay,
      currentDay: DateTime.now(),
      rangeStartDay: from,
      rangeEndDay: to,
      rangeSelectionMode: RangeSelectionMode.enforced,
      availableGestures: AvailableGestures.none,
      headerVisible: false,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      rowHeight: _kCalRowHeight,
      daysOfWeekHeight: _kCalDowHeight,
      sixWeekMonthsEnforced: false,
      onDaySelected: (_, __) {},
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          const letters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
          return Center(
            child: Text(
              letters[day.weekday % 7],
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
          );
        },
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        cellMargin: const EdgeInsets.all(2),
        defaultTextStyle: mutedDayStyle,
        weekendTextStyle: mutedDayStyle,
        disabledTextStyle: dayStyle.copyWith(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade400,
        ),
        isTodayHighlighted: true,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: accent.applyOpacity(0.7)),
        ),
        todayTextStyle: mutedDayStyle,
        rangeHighlightColor: accent.applyOpacity(0.5),
        rangeStartDecoration: endpointDeco,
        rangeEndDecoration: endpointDeco,
        rangeStartTextStyle: rangeText.copyWith(fontWeight: FontWeight.w600),
        rangeEndTextStyle: rangeText.copyWith(fontWeight: FontWeight.w600),
        withinRangeTextStyle: rangeText,
      ),
    );
  }
}

class ReasonTextWidget extends StatelessWidget {
  const ReasonTextWidget({
    super.key,
    required this.controller,
  });

  final NewLeaveRequestController controller;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    return TextFormField(
      controller: controller.reasonTxtController,
      style: Get.theme.textTheme.titleMedium,
      minLines: 3,
      maxLines: 5,
      textInputAction: TextInputAction.newline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a reason';
        }
        return null;
      },
      onTapOutside: (value) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        labelText: 'Reason *',
        hintText: 'Enter reason',
        alignLabelWithHint: true,
        labelStyle: Get.theme.textTheme.titleSmall,
        hintStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 1.4, color: AppColorsLight.mainColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _RemainingLeavesStrip extends StatelessWidget {
  const _RemainingLeavesStrip({required this.controller});

  final NewLeaveRequestController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool loading = controller.isRemainingLoading.value;
      final categories = controller.categories;
      if (!loading && controller.errorWhileLoadingRemaining.value) {
        return InlineErrorRetry(
          message: "Couldn't load your leave balance.",
          onRetry: controller.getRemainingLeavesPerCategory,
        );
      }
      if (!loading && categories.isEmpty) {
        return Text(
          'No leave balance available.',
          style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        );
      }

      final int count = loading ? 5 : categories.length;

      return SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: count,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) => loading
              ? const _LeaveStatTile.skeleton()
              : _LeaveStatTile(category: categories[i]),
        ),
      );
    });
  }
}

class _LeaveStatTile extends StatelessWidget {
  const _LeaveStatTile({required this.category}) : isSkeleton = false;
  const _LeaveStatTile.skeleton()
      : category = null,
        isSkeleton = true;

  final RemainingLeaveCategoryEntity? category;
  final bool isSkeleton;

  String get _value {
    final parsed = double.tryParse(category?.remaining ?? '');
    if (parsed == null) return category?.remaining ?? '-';
    return parsed == parsed.roundToDouble()
        ? parsed.toInt().toString()
        : parsed.toString();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color tileColor = isDark
        ? Colors.white.applyOpacity(0.05)
        : AppColorsLight.mainColor.applyOpacity(0.05);
    final Color skeletonBar = isDark
        ? Colors.white.applyOpacity(0.12)
        : Colors.black.applyOpacity(0.06);

    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.applyOpacity(0.06)
              : AppColorsLight.mainColor.applyOpacity(0.10),
        ),
      ),
      child: isSkeleton
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(skeletonBar, width: 20, height: 20, radius: 10),
                const SizedBox(height: 12),
                _bar(skeletonBar, width: 32, height: 18),
                const SizedBox(height: 6),
                _bar(skeletonBar, width: 60, height: 10),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.event_available_rounded,
                  color: isDark
                      ? AppColorsLight.mainColorLight
                      : AppColorsLight.mainColor,
                  size: 20,
                ),
                Text(
                  _value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
                Text(
                  category?.leaveType ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.applyOpacity(0.6)
                        : Colors.black.applyOpacity(0.55),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _bar(
    Color color, {
    required double width,
    required double height,
    double radius = 5,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
