import 'localization.dart';

/// Core formatting logic for SmartDateFormatter
class SmartDateFormatter {
  /// Locale for formatting — use [SdfLocale] constants
  /// ```dart
  /// SmartDateFormatter(locale: SdfLocale.hi) // Hindi
  /// SmartDateFormatter(locale: SdfLocale.es) // Spanish
  /// ```
  final SdfLocale locale;

  /// Creates a [SmartDateFormatter] with optional [locale].
  ///
  /// ```dart
  /// SmartDateFormatter()                        // English (default)
  /// SmartDateFormatter(locale: SdfLocale.hi)   // Hindi
  /// SmartDateFormatter(locale: SdfLocale.es)   // Spanish
  /// ```
  const SmartDateFormatter({
    this.locale = SdfLocale.en,
    @Deprecated('Use locale instead. Will be removed in 1.0.0')
    Map<String, String>? labels,
  });

  Map<String, String> get _labels => locale.labels;

  /// Formats [date] relative to [now] (defaults to DateTime.now()).
  String format(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(date);
    final absDiff = diff.abs();

    if (absDiff.inSeconds < 10) return _labels['justNow']!;

    if (absDiff.inSeconds < 60) {
      return diff.isNegative
          ? 'in ${absDiff.inSeconds} ${_labels['secondsAgo']}'
          : '${absDiff.inSeconds} ${_labels['secondsAgo']}';
    }

    if (absDiff.inMinutes < 2) {
      return diff.isNegative ? 'in 1 minute' : _labels['minuteAgo']!;
    }

    if (absDiff.inMinutes < 60) {
      return diff.isNegative
          ? 'in ${absDiff.inMinutes} ${_labels['minutesAgo']}'
          : '${absDiff.inMinutes} ${_labels['minutesAgo']}';
    }

    if (absDiff.inHours < 2) {
      return diff.isNegative ? 'in 1 hour' : _labels['hourAgo']!;
    }

    if (absDiff.inHours < 24) {
      return diff.isNegative
          ? 'in ${absDiff.inHours} ${_labels['hoursAgo']}'
          : '${absDiff.inHours} ${_labels['hoursAgo']}';
    }

    if (absDiff.inDays == 1) {
      return diff.isNegative ? _labels['tomorrow']! : _labels['yesterday']!;
    }

    if (absDiff.inDays < 7) {
      return diff.isNegative
          ? _replace(_labels['inDays']!, absDiff.inDays)
          : '${absDiff.inDays} ${_labels['daysAgo']}';
    }

    if (absDiff.inDays < 14) {
      return diff.isNegative ? _labels['nextWeek']! : _labels['lastWeek']!;
    }

    if (absDiff.inDays < 30) {
      final weeks = (absDiff.inDays / 7).floor();
      return diff.isNegative
          ? _replace(_labels['inWeeks']!, weeks)
          : '$weeks ${_labels['weeksAgo']}';
    }

    if (absDiff.inDays < 60) {
      return diff.isNegative ? _labels['nextMonth']! : _labels['lastMonth']!;
    }

    if (absDiff.inDays < 365) {
      final months = (absDiff.inDays / 30).floor();
      return diff.isNegative
          ? _replace(_labels['inMonths']!, months)
          : '$months ${_labels['monthsAgo']}';
    }

    if (absDiff.inDays < 730) {
      return diff.isNegative ? _labels['nextYear']! : _labels['lastYear']!;
    }

    final years = (absDiff.inDays / 365).floor();
    return diff.isNegative
        ? _replace(_labels['inYears']!, years)
        : '$years ${_labels['yearsAgo']}';
  }

  /// Formats [date] as a calendar string
  String calendar(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) {
      return _labels['justNow'] == 'Just now'
          ? 'Today'
          : _labels['yesterday']!.replaceAll(_labels['yesterday']!, 'Today');
    }
    if (diff == -1) return _labels['yesterday']!;
    if (diff == 1) return _labels['tomorrow']!;
    if (diff > 1 && diff < 7) return _weekdayName(date.weekday);
    if (diff < 0 && diff > -7) return 'Last ${_weekdayName(date.weekday)}';

    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  /// Returns a short timestamp
  String shortTimestamp(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final time = '$hour:$minute $period';

    if (diff == 0) return time;
    if (diff.abs() < 7) {
      return '${_weekdayName(date.weekday).substring(0, 3)} $time';
    }
    return '${date.day} ${_monthName(date.month).substring(0, 3)}';
  }

  String _replace(String template, int n) => template.replaceAll('{n}', '$n');

  String _weekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
