import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarAppointmentWidget extends StatelessWidget {
  final Appointment appointment;
  const CalendarAppointmentWidget({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appointment.subject,
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (appointment.subject.toLowerCase().contains("out") ||
              appointment.subject.toLowerCase().contains("end"))
            Text(
              appointment.notes ?? "",
              style: const TextStyle(color: Colors.white),
            ).paddingOnly(left: 10),
          const Spacer(),
          Text(
            getDateTimeFormatedString(appointment.startTime),
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

String getDateTimeFormatedString(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}
