import 'package:smart_date_formatter/smart_date_formatter.dart';

/// Parses natural language date strings into [DateTime] objects.
///
/// Supports English and Indian language expressions.
///
/// ```dart
/// SmartParser.parse("tomorrow")           // DateTime
/// SmartParser.parse("next monday")        // DateTime
/// SmartParser.parse("in 3 days")          // DateTime
/// SmartParser.parse("कल")                 // DateTime (Hindi)
/// SmartParser.parse("उद्या")              // DateTime (Marathi)
/// SmartParser.parseLocale("अगले सोमवार", locale: SdfLocale.hi)
/// ```
class SmartParser {
  /// Parses a natural language [input] string into a [DateTime].
  ///
  /// Returns `null` if the input cannot be parsed.
  ///
  /// ```dart
  /// SmartParser.parse("tomorrow")      // DateTime
  /// SmartParser.parse("in 3 days")     // DateTime
  /// SmartParser.parse("last monday")   // DateTime
  /// SmartParser.parse("2 weeks ago")   // DateTime
  /// SmartParser.parse("कल")            // DateTime
  /// ```
  static DateTime? parse(String input, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final normalized = input.trim().toLowerCase();

    // Try English first
    final english = _parseEnglish(normalized, reference);
    if (english != null) return english;

    // Try Hindi
    final hindi = _parseHindi(normalized, reference);
    if (hindi != null) return hindi;

    // Try Marathi
    final marathi = _parseMarathi(normalized, reference);
    if (marathi != null) return marathi;

    // Try standard date string
    try {
      return DateTime.parse(input.trim());
    } catch (_) {}

    return null;
  }

