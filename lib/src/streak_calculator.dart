/// Calculates streaks from a list of [DateTime] values.
///
/// Useful for habit trackers, attendance systems,
/// workout apps, and daily check-ins.
///
/// ```dart
/// final dates = [
///   DateTime(2024, 6, 1),
///   DateTime(2024, 6, 2),
///   DateTime(2024, 6, 3),
///   DateTime(2024, 6, 5), // gap on 4th
///   DateTime(2024, 6, 6),
/// ];
///
/// StreakCalculator.currentStreak(dates)  // 2
/// StreakCalculator.longestStreak(dates)  // 3
/// StreakCalculator.isTodayCompleted(dates) // false
/// ```
class StreakCalculator {
  StreakCalculator._();

  /// Returns the current active streak count.
  ///
  /// Counts consecutive days ending today or yesterday.
  /// If today is not in [dates], checks if yesterday was
  /// the last completed day.
  ///
  /// ```dart
  /// StreakCalculator.currentStreak(attendanceDates) // 7
  /// ```
  static int currentStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    final unique = _uniqueDays(dates)..sort();
    final today = _day(DateTime.now());
    final yesterday = _day(DateTime.now().subtract(const Duration(days: 1)));

    // Must end today or yesterday to be active
    if (unique.last != today && unique.last != yesterday) return 0;

    int streak = 1;
    for (int i = unique.length - 1; i > 0; i--) {
      final diff = unique[i].difference(unique[i - 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Returns the longest streak ever in [dates].
  ///
  /// ```dart
  /// StreakCalculator.longestStreak(dates) // 21
  /// ```
  static int longestStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    final unique = _uniqueDays(dates)..sort();
    int longest = 1;
    int current = 1;

    for (int i = 1; i < unique.length; i++) {
      final diff = unique[i].difference(unique[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }
    return longest;
  }

  /// Returns true if today is in [dates].
  ///
  /// ```dart
  /// StreakCalculator.isTodayCompleted(dates) // true
  /// ```
  static bool isTodayCompleted(List<DateTime> dates) {
    final today = _day(DateTime.now());
    return _uniqueDays(dates).contains(today);
  }

  /// Returns total number of completed days in [dates].
  ///
  /// ```dart
  /// StreakCalculator.totalCompleted(dates) // 45
  /// ```
  static int totalCompleted(List<DateTime> dates) => _uniqueDays(dates).length;

  /// Returns completion rate as percentage (0.0 – 1.0)
  /// between [start] and [end] dates.
  ///
  /// ```dart
  /// StreakCalculator.completionRate(
  ///   dates,
  ///   start: DateTime(2024, 6, 1),
  ///   end: DateTime(2024, 6, 30),
  /// ) // 0.8 (80%)
  /// ```
  static double completionRate(
    List<DateTime> dates, {
    required DateTime start,
    required DateTime end,
  }) {
    final totalDays = end.difference(start).inDays + 1;
    if (totalDays <= 0) return 0;

    final completed = _uniqueDays(dates).where((d) {
      return (d.isAfter(start) || d == _day(start)) &&
          (d.isBefore(end) || d == _day(end));
    }).length;

    return completed / totalDays;
  }

  /// Returns all streak runs as a list of lists.
  ///
  /// ```dart
  /// StreakCalculator.allStreaks(dates)
  /// // [[Jun1, Jun2, Jun3], [Jun5, Jun6]]
  /// ```
  static List<List<DateTime>> allStreaks(List<DateTime> dates) {
    if (dates.isEmpty) return [];

    final unique = _uniqueDays(dates)..sort();
    final streaks = <List<DateTime>>[];
    var current = [unique.first];

    for (int i = 1; i < unique.length; i++) {
      final diff = unique[i].difference(unique[i - 1]).inDays;
      if (diff == 1) {
        current.add(unique[i]);
      } else {
        streaks.add(List.from(current));
        current = [unique[i]];
      }
    }
    streaks.add(current);
    return streaks;
  }

  /// Returns number of days missed between [start] and today.
  ///
  /// ```dart
  /// StreakCalculator.missedDays(dates, start: DateTime(2024,6,1)) // 5
  /// ```
  static int missedDays(
    List<DateTime> dates, {
    required DateTime start,
  }) {
    final end = DateTime.now();
    final totalDays = end.difference(start).inDays + 1;
    return totalDays - totalCompleted(dates);
  }

  /// Returns the last completed date or null.
  ///
  /// ```dart
  /// StreakCalculator.lastCompletedDate(dates) // DateTime(2024,6,15)
  /// ```
  static DateTime? lastCompletedDate(List<DateTime> dates) {
    if (dates.isEmpty) return null;
    final unique = _uniqueDays(dates)..sort();
    return unique.last;
  }

  // ── Private helpers ───────────────────────────────────────────

  static DateTime _day(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static List<DateTime> _uniqueDays(List<DateTime> dates) =>
      dates.map(_day).toSet().toList();
}
