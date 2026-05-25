/// Groups a list of [DateTime] values by various time periods.
///
/// Useful for activity feeds, analytics dashboards,
/// and calendar views.
///
/// ```dart
/// final dates = [DateTime(2024,6,1), DateTime(2024,6,1,14,0),
///                DateTime(2024,6,2), DateTime(2024,6,8)];
///
/// DateGrouper.byDay(dates)
/// // {'2024-06-01': [DateTime, DateTime], '2024-06-02': [DateTime], ...}
///
/// DateGrouper.byMonth(dates)
/// // {'2024-06': [DateTime, DateTime, DateTime, DateTime]}
/// ```
class DateGrouper {
  DateGrouper._();

  /// Groups [dates] by day.
  ///
  /// Key format: `'yyyy-MM-dd'` e.g. `'2024-06-15'`
  ///
  /// ```dart
  /// final grouped = DateGrouper.byDay(dates);
  /// grouped['2024-06-15'] // [DateTime, DateTime]
  /// ```
  static Map<String, List<DateTime>> byDay(List<DateTime> dates) {
    final map = <String, List<DateTime>>{};
    for (final date in dates) {
      final key = '${date.year}-${_pad(date.month)}-${_pad(date.day)}';
      map.putIfAbsent(key, () => []).add(date);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Groups [dates] by week (ISO week — Monday start).
  ///
  /// Key format: `'yyyy-W{week}'` e.g. `'2024-W24'`
  ///
  /// ```dart
  /// final grouped = DateGrouper.byWeek(dates);
  /// grouped['2024-W24'] // [DateTime, DateTime]
  /// ```
  static Map<String, List<DateTime>> byWeek(List<DateTime> dates) {
    final map = <String, List<DateTime>>{};
    for (final date in dates) {
      final weekNum = _weekOfYear(date);
      final key = '${date.year}-W${_pad(weekNum)}';
      map.putIfAbsent(key, () => []).add(date);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Groups [dates] by month.
  ///
  /// Key format: `'yyyy-MM'` e.g. `'2024-06'`
  ///
  /// ```dart
  /// final grouped = DateGrouper.byMonth(dates);
  /// grouped['2024-06'] // [DateTime, DateTime, DateTime]
  /// ```
  static Map<String, List<DateTime>> byMonth(List<DateTime> dates) {
    final map = <String, List<DateTime>>{};
    for (final date in dates) {
      final key = '${date.year}-${_pad(date.month)}';
      map.putIfAbsent(key, () => []).add(date);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Groups [dates] by quarter.
  ///
  /// Key format: `'yyyy-Q{n}'` e.g. `'2024-Q2'`
  ///
  /// ```dart
  /// final grouped = DateGrouper.byQuarter(dates);
  /// grouped['2024-Q2'] // [DateTime, DateTime]
  /// ```
  static Map<String, List<DateTime>> byQuarter(List<DateTime> dates) {
    final map = <String, List<DateTime>>{};
    for (final date in dates) {
      final q = ((date.month - 1) ~/ 3) + 1;
      final key = '${date.year}-Q$q';
      map.putIfAbsent(key, () => []).add(date);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Groups [dates] by year.
  ///
  /// Key format: `'yyyy'` e.g. `'2024'`
  ///
  /// ```dart
  /// final grouped = DateGrouper.byYear(dates);
  /// grouped['2024'] // [DateTime, DateTime, DateTime]
  /// ```
  static Map<String, List<DateTime>> byYear(List<DateTime> dates) {
    final map = <String, List<DateTime>>{};
    for (final date in dates) {
      final key = '${date.year}';
      map.putIfAbsent(key, () => []).add(date);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Groups [dates] by hour of day (0–23).
  ///
  /// Key format: `'HH'` e.g. `'14'`
  ///
  /// ```dart
  /// final grouped = DateGrouper.byHour(dates);
  /// grouped['14'] // [DateTime, DateTime] — 2PM events
  /// ```
  static Map<String, List<DateTime>> byHour(List<DateTime> dates) {
    final map = <String, List<DateTime>>{};
    for (final date in dates) {
      final key = _pad(date.hour);
      map.putIfAbsent(key, () => []).add(date);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Groups [dates] by weekday name.
  ///
  /// Key format: weekday name e.g. `'Monday'`
  ///
  /// ```dart
  /// final grouped = DateGrouper.byWeekday(dates);
  /// grouped['Monday'] // [DateTime, DateTime]
  /// ```
  static Map<String, List<DateTime>> byWeekday(List<DateTime> dates) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final map = <String, List<DateTime>>{};
    for (final date in dates) {
      final key = days[date.weekday - 1];
      map.putIfAbsent(key, () => []).add(date);
    }
    // Sort by weekday order
    return Map.fromEntries(
      days.where(map.containsKey).map((day) => MapEntry(day, map[day]!)),
    );
  }

  /// Returns count of dates per group for [byDay].
  ///
  /// ```dart
  /// DateGrouper.countByDay(dates)
  /// // {'2024-06-15': 3, '2024-06-16': 1}
  /// ```
  static Map<String, int> countByDay(List<DateTime> dates) =>
      byDay(dates).map((k, v) => MapEntry(k, v.length));

  /// Returns count of dates per group for [byMonth].
  ///
  /// ```dart
  /// DateGrouper.countByMonth(dates)
  /// // {'2024-06': 10, '2024-07': 8}
  /// ```
  static Map<String, int> countByMonth(List<DateTime> dates) =>
      byMonth(dates).map((k, v) => MapEntry(k, v.length));

  /// Returns count of dates per group for [byWeekday].
  ///
  /// ```dart
  /// DateGrouper.countByWeekday(dates)
  /// // {'Monday': 5, 'Tuesday': 3, ...}
  /// ```
  static Map<String, int> countByWeekday(List<DateTime> dates) =>
      byWeekday(dates).map((k, v) => MapEntry(k, v.length));

  /// Returns the most active day key from [byDay] grouping.
  ///
  /// ```dart
  /// DateGrouper.mostActiveDay(dates) // '2024-06-15'
  /// ```
  static String? mostActiveDay(List<DateTime> dates) {
    if (dates.isEmpty) return null;
    final counts = countByDay(dates);
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  /// Returns the most active weekday name.
  ///
  /// ```dart
  /// DateGrouper.mostActiveWeekday(dates) // 'Monday'
  /// ```
  static String? mostActiveWeekday(List<DateTime> dates) {
    if (dates.isEmpty) return null;
    final counts = countByWeekday(dates);
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  /// Returns the most active hour (0–23).
  ///
  /// ```dart
  /// DateGrouper.mostActiveHour(dates) // 14 (2PM)
  /// ```
  static int? mostActiveHour(List<DateTime> dates) {
    if (dates.isEmpty) return null;
    final counts = byHour(dates).map((k, v) => MapEntry(k, v.length));
    final key = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    return int.parse(key);
  }

  /// Returns average gap between consecutive dates as [Duration].
  ///
  /// ```dart
  /// DateGrouper.averageGap(dates) // Duration(days: 2)
  /// ```
  static Duration? averageGap(List<DateTime> dates) {
    if (dates.length < 2) return null;
    final sorted = List<DateTime>.from(dates)..sort();
    int totalSeconds = 0;
    for (int i = 1; i < sorted.length; i++) {
      totalSeconds += sorted[i].difference(sorted[i - 1]).inSeconds;
    }
    return Duration(seconds: totalSeconds ~/ (sorted.length - 1));
  }

  // ── Private helpers ───────────────────────────────────────────

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static int _weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear + firstDayOfYear.weekday - 2) / 7).ceil().clamp(1, 53);
  }
}
