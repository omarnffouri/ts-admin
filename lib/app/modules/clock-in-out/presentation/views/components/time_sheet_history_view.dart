import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/calendar_hours_widget.dart';

import 'calendar_appointment_widget.dart';

class TimeSheetHistoryView extends GetView<ClockInOutController> {
  const TimeSheetHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Obx(
      () => Row(
        children: [
          Expanded(
            child: SfCalendar(
              onViewChanged: (viewChangedDetails) {
                controller.calendarViewStart.value =
                    viewChangedDetails.visibleDates.first;
              },
              view: CalendarView.month,
              allowViewNavigation: true,
              dataSource: controller.getCalendarDataSource(),
              initialDisplayDate: DateTime.now(),
              initialSelectedDate: DateTime.now(),
              firstDayOfWeek: 7,
              todayHighlightColor: Get.isDarkMode
                  ? AppColorsDark.clockInOutRedColor
                  : const Color.fromARGB(255, 155, 2, 7),
              todayTextStyle: const TextStyle(color: Colors.white),
              maxDate:
                  DateTime(DateTime.now().year, (DateTime.now().month + 1), 0),
              showDatePickerButton: false,
              showNavigationArrow: true,
              showTodayButton: false,
              showCurrentTimeIndicator: true,
              showWeekNumber: true,
              weekNumberStyle:
                  WeekNumberStyle(textStyle: theme.textTheme.bodySmall),
              viewHeaderStyle:
                  ViewHeaderStyle(dayTextStyle: theme.textTheme.bodySmall),
              headerStyle:
                  CalendarHeaderStyle(textStyle: theme.textTheme.titleLarge),
              cellBorderColor: Get.isDarkMode
                  ? const Color.fromARGB(255, 49, 49, 49)
                  : AppColorsLight.calanderBoxColor,

              appointmentBuilder: (context, appointmentDetails) {
                return CalendarAppointmentWidget(
                  appointment: appointmentDetails.appointments.first,
                );
              },

              /// Calendar styling and layout
              monthViewSettings: MonthViewSettings(
                appointmentDisplayCount: 6,
                numberOfWeeksInView: 6,
                showAgenda: true,
                agendaViewHeight: Get.height * 0.35,
                agendaItemHeight: 40,
                showTrailingAndLeadingDates: false,
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                monthCellStyle:
                    MonthCellStyle(textStyle: theme.textTheme.bodyMedium),
              ),
              selectionDecoration: BoxDecoration(
                border: Border.all(color: AppColorsLight.mainColor),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Obx(
            () => LoadingWrapperWidget(
              isLoading: controller.isLoadingTimeSheetHours,
              child: const CalendarHoursWidget(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildLoadingWidgetForBody() {
  //   return Shimmer.fromColors(
  //     baseColor: AppColorsLight.bodyBackgroundColor,
  //     highlightColor: Colors.grey,
  //     period: const Duration(milliseconds: 800),
  //     child: SfCalendar(
  //       view: CalendarView.month,
  //       initialDisplayDate: DateTime.now(),
  //       firstDayOfWeek: 7,
  //       todayHighlightColor: AppColorsLight.mainColor,
  //       minDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
  //       maxDate: DateTime(DateTime.now().year, (DateTime.now().month + 1), 0),
  //       showDatePickerButton: false,
  //       showNavigationArrow: false,
  //       showTodayButton: false,
  //       showCurrentTimeIndicator: true,
  //       showWeekNumber: true,
  //       monthViewSettings: MonthViewSettings(
  //         appointmentDisplayCount: 6,
  //         numberOfWeeksInView: 6,
  //         showAgenda: true,
  //         agendaViewHeight: 220.h,
  //         agendaItemHeight: 40,
  //         showTrailingAndLeadingDates: false,
  //         appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
  //       ),
  //     ),
  //   );
  // }
}
