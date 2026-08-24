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

    final english = _parseEnglish(normalized, reference);
    if (english != null) return english;

    final hindi = _parseHindi(normalized, reference);
    if (hindi != null) return hindi;

    final marathi = _parseMarathi(normalized, reference);
    if (marathi != null) return marathi;

    final gujarati = _parseGujarati(normalized, reference);
    if (gujarati != null) return gujarati;

    final bengali = _parseBengali(normalized, reference);
    if (bengali != null) return bengali;

    final tamil = _parseTamil(normalized, reference);
    if (tamil != null) return tamil;

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
      case 'gu':
        return _parseGujarati(normalized, reference) ??
            _parseEnglish(normalized.toLowerCase(), reference);
      case 'bn':
        return _parseBengali(normalized, reference) ??
            _parseEnglish(normalized.toLowerCase(), reference);
      case 'ta':
        return _parseTamil(normalized, reference) ??
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
  static const List<String> supportedParseLocales = [
    'en',
    'hi',
    'mr',
    'gu',
    'bn',
    'ta'
  ];

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

    // "first/last monday of month"
    final firstLastPattern = RegExp(
        r'^(first|last) (monday|tuesday|wednesday|thursday|friday|saturday|sunday) of (this|next|last)? ?month$');
    final firstLastMatch = firstLastPattern.firstMatch(input);
    if (firstLastMatch != null) {
      final position = firstLastMatch.group(1)!;
      final weekdayStr = firstLastMatch.group(2)!;
      final monthStr = firstLastMatch.group(3) ?? 'this';
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findWeekdayInMonth(
          reference, targetWeekday, position == 'first', monthStr);
    }

// "N mondays/tuesdays ago"
    final nWeekdaysAgoPattern = RegExp(
        r'^(\d+) (monday|tuesday|wednesday|thursday|friday|saturday|sunday)s? ago$');
    final nWeekdaysAgoMatch = nWeekdaysAgoPattern.firstMatch(input);
    if (nWeekdaysAgoMatch != null) {
      final n = int.parse(nWeekdaysAgoMatch.group(1)!);
      final weekdayStr = nWeekdaysAgoMatch.group(2)!;
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findNthWeekdayAgo(reference, targetWeekday, n);
    }

// "in N mondays/tuesdays"
    final inNWeekdaysPattern = RegExp(
        r'^in (\d+) (monday|tuesday|wednesday|thursday|friday|saturday|sunday)s?$');
    final inNWeekdaysMatch = inNWeekdaysPattern.firstMatch(input);
    if (inNWeekdaysMatch != null) {
      final n = int.parse(inNWeekdaysMatch.group(1)!);
      final weekdayStr = inNWeekdaysMatch.group(2)!;
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findNthWeekdayAhead(reference, targetWeekday, n);
    }

// "beginning of next/last month"
    final beginningPattern =
        RegExp(r'^beginning of (next|last|this) (month|year|week)$');
    final beginningMatch = beginningPattern.firstMatch(input);
    if (beginningMatch != null) {
      final when = beginningMatch.group(1)!;
      final period = beginningMatch.group(2)!;
      return _beginningOf(reference, when, period);
    }

// "end of next/last month"
    final endPattern = RegExp(r'^end of (next|last|this) (month|year|week)$');
    final endMatch = endPattern.firstMatch(input);
    if (endMatch != null) {
      final when = endMatch.group(1)!;
      final period = endMatch.group(2)!;
      return _endOf(reference, when, period);
    }

// "this coming monday/friday"
    final comingPattern = RegExp(
        r'^this coming (monday|tuesday|wednesday|thursday|friday|saturday|sunday)$');
    final comingMatch = comingPattern.firstMatch(input);
    if (comingMatch != null) {
      final weekdayStr = comingMatch.group(1)!;
      final targetWeekday = _weekdayNumber(weekdayStr);
      return _findWeekday(reference, targetWeekday, true);
    }

