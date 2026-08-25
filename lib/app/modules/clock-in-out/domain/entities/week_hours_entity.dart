class WeekHoursEntity {
  final int userId;
  final String month;
  final double totalHours;
  final List<WeekEntity> weeks;

  WeekHoursEntity({
    required this.userId,
    required this.month,
    required this.totalHours,
    required this.weeks,
  });
}

class WeekEntity {
  final String weekStart;
  final String weekEnd;
  final int weekNumber;
  final double weeklyHours;

  WeekEntity({
    required this.weekStart,
    required this.weekEnd,
    required this.weekNumber,
    required this.weeklyHours,
  });
}
