/// Frequency options for [RecurrenceHelper].
enum RecurrenceFrequency {
  /// Every day
  daily,

  /// Every week on same weekday
  weekly,

  /// Every month on same day
  monthly,

  /// Every year on same date
  yearly,
}

/// Generates recurring [DateTime] values based on a pattern.
///
/// ```dart
/// // Daily for 7 days
/// RecurrenceHelper.generate(
///   start: DateTime(2024, 6, 1),
///   frequency: RecurrenceFrequency.daily,
///   count: 7,
/// )
///
/// // Weekly every Monday for 4 weeks
/// RecurrenceHelper.generate(
///   start: DateTime(2024, 6, 3), // Monday
///   frequency: RecurrenceFrequency.weekly,
///   count: 4,
/// )
///
/// // Monthly until end of year
/// RecurrenceHelper.generate(
///   start: DateTime(2024, 1, 15),
///   frequency: RecurrenceFrequency.monthly,
///   until: DateTime(2024, 12, 31),
/// )
/// ```
class RecurrenceHelper {
  RecurrenceHelper._();

  /// Generates a list of recurring dates.
  ///
  /// Either [count] or [until] must be provided — not both.
  ///
  /// ```dart
  /// RecurrenceHelper.generate(
  ///   start: DateTime(2024, 6, 1),
  ///   frequency: RecurrenceFrequency.daily,
  ///   count: 30,
  ///   skipWeekends: true,
  /// )
  /// ```
  static List<DateTime> generate({
    required DateTime start,
    required RecurrenceFrequency frequency,
    int? count,
    DateTime? until,
    bool skipWeekends = false,
    List<DateTime> skipHolidays = const [],
    bool includeStart = true,
  }) {
    assert(
      count != null || until != null,
      'Either count or until must be provided',
    );
    assert(
      count == null || until == null,
      'Cannot provide both count and until',
    );

    final results = <DateTime>[];
    DateTime current = start;
    int generated = 0;
    final maxCount = count ?? 10000;

    if (includeStart && _shouldInclude(start, skipWeekends, skipHolidays)) {
      results.add(start);
      generated++;
    }

    while (true) {
      current = _next(current, frequency);

      if (until != null && current.isAfter(until)) break;
      if (count != null && generated >= maxCount) break;

      if (_shouldInclude(current, skipWeekends, skipHolidays)) {
        results.add(current);
        generated++;
      }
    }

    return results;
  }

  /// Generates daily recurring dates.
  ///
  /// ```dart
  /// RecurrenceHelper.daily(
  ///   start: DateTime(2024, 6, 1),
  ///   count: 7,
  /// )
  /// ```
  static List<DateTime> daily({
    required DateTime start,
    int? count,
    DateTime? until,
    bool skipWeekends = false,
    List<DateTime> skipHolidays = const [],
  }) =>
      generate(
        start: start,
        frequency: RecurrenceFrequency.daily,
        count: count,
        until: until,
        skipWeekends: skipWeekends,
        skipHolidays: skipHolidays,
      );

  /// Generates weekly recurring dates.
  ///
  /// ```dart
  /// RecurrenceHelper.weekly(
  ///   start: DateTime(2024, 6, 3), // Monday
  ///   count: 8,
  /// )
  /// ```
  static List<DateTime> weekly({
    required DateTime start,
    int? count,
    DateTime? until,
    bool skipWeekends = false,
    List<DateTime> skipHolidays = const [],
  }) =>
      generate(
        start: start,
        frequency: RecurrenceFrequency.weekly,
        count: count,
        until: until,
        skipWeekends: skipWeekends,
        skipHolidays: skipHolidays,
      );

  /// Generates monthly recurring dates.
  ///
  /// ```dart
  /// RecurrenceHelper.monthly(
  ///   start: DateTime(2024, 1, 15),
  ///   count: 12,
  /// )
  /// ```
  static List<DateTime> monthly({
    required DateTime start,
    int? count,
    DateTime? until,
    List<DateTime> skipHolidays = const [],
  }) =>
      generate(
        start: start,
        frequency: RecurrenceFrequency.monthly,
        count: count,
        until: until,
        skipHolidays: skipHolidays,
      );

  /// Generates yearly recurring dates.
  ///
  /// ```dart
  /// RecurrenceHelper.yearly(
  ///   start: DateTime(2024, 6, 15),
  ///   count: 5,
  /// )
  /// ```
  static List<DateTime> yearly({
    required DateTime start,
    int? count,
    DateTime? until,
    List<DateTime> skipHolidays = const [],
  }) =>
      generate(
        start: start,
        frequency: RecurrenceFrequency.yearly,
        count: count,
        until: until,
        skipHolidays: skipHolidays,
      );

  /// Returns next occurrence after [date] for given [frequency].
  ///
  /// ```dart
  /// RecurrenceHelper.nextOccurrence(
  ///   DateTime(2024, 6, 15),
  ///   RecurrenceFrequency.weekly,
  /// ) // June 22
  /// ```
  static DateTime nextOccurrence(
    DateTime date,
    RecurrenceFrequency frequency,
  ) =>
      _next(date, frequency);

  // ── Private helpers ───────────────────────────────────────────

  static DateTime _next(DateTime date, RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return date.add(const Duration(days: 1));
      case RecurrenceFrequency.weekly:
        return date.add(const Duration(days: 7));
      case RecurrenceFrequency.monthly:
        return DateTime(date.year, date.month + 1, date.day);
      case RecurrenceFrequency.yearly:
        return DateTime(date.year + 1, date.month, date.day);
    }
  }

  static bool _shouldInclude(
    DateTime date,
    bool skipWeekends,
    List<DateTime> skipHolidays,
  ) {
    if (skipWeekends &&
        (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday)) {
      return false;
    }
    if (skipHolidays.isNotEmpty) {
      final target = DateTime(date.year, date.month, date.day);
      final isHoliday = skipHolidays.any(
          (h) => DateTime(h.year, h.month, h.day).isAtSameMomentAs(target));
      if (isHoliday) return false;
    }
    return true;
  }
}