// "quarter N" or "Q1/Q2/Q3/Q4"
    final quarterPattern = RegExp(r'^(q|quarter )([1-4])$');
    final quarterMatch = quarterPattern.firstMatch(input);
    if (quarterMatch != null) {
      final q = int.parse(quarterMatch.group(2)!);
      final startMonth = (q - 1) * 3 + 1;
      return DateTime(reference.year, startMonth, 1);
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

  static DateTime? _parseGujarati(String input, DateTime reference) {
    switch (input) {
      case 'આજ':
        return _startOf(reference);
      case 'આવતી કાલ':
      case 'આવતીકાલ':
        return _startOf(reference.add(const Duration(days: 1)));
      case 'ગઈ કાલ':
      case 'ગઈકાલ':
        return _startOf(reference.subtract(const Duration(days: 1)));
      case 'પરમ દિવસ':
        return _startOf(reference.add(const Duration(days: 2)));
      case 'આ અઠવાડિયે':
        return _startOf(
            reference.subtract(Duration(days: reference.weekday - 1)));
      case 'આવતા અઠવાડિયે':
        return _startOf(reference.add(const Duration(days: 7)));
      case 'ગયા અઠવાડિયે':
        return _startOf(reference.subtract(const Duration(days: 7)));
      case 'આ મહિને':
        return DateTime(reference.year, reference.month, 1);
      case 'આવતા મહિને':
        return DateTime(reference.year, reference.month + 1, 1);
      case 'ગયા મહિને':
        return DateTime(reference.year, reference.month - 1, 1);
      case 'આ વર્ષે':
        return DateTime(reference.year, 1, 1);
      case 'આવતા વર્ષે':
        return DateTime(reference.year + 1, 1, 1);
      case 'ગયા વર્ષે':
        return DateTime(reference.year - 1, 1, 1);
    }

    // "{n} દિવસ પછી" (in N days)
    final inDaysGu = RegExp(r'^(\d+) દિવસ પછી$');
    final inDaysGuMatch = inDaysGu.firstMatch(input);
    if (inDaysGuMatch != null) {
      final n = int.parse(inDaysGuMatch.group(1)!);
      return _startOf(reference.add(Duration(days: n)));
    }

    // "{n} દિવસ પહેલાં" (N days ago)
    final agoDaysGu = RegExp(r'^(\d+) દિવસ પહેલાં$');
    final agoDaysGuMatch = agoDaysGu.firstMatch(input);
    if (agoDaysGuMatch != null) {
      final n = int.parse(agoDaysGuMatch.group(1)!);
      return _startOf(reference.subtract(Duration(days: n)));
    }

    return null;
  }

  static DateTime? _parseBengali(String input, DateTime reference) {
    switch (input) {
      case 'আজ':
        return _startOf(reference);
      case 'আগামীকাল':
        return _startOf(reference.add(const Duration(days: 1)));
      case 'গতকাল':
        return _startOf(reference.subtract(const Duration(days: 1)));
      case 'পরশু':
        return _startOf(reference.add(const Duration(days: 2)));
      case 'এই সপ্তাহ':
        return _startOf(
            reference.subtract(Duration(days: reference.weekday - 1)));
      case 'আগামী সপ্তাহ':
        return _startOf(reference.add(const Duration(days: 7)));
      case 'গত সপ্তাহ':
        return _startOf(reference.subtract(const Duration(days: 7)));
      case 'এই মাস':
        return DateTime(reference.year, reference.month, 1);
      case 'আগামী মাস':
        return DateTime(reference.year, reference.month + 1, 1);
      case 'গত মাস':
        return DateTime(reference.year, reference.month - 1, 1);
      case 'এই বছর':
        return DateTime(reference.year, 1, 1);
      case 'আগামী বছর':
        return DateTime(reference.year + 1, 1, 1);
      case 'গত বছর':
        return DateTime(reference.year - 1, 1, 1);
    }

    // "{n} দিন পরে" (in N days)
    final inDaysBn = RegExp(r'^(\d+) দিন পরে$');
    final inDaysBnMatch = inDaysBn.firstMatch(input);
    if (inDaysBnMatch != null) {
      final n = int.parse(inDaysBnMatch.group(1)!);
      return _startOf(reference.add(Duration(days: n)));
    }

    // "{n} দিন আগে" (N days ago)
    final agoDaysBn = RegExp(r'^(\d+) দিন আগে$');
    final agoDaysBnMatch = agoDaysBn.firstMatch(input);
    if (agoDaysBnMatch != null) {
      final n = int.parse(agoDaysBnMatch.group(1)!);
      return _startOf(reference.subtract(Duration(days: n)));
    }

    return null;
  }

  static DateTime? _parseTamil(String input, DateTime reference) {
    switch (input) {
      case 'இன்று':
        return _startOf(reference);
      case 'நாளை':
        return _startOf(reference.add(const Duration(days: 1)));
      case 'நேற்று':
        return _startOf(reference.subtract(const Duration(days: 1)));
      case 'நாளை மறுநாள்':
        return _startOf(reference.add(const Duration(days: 2)));
      case 'இந்த வாரம்':
        return _startOf(
            reference.subtract(Duration(days: reference.weekday - 1)));
      case 'அடுத்த வாரம்':
        return _startOf(reference.add(const Duration(days: 7)));
      case 'கடந்த வாரம்':
        return _startOf(reference.subtract(const Duration(days: 7)));
      case 'இந்த மாதம்':
        return DateTime(reference.year, reference.month, 1);
      case 'அடுத்த மாதம்':
        return DateTime(reference.year, reference.month + 1, 1);
      case 'கடந்த மாதம்':
        return DateTime(reference.year, reference.month - 1, 1);
      case 'இந்த ஆண்டு':
        return DateTime(reference.year, 1, 1);
      case 'அடுத்த ஆண்டு':
        return DateTime(reference.year + 1, 1, 1);
      case 'கடந்த ஆண்டு':
        return DateTime(reference.year - 1, 1, 1);
    }

    // "{n} நாட்களில்" (in N days)
    final inDaysTa = RegExp(r'^(\d+) நாட்களில்$');
    final inDaysTaMatch = inDaysTa.firstMatch(input);
    if (inDaysTaMatch != null) {
      final n = int.parse(inDaysTaMatch.group(1)!);
      return _startOf(reference.add(Duration(days: n)));
    }

    // "{n} நாட்களுக்கு முன்பு" (N days ago)
    final agoDaysTa = RegExp(r'^(\d+) நாட்களுக்கு முன்பு$');
    final agoDaysTaMatch = agoDaysTa.firstMatch(input);
    if (agoDaysTaMatch != null) {
      final n = int.parse(agoDaysTaMatch.group(1)!);
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

  static DateTime? _findWeekdayInMonth(
    DateTime reference,
    int targetWeekday,
    bool first,
    String monthStr,
  ) {
    late DateTime monthDate;
    switch (monthStr) {
      case 'next':
        monthDate = DateTime(reference.year, reference.month + 1, 1);
      case 'last':
        monthDate = DateTime(reference.year, reference.month - 1, 1);
      default:
        monthDate = DateTime(reference.year, reference.month, 1);
    }

    if (first) {
      // Find first occurrence
      DateTime current = monthDate;
      while (current.weekday != targetWeekday) {
        current = current.add(const Duration(days: 1));
      }
      return _startOf(current);
    } else {
      // Find last occurrence
      final lastDay = DateTime(monthDate.year, monthDate.month + 1, 0);
      DateTime current = lastDay;
      while (current.weekday != targetWeekday) {
        current = current.subtract(const Duration(days: 1));
      }
      return _startOf(current);
    }
  }

  static DateTime _findNthWeekdayAgo(
    DateTime reference,
    int targetWeekday,
    int n,
  ) {
    DateTime current = reference.subtract(const Duration(days: 1));
    int count = 0;
    while (count < n) {
      if (current.weekday == targetWeekday) count++;
      if (count < n) {
        current = current.subtract(const Duration(days: 1));
      }
    }
    return _startOf(current);
  }

  static DateTime _findNthWeekdayAhead(
    DateTime reference,
    int targetWeekday,
    int n,
  ) {
    DateTime current = reference.add(const Duration(days: 1));
    int count = 0;
    while (count < n) {
      if (current.weekday == targetWeekday) count++;
      if (count < n) {
        current = current.add(const Duration(days: 1));
      }
    }
    return _startOf(current);
  }

  static DateTime? _beginningOf(
    DateTime reference,
    String when,
    String period,
  ) {
    switch ('$when $period') {
      case 'this month':
        return DateTime(reference.year, reference.month, 1);
      case 'next month':
        return DateTime(reference.year, reference.month + 1, 1);
      case 'last month':
        return DateTime(reference.year, reference.month - 1, 1);
      case 'this year':
        return DateTime(reference.year, 1, 1);
      case 'next year':
        return DateTime(reference.year + 1, 1, 1);
      case 'last year':
        return DateTime(reference.year - 1, 1, 1);
      case 'this week':
        return _startOf(
            reference.subtract(Duration(days: reference.weekday - 1)));
      case 'next week':
        final nextMon = reference.add(Duration(days: 8 - reference.weekday));
        return _startOf(nextMon);
      case 'last week':
        final lastMon =
            reference.subtract(Duration(days: reference.weekday + 6));
        return _startOf(lastMon);
      default:
        return null;
    }
  }

  static DateTime? _endOf(
    DateTime reference,
    String when,
    String period,
  ) {
    switch ('$when $period') {
      case 'this month':
        return _startOf(DateTime(reference.year, reference.month + 1, 0));
      case 'next month':
        return _startOf(DateTime(reference.year, reference.month + 2, 0));
      case 'last month':
        return _startOf(DateTime(reference.year, reference.month, 0));
      case 'this year':
        return DateTime(reference.year, 12, 31);
      case 'next year':
        return DateTime(reference.year + 1, 12, 31);
      case 'last year':
        return DateTime(reference.year - 1, 12, 31);
      case 'this week':
        final daysToSunday = DateTime.sunday - reference.weekday;
        return _startOf(reference.add(Duration(days: daysToSunday)));
      case 'next week':
        final nextSun = reference
            .add(Duration(days: DateTime.sunday - reference.weekday + 7));
        return _startOf(nextSun);
      case 'last week':
        final lastSun = reference.subtract(Duration(days: reference.weekday));
        return _startOf(lastSun);
      default:
        return null;
    }
  }
}
