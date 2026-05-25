/// Holiday detection and working day utilities with holiday support.
///
/// ```dart
/// final holidays = [
///   DateTime(2024, 12, 25), // Christmas
///   DateTime(2024, 1, 26),  // Republic Day
/// ];
///
/// DateTime.now().isHoliday(holidays: holidays)     // false
/// DateTime(2024,12,25).isHoliday(holidays: holidays) // true
/// DateTime.now().addWorkingDaysWithHolidays(5, holidays: holidays)
/// ```
class HolidayHelper {
  HolidayHelper._();

  /// Returns true if [date] is in [holidays] list.
  ///
  /// Comparison is done by date only — time is ignored.
  ///
  /// ```dart
  /// HolidayHelper.isHoliday(
  ///   DateTime(2024, 12, 25),
  ///   holidays: [DateTime(2024, 12, 25)],
  /// ) // true
  /// ```
  static bool isHoliday(
    DateTime date, {
    required List<DateTime> holidays,
  }) {
    final target = DateTime(date.year, date.month, date.day);
    return holidays
        .any((h) => DateTime(h.year, h.month, h.day).isAtSameMomentAs(target));
  }

  /// Returns true if [date] is a working day —
  /// not a weekend AND not in [holidays].
  ///
  /// ```dart
  /// HolidayHelper.isWorkingDay(
  ///   DateTime(2024, 6, 17), // Monday
  ///   holidays: [],
  /// ) // true
  /// ```
  static bool isWorkingDay(
    DateTime date, {
    List<DateTime> holidays = const [],
  }) {
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return false;
    }
    return !isHoliday(date, holidays: holidays);
  }

  /// Adds [days] working days to [date], skipping weekends and [holidays].
  ///
  /// ```dart
  /// HolidayHelper.addWorkingDays(
  ///   DateTime(2024, 12, 23), // Monday
  ///   3,
  ///   holidays: [DateTime(2024, 12, 25)], // Christmas
  /// ) // Dec 27 (skips Sat, Sun, Christmas)
  /// ```
  static DateTime addWorkingDays(
    DateTime date,
    int days, {
    List<DateTime> holidays = const [],
  }) {
    DateTime result = date;
    int added = 0;
    final direction = days >= 0 ? 1 : -1;
    final target = days.abs();

    while (added < target) {
      result = result.add(Duration(days: direction));
      if (isWorkingDay(result, holidays: holidays)) {
        added++;
      }
    }
    return result;
  }

  /// Returns number of working days between [start] and [end],
  /// excluding weekends and [holidays].
  ///
  /// ```dart
  /// HolidayHelper.workingDaysBetween(
  ///   DateTime(2024, 12, 23),
  ///   DateTime(2024, 12, 27),
  ///   holidays: [DateTime(2024, 12, 25)],
  /// ) // 2 (Mon + Fri, skipping Wed Christmas)
  /// ```
  static int workingDaysBetween(
    DateTime start,
    DateTime end, {
    List<DateTime> holidays = const [],
  }) {
    int count = 0;
    DateTime current = start;
    while (current.isBefore(end)) {
      if (isWorkingDay(current, holidays: holidays)) {
        count++;
      }
      current = current.add(const Duration(days: 1));
    }
    return count;
  }

  /// Returns all holidays in [year] from [holidays] list.
  ///
  /// ```dart
  /// HolidayHelper.holidaysInYear(
  ///   2024,
  ///   holidays: [DateTime(2024,1,26), DateTime(2024,12,25)],
  /// )
  /// ```
  static List<DateTime> holidaysInYear(
    int year, {
    required List<DateTime> holidays,
  }) =>
      holidays.where((h) => h.year == year).toList();

  /// Returns next working day from [date] skipping weekends and [holidays].
  ///
  /// ```dart
  /// HolidayHelper.nextWorkingDay(DateTime(2024, 12, 25))
  /// // Dec 26 (if not holiday) or Dec 27
  /// ```
  static DateTime nextWorkingDay(
    DateTime date, {
    List<DateTime> holidays = const [],
  }) =>
      addWorkingDays(date, 1, holidays: holidays);

  /// Returns previous working day from [date].
  static DateTime previousWorkingDay(
    DateTime date, {
    List<DateTime> holidays = const [],
  }) =>
      addWorkingDays(date, -1, holidays: holidays);

  /// Common Indian public holidays for [year].
  ///
  /// ```dart
  /// final holidays = HolidayHelper.indianHolidays(2024);
  /// date.isHoliday(holidays: holidays)
  /// ```
  static List<DateTime> indianHolidays(int year) => [
        DateTime(year, 1, 26), // Republic Day
        DateTime(year, 8, 15), // Independence Day
        DateTime(year, 10, 2), // Gandhi Jayanti
        DateTime(year, 10, 24), // Dussehra (approximate)
        DateTime(year, 11, 1), // Diwali (approximate)
        DateTime(year, 11, 15), // Guru Nanak Jayanti (approximate)
        DateTime(year, 12, 25), // Christmas
        DateTime(year, 1, 1), // New Year
      ];

  /// Common global public holidays for [year].
  static List<DateTime> globalHolidays(int year) => [
        DateTime(year, 1, 1), // New Year's Day
        DateTime(year, 12, 25), // Christmas
        DateTime(year, 12, 26), // Boxing Day
      ];
}

/// Extension on [DateTime] for holiday support.
extension HolidayExtension on DateTime {
  /// Returns true if this date is in [holidays].
  ///
  /// ```dart
  /// DateTime(2024, 12, 25).isHoliday(
  ///   holidays: [DateTime(2024, 12, 25)],
  /// ) // true
  /// ```
  bool isHoliday({required List<DateTime> holidays}) =>
      HolidayHelper.isHoliday(this, holidays: holidays);

  /// Returns true if this date is a working day.
  ///
  /// ```dart
  /// DateTime(2024, 6, 17).isWorkingDay() // true — Monday
  /// ```
  bool isWorkingDay({List<DateTime> holidays = const []}) =>
      HolidayHelper.isWorkingDay(this, holidays: holidays);

  /// Adds [days] working days skipping weekends and [holidays].
  ///
  /// ```dart
  /// DateTime(2024, 12, 23).addWorkingDaysWithHolidays(
  ///   3,
  ///   holidays: [DateTime(2024, 12, 25)],
  /// )
  /// ```
  DateTime addWorkingDaysWithHolidays(
    int days, {
    List<DateTime> holidays = const [],
  }) =>
      HolidayHelper.addWorkingDays(this, days, holidays: holidays);

  /// Working days until [other] skipping weekends and [holidays].
  int workingDaysUntilWithHolidays(
    DateTime other, {
    List<DateTime> holidays = const [],
  }) =>
      HolidayHelper.workingDaysBetween(this, other, holidays: holidays);
}
