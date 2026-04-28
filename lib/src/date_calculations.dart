/// Date calculation and range utilities.
/// No external dependencies — pure Dart.
class DateCalculations {
  /// Returns the number of days between [date] and [other].
  /// Positive if [other] is in the future, negative if in the past.
  static int daysBetween(DateTime date, DateTime other) {
    final from = DateTime(date.year, date.month, date.day);
    final to = DateTime(other.year, other.month, other.day);
    return to.difference(from).inDays;
  }

  /// Returns true if [date] falls between [start] and [end] (inclusive).
  static bool isBetween(DateTime date, DateTime start, DateTime end) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return (d.isAtSameMomentAs(s) || d.isAfter(s)) &&
        (d.isAtSameMomentAs(e) || d.isBefore(e));
  }

  /// Adds [days] working days to [date] — skips Saturdays & Sundays.
  static DateTime addWorkingDays(DateTime date, int days) {
    DateTime result = date;
    int added = 0;
    final direction = days >= 0 ? 1 : -1;
    final target = days.abs();

    while (added < target) {
      result = result.add(Duration(days: direction));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        added++;
      }
    }
    return result;
  }

  /// Returns the age in years from [birthDate] to today.
  static int age(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  /// Returns start of the week (Monday 00:00:00) for [date].
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    final monday = date.subtract(Duration(days: daysFromMonday));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Returns end of the week (Sunday 23:59:59) for [date].
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = DateTime.sunday - date.weekday;
    final sunday = date.add(Duration(days: daysToSunday));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999);
  }

  /// Returns start of the month (1st 00:00:00) for [date].
  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  /// Returns end of the month (last day 23:59:59) for [date].
  static DateTime endOfMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59, 999);
  }

  /// Returns start of the year (Jan 1 00:00:00) for [date].
  static DateTime startOfYear(DateTime date) => DateTime(date.year, 1, 1);

  /// Returns end of the year (Dec 31 23:59:59) for [date].
  static DateTime endOfYear(DateTime date) =>
      DateTime(date.year, 12, 31, 23, 59, 59, 999);

  /// Returns true if [date] is a weekend (Saturday or Sunday).
  static bool isWeekend(DateTime date) =>
      date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

  /// Returns true if [date] is a weekday (Monday–Friday).
  static bool isWeekday(DateTime date) => !isWeekend(date);

  /// Returns the number of working days between [start] and [end].
  static int workingDaysBetween(DateTime start, DateTime end) {
    int count = 0;
    DateTime current = start;
    while (current.isBefore(end)) {
      if (current.weekday != DateTime.saturday &&
          current.weekday != DateTime.sunday) {
        count++;
      }
      current = current.add(const Duration(days: 1));
    }
    return count;
  }
}
