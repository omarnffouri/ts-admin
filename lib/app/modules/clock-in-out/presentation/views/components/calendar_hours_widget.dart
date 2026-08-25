import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/clock_in_out_controller.dart';

class CalendarHoursWidget extends GetView<ClockInOutController> {
  const CalendarHoursWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(1),
            color: Colors.green,
            child: Text(
              "Total ${controller.totalHours.value.toStringAsFixed(1)}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              final weeks = controller.weekHours;
              if (weeks.isEmpty) {
                return Center(
                  child: Text(
                    "—",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: weeks.length,
                itemBuilder: (context, index) {
                  final week = weeks[index];
                  return Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      week.weeklyHours.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          // Container(
          //   padding: const EdgeInsets.all(4),
          //   color: Colors.green,
          //   child: const Text(
          //     "Total",
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
          // const SizedBox(
          //   height: 12,
          // ),
          // Obx(() => Expanded(
          //       child: Text(
          //         "${controller.totalHours.value}",
          //         style: const TextStyle(
          //             color: Colors.green, fontWeight: FontWeight.bold),
          //       ),
          //     )),
        ],
      ),
    );
  }
}
