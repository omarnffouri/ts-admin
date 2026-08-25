class MuteEnums {
  static const hours = "8_hours";
  static const week = "1_week";
  static const always = "always";
  static const unmute = null;

  static String getName(String state) {
    if (state == hours) {
      return "8 hours";
    } else if (state == week) {
      return "1 week";
    } else {
      return "Always";
    }
  }
}
