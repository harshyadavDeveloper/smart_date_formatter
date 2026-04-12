import 'formatter.dart';

/// Convenient DateTime extensions using SmartDateFormatter.
extension SmartDateExtension on DateTime {
  static const _formatter = SmartDateFormatter();

  /// "2 hours ago", "Yesterday", "in 3 days", etc.
  String get timeAgo => _formatter.format(this);

  /// "Today", "Yesterday", "Monday", "12 Jan 2024"
  String get calendar => _formatter.calendar(this);

  /// "2:30 PM", "Mon 2:30 PM", "12 Jan"
  String get shortTimestamp => _formatter.shortTimestamp(this);

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

  /// Start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of the day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}
