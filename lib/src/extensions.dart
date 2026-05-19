import 'package:smart_date_formatter/src/date_calculations.dart';
import 'package:smart_date_formatter/src/localization.dart';

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

  /// Returns relative time in given locale
  /// ```dart
  /// DateTime.now().subtract(Duration(hours:2)).timeAgoIn(SdfLocale.hi)
  /// // "2 घंटे पहले"
  /// ```
  String timeAgoIn(SdfLocale locale) =>
      SmartDateFormatter(locale: locale).format(this);

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

  // ─────────────────────────────────────────
  // NEW v1.1.0 — Quarter & Week Helpers
  // ─────────────────────────────────────────

  /// Quarter of the year (1–4)
  /// ```dart
  /// DateTime(2024, 6, 15).quarter // 2
  /// DateTime(2024, 1, 1).quarter  // 1
  /// ```
  int get quarter => ((month - 1) ~/ 3) + 1;

  /// Whether this date is in Q1 (Jan–Mar)
  bool get isQ1 => quarter == 1;

  /// Whether this date is in Q2 (Apr–Jun)
  bool get isQ2 => quarter == 2;

  /// Whether this date is in Q3 (Jul–Sep)
  bool get isQ3 => quarter == 3;

  /// Whether this date is in Q4 (Oct–Dec)
  bool get isQ4 => quarter == 4;

  /// Week number of the year (1–53)
  /// ```dart
  /// DateTime(2024, 1, 1).weekOfYear  // 1
  /// DateTime(2024, 6, 15).weekOfYear // 24
  /// ```
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final dayOfYear = difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear + firstDayOfYear.weekday - 2) / 7).ceil().clamp(1, 53);
  }

  /// Day number of the year (1–366)
  /// ```dart
  /// DateTime(2024, 1, 1).dayOfYear   // 1
  /// DateTime(2024, 6, 15).dayOfYear  // 167
  /// ```
  int get dayOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    return difference(firstDayOfYear).inDays + 1;
  }

  /// Whether this year is a leap year
  /// ```dart
  /// DateTime(2024, 1, 1).isLeapYear // true
  /// DateTime(2023, 1, 1).isLeapYear // false
  /// ```
  bool get isLeapYear =>
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  // ─────────────────────────────────────────
  // NEW v1.1.0 — Time of Day
  // ─────────────────────────────────────────

  /// Whether time is morning (6AM–12PM)
  bool get isMorning => hour >= 6 && hour < 12;

  /// Whether time is afternoon (12PM–5PM)
  bool get isAfternoon => hour >= 12 && hour < 17;

  /// Whether time is evening (5PM–9PM)
  bool get isEvening => hour >= 17 && hour < 21;

  /// Whether time is night (9PM–6AM)
  bool get isNight => hour >= 21 || hour < 6;

  // ─────────────────────────────────────────
  // NEW v1.1.0 — Same Day/Week/Month/Year
  // ─────────────────────────────────────────

  /// Whether this date is the same day as [other]
  /// ```dart
  /// DateTime(2024,6,15).isSameDay(DateTime(2024,6,15,14,30)) // true
  /// ```
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Whether this date is in the same week as [other]
  bool isSameWeek(DateTime other) {
    final thisMonday = subtract(Duration(days: weekday - 1));
    final otherMonday = other.subtract(Duration(days: other.weekday - 1));
    return DateTime(thisMonday.year, thisMonday.month, thisMonday.day) ==
        DateTime(otherMonday.year, otherMonday.month, otherMonday.day);
  }

  /// Whether this date is in the same month as [other]
  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  /// Whether this date is in the same year as [other]
  bool isSameYear(DateTime other) => year == other.year;

  // ─────────────────────────────────────────
  // NEW v1.1.0 — Next / Previous Weekday
  // ─────────────────────────────────────────

  /// Next occurrence of [weekday] (1=Mon, 7=Sun)
  DateTime _nextWeekday(int targetWeekday) {
    int diff = targetWeekday - weekday;
    if (diff <= 0) diff += 7;
    return DateTime(year, month, day + diff);
  }

  /// Previous occurrence of [weekday] (1=Mon, 7=Sun)
  DateTime _previousWeekday(int targetWeekday) {
    int diff = weekday - targetWeekday;
    if (diff <= 0) diff += 7;
    return DateTime(year, month, day - diff);
  }

  /// Next Monday from this date
  DateTime get nextMonday => _nextWeekday(DateTime.monday);

  /// Next Tuesday from this date
  DateTime get nextTuesday => _nextWeekday(DateTime.tuesday);

  /// Next Wednesday from this date
  DateTime get nextWednesday => _nextWeekday(DateTime.wednesday);

  /// Next Thursday from this date
  DateTime get nextThursday => _nextWeekday(DateTime.thursday);

  /// Next Friday from this date
  DateTime get nextFriday => _nextWeekday(DateTime.friday);

  /// Next Saturday from this date
  DateTime get nextSaturday => _nextWeekday(DateTime.saturday);

  /// Next Sunday from this date
  DateTime get nextSunday => _nextWeekday(DateTime.sunday);

  /// Previous Monday from this date
  DateTime get previousMonday => _previousWeekday(DateTime.monday);

  /// Previous Tuesday from this date
  DateTime get previousTuesday => _previousWeekday(DateTime.tuesday);

  /// Previous Wednesday from this date
  DateTime get previousWednesday => _previousWeekday(DateTime.wednesday);

  /// Previous Thursday from this date
  DateTime get previousThursday => _previousWeekday(DateTime.thursday);

  /// Previous Friday from this date
  DateTime get previousFriday => _previousWeekday(DateTime.friday);

  /// Previous Saturday from this date
  DateTime get previousSaturday => _previousWeekday(DateTime.saturday);

  /// Previous Sunday from this date
  DateTime get previousSunday => _previousWeekday(DateTime.sunday);

  // ─────────────────────────────────────────
  // NEW v1.1.0 — copyWith
  // ─────────────────────────────────────────

  /// Returns a copy of this DateTime with given fields replaced
  /// ```dart
  /// DateTime.now().copyWith(hour: 0, minute: 0, second: 0) // today at midnight
  /// DateTime.now().copyWith(day: 1)                         // first of this month
  /// ```
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
      );
}
