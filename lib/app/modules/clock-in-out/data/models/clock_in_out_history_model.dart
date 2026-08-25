// To parse this JSON data, do
//
//     final clockInOutHistoryDataEntity = clockInOutHistoryDataEntityFromJson(jsonString);

import 'dart:convert';

import 'package:ts_admin/app/modules/clock-in-out/domain/entities/clock_in_out_history_entity.dart';

ClockInOutHistoryDataModel clockInOutHistoryDataModelFromJson(String str) =>
    ClockInOutHistoryDataModel.fromJson(json.decode(str));

String clockInOutHistoryDataModelToJson(ClockInOutHistoryDataModel data) =>
    json.encode(data.toJson());

class ClockInOutHistoryDataModel extends ClockInOutHistoryDataEntity {
  const ClockInOutHistoryDataModel({
    super.clockin,
    super.clockout,
    super.userId,
    super.eventTitle,
    super.start,
    super.end,
    super.clockinTime,
    super.clockoutTime,
    super.duration,
    super.showTimer,
  });

  factory ClockInOutHistoryDataModel.fromJson(Map<String, dynamic> json) =>
      ClockInOutHistoryDataModel(
        clockin: json["clockin"] == null
            ? null
            : DateTime.parse(json["clockin"]).toLocal(),
        clockout: json["clockout"] == null
            ? null
            : DateTime.parse(json["clockout"]).toLocal(),
        userId: json["user_id"],
        eventTitle: json["event_title"],
        start: json["start"] == null
            ? null
            : DateTime.parse(json["start"]).toLocal(),
        end: json["end"] == null ? null : DateTime.parse(json["end"]).toLocal(),
        clockinTime: json["clockin_time"],
        clockoutTime: json["clockout_time"],
        duration: json["duration"],
        showTimer: json["show_timer"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "clockin": clockin?.toIso8601String(),
        "clockout": clockout?.toIso8601String(),
        "user_id": userId,
        "event_title": eventTitle,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "clockin_time": clockinTime,
        "clockout_time": clockoutTime,
        "duration": duration,
        "show_timer": showTimer,
      };
}
