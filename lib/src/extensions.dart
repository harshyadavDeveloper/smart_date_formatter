import 'package:smart_date_formatter/src/date_calculations.dart';

import 'formatter.dart';
import 'date_format_helper.dart';

/// Smart DateTime extensions
extension SmartDateExtension on DateTime {
  static const _formatter = SmartDateFormatter();

  // ─────────────────────────────────────────
  // EXISTING — Relative & Smart Strings
  // ─────────────────────────────────────────

  /// Returns relative time string
  /// ```dart
  /// DateTime.now().subtract(Duration(hours: 2)).timeAgo // "2 hours ago"
  /// DateTime.now().add(Duration(days: 1)).timeAgo       // "Tomorrow"
  /// ```
  String get timeAgo => _formatter.format(this);

  /// Returns calendar string
  /// ```dart
  /// DateTime.now().calendar                              // "Today"
  /// DateTime.now().add(Duration(days: 2)).calendar      // "Wednesday"
  /// ```
  String get calendar => _formatter.calendar(this);

  /// Returns short timestamp
  /// ```dart
  /// DateTime.now().shortTimestamp                        // "2:30 PM"
  /// ```
  String get shortTimestamp => _formatter.shortTimestamp(this);

  // ─────────────────────────────────────────
  // NEW v0.1.0 — Custom Format
  // ─────────────────────────────────────────

  /// Format date using custom pattern
  ///
  /// Tokens: dd, d, MM, MMM, MMMM, yyyy, yy,
  ///         HH, hh, mm, ss, a, EEEE, EEE
  ///
  /// ```dart
  /// DateTime(2024,6,15,14,30).format('dd-MM-yyyy')   // "15-06-2024"
  /// DateTime(2024,6,15,14,30).format('MMM dd, yyyy') // "Jun 15, 2024"
  /// DateTime(2024,6,15,14,30).format('EEEE')         // "Saturday"
  /// DateTime(2024,6,15,14,30).format('hh:mm a')      // "02:30 PM"
  /// ```
  String format(String pattern) => DateFormatHelper.format(this, pattern);

  /// Returns "Saturday, 15 June 2024"
  String get toReadable => DateFormatHelper.format(this, 'EEEE, dd MMMM yyyy');

  /// Returns ISO 8601 without milliseconds — "2024-06-15T14:30:00"
  String get toISO => toIso8601String().split('.').first;

  /// Returns 24-hour time string — "14:30:00"
  String get toTimeString => DateFormatHelper.format(this, 'HH:mm:ss');

  /// Returns 12-hour format — "02:30 PM"
  String get to12Hour => DateFormatHelper.format(this, 'hh:mm a');

  /// Returns 24-hour format — "14:30"
  String get to24Hour => DateFormatHelper.format(this, 'HH:mm');

  // ─────────────────────────────────────────
  // EXISTING — Boolean Helpers
  // ─────────────────────────────────────────

  /// Whether this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date was yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Whether this date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Whether this date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Whether this date is in the future
  bool get isFuture => isAfter(DateTime.now());

  // ─────────────────────────────────────────
  // EXISTING — Utility
  // ─────────────────────────────────────────

  /// Start of the day — 2024-06-15 00:00:00
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of the day — 2024-06-15 23:59:59
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  // ─────────────────────────────────────────
  // NEW v0.5.0 — Date Calculations & Range
  // ─────────────────────────────────────────

  /// Adds [days] working days — skips weekends
  /// ```dart
  /// DateTime.now().addWorkingDays(5)  // 5 business days later
  /// DateTime.now().addWorkingDays(-3) // 3 business days ago
  /// ```
  DateTime addWorkingDays(int days) =>
      DateCalculations.addWorkingDays(this, days);

  /// Days until [other] date — positive if future, negative if past
  /// ```dart
  /// DateTime.now().daysUntil(deadline) // 15
  /// ```
  int daysUntil(DateTime other) => DateCalculations.daysBetween(this, other);

  /// Days since [other] date
  /// ```dart
  /// DateTime.now().daysSince(joinDate) // 30
  /// ```
  int daysSince(DateTime other) => DateCalculations.daysBetween(other, this);

  /// Whether this date falls between [start] and [end] (inclusive)
  /// ```dart
  /// someDate.isBetween(startDate, endDate) // true/false
  /// ```
  bool isBetween(DateTime start, DateTime end) =>
      DateCalculations.isBetween(this, start, end);

  /// Whether this date is a weekend (Saturday or Sunday)
  bool get isWeekend => DateCalculations.isWeekend(this);

  /// Whether this date is a weekday (Monday–Friday)
  bool get isWeekday => DateCalculations.isWeekday(this);

  /// Age in years from this date to today
  /// ```dart
  /// DateTime(1999, 5, 20).age // 25
  /// ```
  int get age => DateCalculations.age(this);

  /// Start of the week — Monday 00:00:00
  DateTime get startOfWeek => DateCalculations.startOfWeek(this);

  /// End of the week — Sunday 23:59:59
  DateTime get endOfWeek => DateCalculations.endOfWeek(this);

  /// Start of the month — 1st 00:00:00
  DateTime get startOfMonth => DateCalculations.startOfMonth(this);

  /// End of the month — last day 23:59:59
  DateTime get endOfMonth => DateCalculations.endOfMonth(this);

  /// Start of the year — Jan 1 00:00:00
  DateTime get startOfYear => DateCalculations.startOfYear(this);

  /// End of the year — Dec 31 23:59:59
  DateTime get endOfYear => DateCalculations.endOfYear(this);

  /// Number of working days between this and [other]
  int workingDaysUntil(DateTime other) =>
      DateCalculations.workingDaysBetween(this, other);
}
