/// Represents a date range with [start] and [end].
class DateRange {
  /// Start of the range (inclusive)
  final DateTime start;

  /// End of the range (inclusive)
  final DateTime end;

  /// Creates a [DateRange] with given [start] and [end] dates.
  const DateRange({required this.start, required this.end});

  /// Duration of this range
  Duration get duration => end.difference(start);

  /// Number of days in this range
  int get days => end.difference(start).inDays + 1;

  /// Whether [date] falls within this range (inclusive)
  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return (d.isAtSameMomentAs(start) || d.isAfter(start)) &&
        (d.isAtSameMomentAs(end) || d.isBefore(end));
  }

  /// Whether this range overlaps with [other]
  bool overlaps(DateRange other) =>
      start.isBefore(other.end) && end.isAfter(other.start);

  @override
  String toString() => 'DateRange($start → $end)';

  @override
  bool operator ==(Object other) =>
      other is DateRange && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// Ready-made date ranges — perfect for database queries,
/// analytics filters, and calendar views.
///
/// ```dart
/// final range = DateRangeHelper.thisWeek();
/// final orders = await db.query(
///   where: 'created_at BETWEEN ? AND ?',
///   whereArgs: [range.start.toIso8601String(), range.end.toIso8601String()],
/// );
/// ```
class DateRangeHelper {
  DateRangeHelper._();

  // ── Today ────────────────────────────────────────────────────────

  /// Today — 00:00:00 to 23:59:59
  static DateRange today({DateTime? now}) {
    final ref = now ?? DateTime.now();
    return DateRange(
      start: DateTime(ref.year, ref.month, ref.day),
      end: DateTime(ref.year, ref.month, ref.day, 23, 59, 59, 999),
    );
  }

  /// Yesterday — 00:00:00 to 23:59:59
  static DateRange yesterday({DateTime? now}) {
    final ref = (now ?? DateTime.now()).subtract(const Duration(days: 1));
    return DateRange(
      start: DateTime(ref.year, ref.month, ref.day),
      end: DateTime(ref.year, ref.month, ref.day, 23, 59, 59, 999),
    );
  }

  /// Tomorrow — 00:00:00 to 23:59:59
  static DateRange tomorrow({DateTime? now}) {
    final ref = (now ?? DateTime.now()).add(const Duration(days: 1));
    return DateRange(
      start: DateTime(ref.year, ref.month, ref.day),
      end: DateTime(ref.year, ref.month, ref.day, 23, 59, 59, 999),
    );
  }

  // ── Week ─────────────────────────────────────────────────────────

  /// This week — Monday 00:00 to Sunday 23:59
  static DateRange thisWeek({DateTime? now}) {
    final ref = now ?? DateTime.now();
    final monday = ref.subtract(Duration(days: ref.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999),
    );
  }

  /// Last week — Monday 00:00 to Sunday 23:59
  static DateRange lastWeek({DateTime? now}) {
    final ref = (now ?? DateTime.now()).subtract(const Duration(days: 7));
    final monday = ref.subtract(Duration(days: ref.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999),
    );
  }

  /// Next week — Monday 00:00 to Sunday 23:59
  static DateRange nextWeek({DateTime? now}) {
    final ref = (now ?? DateTime.now()).add(const Duration(days: 7));
    final monday = ref.subtract(Duration(days: ref.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999),
    );
  }

  // ── Month ────────────────────────────────────────────────────────

  /// This month — 1st 00:00 to last day 23:59
  static DateRange thisMonth({DateTime? now}) {
    final ref = now ?? DateTime.now();
    final lastDay = DateTime(ref.year, ref.month + 1, 0);
    return DateRange(
      start: DateTime(ref.year, ref.month, 1),
      end: DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59, 999),
    );
  }

  /// Last month — 1st 00:00 to last day 23:59
  static DateRange lastMonth({DateTime? now}) {
    final ref = now ?? DateTime.now();
    final firstDay = DateTime(ref.year, ref.month - 1, 1);
    final lastDay = DateTime(ref.year, ref.month, 0);
    return DateRange(
      start: firstDay,
      end: DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59, 999),
    );
  }

  /// Next month — 1st 00:00 to last day 23:59
  static DateRange nextMonth({DateTime? now}) {
    final ref = now ?? DateTime.now();
    final firstDay = DateTime(ref.year, ref.month + 1, 1);
    final lastDay = DateTime(ref.year, ref.month + 2, 0);
    return DateRange(
      start: firstDay,
      end: DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59, 999),
    );
  }

  // ── Year ─────────────────────────────────────────────────────────

  /// This year — Jan 1 00:00 to Dec 31 23:59
  static DateRange thisYear({DateTime? now}) {
    final ref = now ?? DateTime.now();
    return DateRange(
      start: DateTime(ref.year, 1, 1),
      end: DateTime(ref.year, 12, 31, 23, 59, 59, 999),
    );
  }

  /// Last year — Jan 1 00:00 to Dec 31 23:59
  static DateRange lastYear({DateTime? now}) {
    final ref = now ?? DateTime.now();
    return DateRange(
      start: DateTime(ref.year - 1, 1, 1),
      end: DateTime(ref.year - 1, 12, 31, 23, 59, 59, 999),
    );
  }

  // ── Custom ───────────────────────────────────────────────────────

  /// Last N days — N days ago 00:00 to today 23:59
  /// ```dart
  /// DateRangeHelper.lastNDays(30) // last 30 days
  /// DateRangeHelper.lastNDays(7)  // last 7 days
  /// ```
  static DateRange lastNDays(int n, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final start = ref.subtract(Duration(days: n - 1));
    return DateRange(
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(ref.year, ref.month, ref.day, 23, 59, 59, 999),
    );
  }

  /// Next N days — today 00:00 to N days later 23:59
  static DateRange nextNDays(int n, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final end = ref.add(Duration(days: n - 1));
    return DateRange(
      start: DateTime(ref.year, ref.month, ref.day),
      end: DateTime(end.year, end.month, end.day, 23, 59, 59, 999),
    );
  }

  /// Custom range — [start] 00:00 to [end] 23:59
  static DateRange custom(DateTime start, DateTime end) => DateRange(
        start: DateTime(start.year, start.month, start.day),
        end: DateTime(end.year, end.month, end.day, 23, 59, 59, 999),
      );

  /// Quarter ranges — Q1, Q2, Q3, Q4
  static DateRange quarter(int q, {DateTime? now}) {
    final year = (now ?? DateTime.now()).year;
    assert(q >= 1 && q <= 4, 'Quarter must be 1–4');
    final startMonth = (q - 1) * 3 + 1;
    final endMonth = startMonth + 2;
    final lastDay = DateTime(year, endMonth + 1, 0);
    return DateRange(
      start: DateTime(year, startMonth, 1),
      end: DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59, 999),
    );
  }

  /// Current quarter
  static DateRange currentQuarter({DateTime? now}) {
    final ref = now ?? DateTime.now();
    final q = ((ref.month - 1) ~/ 3) + 1;
    return quarter(q, now: ref);
  }
}
