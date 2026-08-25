import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/time_sheet_history_view.dart';

/// Opens the timesheet history (calendar + hours) in a centered dialog.
void showTimesheetDialog(ClockInOutController controller) {
  // Refresh the calendar data each time the dialog is opened.
  controller.refreshCalendarData(date: controller.selectedDateFormatted);
  Get.dialog(const _TimesheetDialog());
}

/// A widget rather than a bare tree so the theme tokens resolve against the
/// dialog's own context instead of whatever screen happened to open it.
class _TimesheetDialog extends StatelessWidget {
  const _TimesheetDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.isDark ? const Color(0xFF161618) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: Get.width,
        height: Get.height * 0.82,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.brandColor.applyOpacity(0.14),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: AppColorsLight.mainColorLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Timesheet history",
                      style: TextStyle(
                        color: context.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: Icon(
                      Icons.close_rounded,
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: context.hairlineBorderColor),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: Get.height * 0.95,
                  child: const TimeSheetHistoryView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
