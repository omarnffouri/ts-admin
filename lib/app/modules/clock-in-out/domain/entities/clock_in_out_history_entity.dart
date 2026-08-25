// To parse this JSON data, do
//
//     final clockInOutHistoryDataEntity = clockInOutHistoryDataEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

ClockInOutHistoryDataEntity clockInOutHistoryDataEntityFromJson(String str) =>
    ClockInOutHistoryDataEntity.fromJson(json.decode(str));

String clockInOutHistoryDataEntityToJson(ClockInOutHistoryDataEntity data) =>
    json.encode(data.toJson());

class ClockInOutHistoryDataEntity extends Equatable {
  final DateTime? clockin;
  final DateTime? clockout;
  final int? userId;
  final String? eventTitle;
  final DateTime? start;
  final DateTime? end;
  final String? clockinTime;
  final String? clockoutTime;
  final String? duration;
  final bool? showTimer;

  const ClockInOutHistoryDataEntity({
    this.clockin,
    this.clockout,
    this.userId,
    this.eventTitle,
    this.start,
    this.end,
    this.clockinTime,
    this.clockoutTime,
    this.duration,
    this.showTimer,
  });

  factory ClockInOutHistoryDataEntity.fromJson(Map<String, dynamic> json) =>
      ClockInOutHistoryDataEntity(
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

  @override
  List<Object?> get props => [
        clockin,
        clockout,
        userId,
        eventTitle,
        start,
        end,
        clockinTime,
        clockoutTime,
        duration,
        showTimer,
      ];
}
