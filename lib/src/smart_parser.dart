/// Parses natural language date strings into DateTime objects.
///
/// Supported expressions:
/// - "today", "tomorrow", "yesterday"
/// - "in 3 days", "in 2 weeks", "in 1 month"
/// - "3 days ago", "2 weeks ago", "1 month ago"
/// - "next monday", "last friday"
/// - "next week", "last week"
/// - "next month", "last month"
/// - "next year", "last year"
class SmartParser {
  /// Parses a natural language [input] string into a [DateTime].
  ///
  /// Returns `null` if the input cannot be parsed.
  ///
  /// ```dart
  /// SmartParser.parse("tomorrow")      // DateTime — tomorrow
  /// SmartParser.parse("in 3 days")     // DateTime — 3 days from now
  /// SmartParser.parse("last monday")   // DateTime — last Monday
  /// SmartParser.parse("2 weeks ago")   // DateTime — 2 weeks back
  /// ```
  static DateTime? parse(String input, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final normalized = input.trim().toLowerCase();

    // ── Simple keywords ──────────────────────────────────────────
    if (normalized == 'today') return _startOf(reference);
    if (normalized == 'tomorrow') {
      return _startOf(reference.add(const Duration(days: 1)));
    }
    if (normalized == 'yesterday') {
      return _startOf(reference.subtract(const Duration(days: 1)));
    }
    if (normalized == 'next week') {
      return _startOf(reference.add(const Duration(days: 7)));
    }
    if (normalized == 'last week') {
      return _startOf(reference.subtract(const Duration(days: 7)));
    }
    if (normalized == 'next month') {
      return DateTime(reference.year, reference.month + 1, reference.day);
    }
    if (normalized == 'last month') {
      return DateTime(reference.year, reference.month - 1, reference.day);
    }
    if (normalized == 'next year') {
      return DateTime(reference.year + 1, reference.month, reference.day);
    }
    if (normalized == 'last year') {
      return DateTime(reference.year - 1, reference.month, reference.day);
    }

    // ── "in N days/weeks/months/years" ───────────────────────────
    final inPattern =
        RegExp(r'^in (\d+) (second|minute|hour|day|week|month|year)s?$');
    final inMatch = inPattern.firstMatch(normalized);
    if (inMatch != null) {
      final n = int.parse(inMatch.group(1)!);
      final unit = inMatch.group(2)!;
      return _addUnit(reference, n, unit);
    }

    // ── "N days/weeks/months/years ago" ──────────────────────────
    final agoPattern =
        RegExp(r'^(\d+) (second|minute|hour|day|week|month|year)s? ago$');
    final agoMatch = agoPattern.firstMatch(normalized);
    if (agoMatch != null) {
      final n = int.parse(agoMatch.group(1)!);
      final unit = agoMatch.group(2)!;
      return _addUnit(reference, -n, unit);
    }

    // ── "next/last monday/tuesday/..." ───────────────────────────
    final weekdayPattern = RegExp(
        r'^(next|last) (monday|tuesday|wednesday|thursday|friday|saturday|sunday)$');
    final weekdayMatch = weekdayPattern.firstMatch(normalized);
    if (weekdayMatch != null) {
      final direction = weekdayMatch.group(1)!;
      final weekdayStr = weekdayMatch.group(2)!;
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findWeekday(reference, targetWeekday, direction == 'next');
    }

    // ── "on monday/tuesday/..." (this week) ──────────────────────
    final onPattern = RegExp(
        r'^(on )?(monday|tuesday|wednesday|thursday|friday|saturday|sunday)$');
    final onMatch = onPattern.firstMatch(normalized);
    if (onMatch != null) {
      final weekdayStr = onMatch.group(2)!;
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findWeekday(reference, targetWeekday, true);
    }

    // ── Try parsing as standard date string ──────────────────────
    try {
      return DateTime.parse(input.trim());
    } catch (_) {}

    return null;
  }

  /// Parses input and throws [FormatException] if it cannot be parsed.
  static DateTime parseOrThrow(String input, {DateTime? now}) {
    final result = parse(input, now: now);
    if (result == null) {
      throw FormatException('SmartParser: Cannot parse "$input"');
    }
    return result;
  }

  /// Returns true if [input] can be parsed.
  static bool canParse(String input, {DateTime? now}) =>
      parse(input, now: now) != null;

  // ── Private helpers ────────────────────────────────────────────

  static DateTime _startOf(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _addUnit(DateTime base, int n, String unit) {
    switch (unit) {
      case 'second':
        return base.add(Duration(seconds: n));
      case 'minute':
        return base.add(Duration(minutes: n));
      case 'hour':
        return base.add(Duration(hours: n));
      case 'day':
        // ✅ _startOf — time strip karo
        return _startOf(base.add(Duration(days: n)));
      case 'week':
        // ✅ _startOf — time strip karo
        return _startOf(base.add(Duration(days: n * 7)));
      case 'month':
        // ✅ _startOf — time strip karo
        return _startOf(DateTime(base.year, base.month + n, base.day));
      case 'year':
        // ✅ _startOf — time strip karo
        return _startOf(DateTime(base.year + n, base.month, base.day));
      default:
        return base;
    }
  }

  static int _weekdayNumber(String weekday) {
    const map = {
      'monday': 1,
      'tuesday': 2,
      'wednesday': 3,
      'thursday': 4,
      'friday': 5,
      'saturday': 6,
      'sunday': 7,
    };
    return map[weekday] ?? 1;
  }

  static DateTime _findWeekday(DateTime from, int targetWeekday, bool next) {
    int diff = targetWeekday - from.weekday;
    if (next) {
      if (diff <= 0) diff += 7;
    } else {
      if (diff >= 0) diff -= 7;
    }
    final result = from.add(Duration(days: diff));
    return _startOf(result);
  }
}