  /// Parses with explicit [locale] support.
  ///
  /// ```dart
  /// SmartParser.parseLocale("अगले सोमवार", locale: SdfLocale.hi)
  /// SmartParser.parseLocale("उद्या", locale: SdfLocale.mr)
  /// ```
  static DateTime? parseLocale(
    String input, {
    required SdfLocale locale,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final normalized = input.trim();

    switch (locale.code) {
      case 'hi':
        return _parseHindi(normalized, reference) ??
            _parseEnglish(normalized.toLowerCase(), reference);
      case 'mr':
        return _parseMarathi(normalized, reference) ??
            _parseEnglish(normalized.toLowerCase(), reference);
      default:
        return _parseEnglish(normalized.toLowerCase(), reference);
    }
  }

  /// Parses input and throws [FormatException] if it cannot be parsed.
  ///
  /// ```dart
  /// SmartParser.parseOrThrow("tomorrow")  // DateTime
  /// SmartParser.parseOrThrow("invalid")   // throws FormatException
  /// ```
  static DateTime parseOrThrow(String input, {DateTime? now}) {
    final result = parse(input, now: now);
    if (result == null) {
      throw FormatException('SmartParser: Cannot parse "$input"');
    }
    return result;
  }

  /// Returns true if [input] can be parsed.
  ///
  /// ```dart
  /// SmartParser.canParse("tomorrow")   // true
  /// SmartParser.canParse("random")     // false
  /// SmartParser.canParse("कल")         // true
  /// ```
  static bool canParse(String input, {DateTime? now}) =>
      parse(input, now: now) != null;

  /// Returns true if [input] can be parsed in given [locale].
  ///
  /// ```dart
  /// SmartParser.canParseLocale("अगले सोमवार", locale: SdfLocale.hi) // true
  /// ```
  static bool canParseLocale(
    String input, {
    required SdfLocale locale,
    DateTime? now,
  }) =>
      parseLocale(input, locale: locale, now: now) != null;

  /// All supported locales for parsing.
  static const List<String> supportedParseLocales = ['en', 'hi', 'mr'];

  // ── English Parser ────────────────────────────────────────────

  static DateTime? _parseEnglish(String input, DateTime reference) {
    // Simple keywords
    switch (input) {
      case 'today':
        return _startOf(reference);
      case 'tomorrow':
        return _startOf(reference.add(const Duration(days: 1)));
      case 'yesterday':
        return _startOf(reference.subtract(const Duration(days: 1)));
      case 'next week':
        return _startOf(reference.add(const Duration(days: 7)));
      case 'last week':
        return _startOf(reference.subtract(const Duration(days: 7)));
      case 'next month':
        return DateTime(reference.year, reference.month + 1, reference.day);
      case 'last month':
        return DateTime(reference.year, reference.month - 1, reference.day);
      case 'next year':
        return DateTime(reference.year + 1, reference.month, reference.day);
      case 'last year':
        return DateTime(reference.year - 1, reference.month, reference.day);
      case 'midnight':
        return DateTime(
            reference.year, reference.month, reference.day, 0, 0, 0);
      case 'noon':
        return DateTime(
            reference.year, reference.month, reference.day, 12, 0, 0);
      case 'end of day':
        return DateTime(
            reference.year, reference.month, reference.day, 23, 59, 59);
      case 'start of week':
      case 'beginning of week':
        return _startOf(
            reference.subtract(Duration(days: reference.weekday - 1)));
      case 'end of week':
        final daysToSunday = DateTime.sunday - reference.weekday;
        return _startOf(reference.add(Duration(days: daysToSunday)));
      case 'start of month':
      case 'beginning of month':
        return DateTime(reference.year, reference.month, 1);
      case 'end of month':
        return DateTime(reference.year, reference.month + 1, 0);
      case 'start of year':
      case 'beginning of year':
        return DateTime(reference.year, 1, 1);
      case 'end of year':
        return DateTime(reference.year, 12, 31);
      case 'this weekend':
        final daysToSat = DateTime.saturday - reference.weekday;
        return _startOf(reference
            .add(Duration(days: daysToSat <= 0 ? daysToSat + 7 : daysToSat)));
      case 'next weekend':
        final daysToNextSat = DateTime.saturday - reference.weekday + 7;
        return _startOf(reference.add(Duration(days: daysToNextSat)));
      case 'last weekend':
        final daysSinceSat = reference.weekday - DateTime.saturday;
        return _startOf(reference.subtract(Duration(
            days: daysSinceSat <= 0 ? daysSinceSat + 7 : daysSinceSat)));
      case 'day after tomorrow':
        return _startOf(reference.add(const Duration(days: 2)));
      case 'day before yesterday':
        return _startOf(reference.subtract(const Duration(days: 2)));
    }

    // "in N days/weeks/months/years"
    final inPattern =
        RegExp(r'^in (\d+) (second|minute|hour|day|week|month|year)s?$');
    final inMatch = inPattern.firstMatch(input);
    if (inMatch != null) {
      final n = int.parse(inMatch.group(1)!);
      final unit = inMatch.group(2)!;
      return _addUnit(reference, n, unit);
    }

    // "N days/weeks/months/years ago"
    final agoPattern =
        RegExp(r'^(\d+) (second|minute|hour|day|week|month|year)s? ago$');
    final agoMatch = agoPattern.firstMatch(input);
    if (agoMatch != null) {
      final n = int.parse(agoMatch.group(1)!);
      final unit = agoMatch.group(2)!;
      return _addUnit(reference, -n, unit);
    }

    // "next/last monday/tuesday/..."
    final weekdayPattern = RegExp(
        r'^(next|last) (monday|tuesday|wednesday|thursday|friday|saturday|sunday)$');
    final weekdayMatch = weekdayPattern.firstMatch(input);
    if (weekdayMatch != null) {
      final direction = weekdayMatch.group(1)!;
      final weekdayStr = weekdayMatch.group(2)!;
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findWeekday(reference, targetWeekday, direction == 'next');
    }

    // "on monday/tuesday/..." (this week)
    final onPattern = RegExp(
        r'^(on )?(monday|tuesday|wednesday|thursday|friday|saturday|sunday)$');
    final onMatch = onPattern.firstMatch(input);
    if (onMatch != null) {
      final weekdayStr = onMatch.group(2)!;
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findWeekday(reference, targetWeekday, true);
    }

    // "N weeks from now", "N days from now"
    final fromNowPattern = RegExp(r'^(\d+) (day|week|month|year)s? from now$');
    final fromNowMatch = fromNowPattern.firstMatch(input);
    if (fromNowMatch != null) {
      final n = int.parse(fromNowMatch.group(1)!);
      final unit = fromNowMatch.group(2)!;
      return _addUnit(reference, n, unit);
    }

    // "a day ago", "a week ago"
    final aWordPattern = RegExp(r'^a (day|week|month|year) ago$');
    final aWordMatch = aWordPattern.firstMatch(input);
    if (aWordMatch != null) {
      return _addUnit(reference, -1, aWordMatch.group(1)!);
    }

    // "in a day", "in a week"
    final inAPattern = RegExp(r'^in a (day|week|month|year)$');
    final inAMatch = inAPattern.firstMatch(input);
    if (inAMatch != null) {
      return _addUnit(reference, 1, inAMatch.group(1)!);
    }

    return null;
  }

  // ── Hindi Parser ──────────────────────────────────────────────

  static DateTime? _parseHindi(String input, DateTime reference) {
    switch (input) {
      // Basic
      case 'आज':
        return _startOf(reference);
      case 'कल':
        // कल means both yesterday and tomorrow in Hindi
        // Default to tomorrow (future)
        return _startOf(reference.add(const Duration(days: 1)));
      case 'बीता हुआ कल':
      case 'गुज़रा हुआ कल':
        return _startOf(reference.subtract(const Duration(days: 1)));
      case 'परसों':
        return _startOf(reference.add(const Duration(days: 2)));
      case 'बीता परसों':
        return _startOf(reference.subtract(const Duration(days: 2)));
      case 'अभी':
        return reference;

      // Week
      case 'इस हफ्ते':
      case 'इस सप्ताह':
        return _startOf(
            reference.subtract(Duration(days: reference.weekday - 1)));
      case 'पिछले हफ्ते':
      case 'पिछले सप्ताह':
        return _startOf(reference.subtract(const Duration(days: 7)));
      case 'अगले हफ्ते':
      case 'अगले सप्ताह':
        return _startOf(reference.add(const Duration(days: 7)));

      // Month
      case 'इस महीने':
        return DateTime(reference.year, reference.month, 1);
      case 'पिछले महीने':
        return DateTime(reference.year, reference.month - 1, 1);
      case 'अगले महीने':
        return DateTime(reference.year, reference.month + 1, 1);

      // Year
      case 'इस साल':
      case 'इस वर्ष':
        return DateTime(reference.year, 1, 1);
      case 'पिछले साल':
      case 'पिछले वर्ष':
        return DateTime(reference.year - 1, 1, 1);
      case 'अगले साल':
      case 'अगले वर्ष':
        return DateTime(reference.year + 1, 1, 1);
    }

    // "अगले सोमवार" (next monday)
    final nextWeekdayHi = RegExp(
        r'^अगले (सोमवार|मंगलवार|बुधवार|गुरुवार|शुक्रवार|शनिवार|रविवार)$');
    final nextHiMatch = nextWeekdayHi.firstMatch(input);
    if (nextHiMatch != null) {
      final weekday = _hindiWeekday(nextHiMatch.group(1)!);
      return _findWeekday(reference, weekday, true);
    }

    // "पिछले सोमवार" (last monday)
    final lastWeekdayHi = RegExp(
        r'^पिछले (सोमवार|मंगलवार|बुधवार|गुरुवार|शुक्रवार|शनिवार|रविवार)$');
    final lastHiMatch = lastWeekdayHi.firstMatch(input);
    if (lastHiMatch != null) {
      final weekday = _hindiWeekday(lastHiMatch.group(1)!);
      return _findWeekday(reference, weekday, false);
    }

    // "{n} दिन बाद" (in N days)
    final inDaysHi = RegExp(r'^(\d+) दिन बाद$');
    final inDaysHiMatch = inDaysHi.firstMatch(input);
    if (inDaysHiMatch != null) {
      final n = int.parse(inDaysHiMatch.group(1)!);
      return _startOf(reference.add(Duration(days: n)));
    }

    // "{n} दिन पहले" (N days ago)
    final agoDaysHi = RegExp(r'^(\d+) दिन पहले$');
    final agoDaysHiMatch = agoDaysHi.firstMatch(input);
    if (agoDaysHiMatch != null) {
      final n = int.parse(agoDaysHiMatch.group(1)!);
      return _startOf(reference.subtract(Duration(days: n)));
    }

    // "{n} हफ्ते बाद" (in N weeks)
    final inWeeksHi = RegExp(r'^(\d+) हफ्ते बाद$');
    final inWeeksHiMatch = inWeeksHi.firstMatch(input);
    if (inWeeksHiMatch != null) {
      final n = int.parse(inWeeksHiMatch.group(1)!);
      return _startOf(reference.add(Duration(days: n * 7)));
    }

    // "{n} महीने बाद" (in N months)
    final inMonthsHi = RegExp(r'^(\d+) महीने बाद$');
    final inMonthsHiMatch = inMonthsHi.firstMatch(input);
    if (inMonthsHiMatch != null) {
      final n = int.parse(inMonthsHiMatch.group(1)!);
      return DateTime(reference.year, reference.month + n, reference.day);
    }

    return null;
  }

  // ── Marathi Parser ────────────────────────────────────────────

  static DateTime? _parseMarathi(String input, DateTime reference) {
    switch (input) {
      case 'आज':
        return _startOf(reference);
      case 'उद्या':
        return _startOf(reference.add(const Duration(days: 1)));
      case 'काल':
        return _startOf(reference.subtract(const Duration(days: 1)));
      case 'परवा':
        return _startOf(reference.add(const Duration(days: 2)));
      case 'आधीचा परवा':
        return _startOf(reference.subtract(const Duration(days: 2)));

      // Week
      case 'या आठवड्यात':
        return _startOf(
            reference.subtract(Duration(days: reference.weekday - 1)));
      case 'पुढील आठवडा':
        return _startOf(reference.add(const Duration(days: 7)));
      case 'मागील आठवडा':
        return _startOf(reference.subtract(const Duration(days: 7)));

      // Month
      case 'या महिन्यात':
        return DateTime(reference.year, reference.month, 1);
      case 'पुढील महिना':
        return DateTime(reference.year, reference.month + 1, 1);
      case 'मागील महिना':
        return DateTime(reference.year, reference.month - 1, 1);

      // Year
      case 'या वर्षी':
        return DateTime(reference.year, 1, 1);
      case 'पुढील वर्ष':
        return DateTime(reference.year + 1, 1, 1);
      case 'मागील वर्ष':
        return DateTime(reference.year - 1, 1, 1);
    }

    // "पुढील सोमवार" (next monday)
    final nextWeekdayMr = RegExp(
        r'^पुढील (सोमवार|मंगळवार|बुधवार|गुरुवार|शुक्रवार|शनिवार|रविवार)$');
    final nextMrMatch = nextWeekdayMr.firstMatch(input);
    if (nextMrMatch != null) {
      final weekday = _marathiWeekday(nextMrMatch.group(1)!);
      return _findWeekday(reference, weekday, true);
    }

    // "मागील सोमवार" (last monday)
    final lastWeekdayMr = RegExp(
        r'^मागील (सोमवार|मंगळवार|बुधवार|गुरुवार|शुक्रवार|शनिवार|रविवार)$');
    final lastMrMatch = lastWeekdayMr.firstMatch(input);
    if (lastMrMatch != null) {
      final weekday = _marathiWeekday(lastMrMatch.group(1)!);
      return _findWeekday(reference, weekday, false);
    }

    // "{n} दिवसांनी" (in N days)
    final inDaysMr = RegExp(r'^(\d+) दिवसांनी$');
    final inDaysMrMatch = inDaysMr.firstMatch(input);
    if (inDaysMrMatch != null) {
      final n = int.parse(inDaysMrMatch.group(1)!);
      return _startOf(reference.add(Duration(days: n)));
    }

    // "{n} दिवसांपूर्वी" (N days ago)
    final agoDaysMr = RegExp(r'^(\d+) दिवसांपूर्वी$');
    final agoDaysMrMatch = agoDaysMr.firstMatch(input);
    if (agoDaysMrMatch != null) {
      final n = int.parse(agoDaysMrMatch.group(1)!);
      return _startOf(reference.subtract(Duration(days: n)));
    }

    return null;
  }

  // ── Private helpers ───────────────────────────────────────────

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
        return _startOf(base.add(Duration(days: n)));
      case 'week':
        return _startOf(base.add(Duration(days: n * 7)));
      case 'month':
        return _startOf(DateTime(base.year, base.month + n, base.day));
      case 'year':
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

  static int _hindiWeekday(String weekday) {
    const map = {
      'सोमवार': 1,
      'मंगलवार': 2,
      'बुधवार': 3,
      'गुरुवार': 4,
      'शुक्रवार': 5,
      'शनिवार': 6,
      'रविवार': 7,
    };
    return map[weekday] ?? 1;
  }

  static int _marathiWeekday(String weekday) {
    const map = {
      'सोमवार': 1,
      'मंगळवार': 2,
      'बुधवार': 3,
      'गुरुवार': 4,
      'शुक्रवार': 5,
      'शनिवार': 6,
      'रविवार': 7,
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
