import 'dart:convert';

import 'package:ts_admin/app/modules/clock-in-out/domain/entities/check_clock_in_entity.dart';

CheckClockInDataModel checkClockInDataModelFromJson(String str) =>
    CheckClockInDataModel.fromJson(json.decode(str));

String checkClockInDataModelToJson(CheckClockInDataModel data) =>
    json.encode(data.toJson());

class CheckClockInDataModel extends CheckClockInDataEntity {
  const CheckClockInDataModel({
    super.autoStart,
    super.clockedIn,
    super.date,
    super.startStopWatchFrom,
  });

  factory CheckClockInDataModel.fromJson(Map<String, dynamic> json) =>
      CheckClockInDataModel(
        autoStart: json["autoStart"],
        clockedIn: json["clockedIn"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        startStopWatchFrom: (json["startStopWatchFrom"] as num?)?.toDouble(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "autoStart": autoStart,
        "clockedIn": clockedIn,
        "date": date?.toIso8601String(),
        "startStopWatchFrom": startStopWatchFrom,
      };
}
