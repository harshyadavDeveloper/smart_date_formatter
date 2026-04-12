/// Core formatting logic for SmartDateFormatter
class SmartDateFormatter {
  /// Locale-aware labels. Override for custom language support.
  final Map<String, String> labels;

  const SmartDateFormatter({
    this.labels = const {
      'justNow': 'Just now',
      'secondsAgo': 'seconds ago',
      'minuteAgo': '1 minute ago',
      'minutesAgo': 'minutes ago',
      'hourAgo': '1 hour ago',
      'hoursAgo': 'hours ago',
      'yesterday': 'Yesterday',
      'tomorrow': 'Tomorrow',
      'daysAgo': 'days ago',
      'inDays': 'in {n} days',
      'lastWeek': 'Last week',
      'nextWeek': 'Next week',
      'weeksAgo': 'weeks ago',
      'inWeeks': 'in {n} weeks',
      'lastMonth': 'Last month',
      'nextMonth': 'Next month',
      'monthsAgo': 'months ago',
      'inMonths': 'in {n} months',
      'lastYear': 'Last year',
      'nextYear': 'Next year',
      'yearsAgo': 'years ago',
      'inYears': 'in {n} years',
    },
  });

  /// Formats [date] relative to [now] (defaults to DateTime.now()).
  String format(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(date);
    final absDiff = diff.abs();

    if (absDiff.inSeconds < 10) return labels['justNow']!;

    if (absDiff.inSeconds < 60) {
      return diff.isNegative
          ? 'in ${absDiff.inSeconds} ${labels['secondsAgo']}'
          : '${absDiff.inSeconds} ${labels['secondsAgo']}';
    }

    if (absDiff.inMinutes < 2) {
      return diff.isNegative ? 'in 1 minute' : labels['minuteAgo']!;
    }

    if (absDiff.inMinutes < 60) {
      return diff.isNegative
          ? 'in ${absDiff.inMinutes} ${labels['minutesAgo']}'
          : '${absDiff.inMinutes} ${labels['minutesAgo']}';
    }

    if (absDiff.inHours < 2) {
      return diff.isNegative ? 'in 1 hour' : labels['hourAgo']!;
    }

    if (absDiff.inHours < 24) {
      return diff.isNegative
          ? 'in ${absDiff.inHours} ${labels['hoursAgo']}'
          : '${absDiff.inHours} ${labels['hoursAgo']}';
    }

    if (absDiff.inDays == 1) {
      return diff.isNegative ? labels['tomorrow']! : labels['yesterday']!;
    }

    if (absDiff.inDays < 7) {
      return diff.isNegative
          ? _replace(labels['inDays']!, absDiff.inDays)
          : '${absDiff.inDays} ${labels['daysAgo']}';
    }

    if (absDiff.inDays < 14) {
      return diff.isNegative ? labels['nextWeek']! : labels['lastWeek']!;
    }

    if (absDiff.inDays < 30) {
      final weeks = (absDiff.inDays / 7).floor();
      return diff.isNegative
          ? _replace(labels['inWeeks']!, weeks)
          : '$weeks ${labels['weeksAgo']}';
    }

    if (absDiff.inDays < 60) {
      return diff.isNegative ? labels['nextMonth']! : labels['lastMonth']!;
    }

    if (absDiff.inDays < 365) {
      final months = (absDiff.inDays / 30).floor();
      return diff.isNegative
          ? _replace(labels['inMonths']!, months)
          : '$months ${labels['monthsAgo']}';
    }

    if (absDiff.inDays < 730) {
      return diff.isNegative ? labels['nextYear']! : labels['lastYear']!;
    }

    final years = (absDiff.inDays / 365).floor();
    return diff.isNegative
        ? _replace(labels['inYears']!, years)
        : '$years ${labels['yearsAgo']}';
  }

  /// Formats [date] as a calendar string like "Today", "Monday", "12 Jan 2024"
  String calendar(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    if (diff == 1) return 'Tomorrow';
    if (diff > 1 && diff < 7) return _weekdayName(date.weekday);
    if (diff < 0 && diff > -7) return 'Last ${_weekdayName(date.weekday)}';

    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  /// Returns a short timestamp: "2:30 PM" for today, "Mon 2:30 PM" for this week,
  /// or "12 Jan" for older dates.
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
