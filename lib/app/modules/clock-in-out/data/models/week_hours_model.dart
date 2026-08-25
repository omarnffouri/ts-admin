import 'package:ts_admin/app/modules/clock-in-out/domain/entities/week_hours_entity.dart';

class WeekHoursResponseModel extends WeekHoursEntity {
  WeekHoursResponseModel({
    required super.userId,
    required super.month,
    required super.totalHours,
    required List<WeekModel> super.weeks,
  });

  factory WeekHoursResponseModel.fromJson(Map<String, dynamic> json) {
    return WeekHoursResponseModel(
      userId: json['user_id'] ?? 0,
      month: json['month'] ?? '',
      totalHours: (json['total_hours'] ?? 0).toDouble(),
      weeks: (json['weeks'] as List<dynamic>?)
              ?.map((e) => WeekModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "month": month,
        "total_hours": totalHours,
        "weeks": weeks.map((e) => (e as WeekModel).toJson()).toList(),
      };
}

class WeekModel extends WeekEntity {
  WeekModel({
    required super.weekStart,
    required super.weekEnd,
    required super.weekNumber,
    required super.weeklyHours,
  });

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    return WeekModel(
      weekStart: json['week_start'] ?? '',
      weekEnd: json['week_end'] ?? '',
      weekNumber: json['week_number'] ?? 0,
      weeklyHours: (json['weekly_hours'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "week_start": weekStart,
        "week_end": weekEnd,
        "week_number": weekNumber,
        "weekly_hours": weeklyHours,
      };
}
