import 'package:flutter/material.dart';

/// Marker style for events on calendar.
enum EventMarkerStyle {
  /// Small dot below date number
  dot,

  /// Colored chip with optional title
  chip,

  /// Both dot and chip
  both,
}

/// Represents a single calendar event.
///
/// Supports single-day and multi-day events.
///
/// ```dart
/// // Single day event
/// CalendarEvent(
///   date: DateTime(2024, 6, 15),
///   title: 'Team Meeting',
///   color: Colors.blue,
/// )
///
/// // Multi-day event
/// CalendarEvent(
///   date: DateTime(2024, 6, 15),
///   endDate: DateTime(2024, 6, 17),
///   title: 'Company Retreat',
///   color: Colors.green,
/// )
/// ```
class CalendarEvent {
  /// Start date of the event
  final DateTime date;

  /// End date for multi-day events — null means single day
  final DateTime? endDate;

  /// Title of the event
  final String title;

  /// Color of the event marker
  final Color color;

  /// Optional description
  final String? description;

  /// Optional custom data
  final dynamic data;

  /// Whether this is an all-day event
  final bool allDay;

  /// Optional start time
  final TimeOfDay? startTime;

  /// Optional end time
  final TimeOfDay? endTime;

  /// Creates a [CalendarEvent].
  ///
  /// ```dart
  /// CalendarEvent(
  ///   date: DateTime(2024, 6, 15),
  ///   endDate: DateTime(2024, 6, 17), // multi-day
  ///   title: 'Conference',
  ///   color: Colors.blue,
  /// )
  /// ```
  const CalendarEvent({
    required this.date,
    this.endDate,
    required this.title,
    this.color = Colors.blue,
    this.description,
    this.data,
    this.allDay = true,
    this.startTime,
    this.endTime,
  });

  /// Returns true if this is a multi-day event.
  bool get isMultiDay => endDate != null && !_isSameDay(date, endDate!);

  /// Returns number of days this event spans.
  int get spanDays {
    if (endDate == null) return 1;
    return endDate!.difference(date).inDays + 1;
  }

  /// Returns true if [date] falls within this event's range.
  bool isOnDate(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    final start = DateTime(this.date.year, this.date.month, this.date.day);

    if (endDate == null) return start == target;

    final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
    return (target.isAtSameMomentAs(start) || target.isAfter(start)) &&
        (target.isAtSameMomentAs(end) || target.isBefore(end));
  }

  /// Returns true if this event starts on [date].
  bool startsOnDate(DateTime date) => _isSameDay(this.date, date);

  /// Returns true if this event ends on [date].
  bool endsOnDate(DateTime date) =>
      endDate != null && _isSameDay(endDate!, date);

  /// Returns formatted time string.
  String get timeString {
    if (allDay) return 'All day';
    if (startTime == null) return '';
    final start = _formatTime(startTime!);
    if (endTime == null) return start;
    return '$start – ${_formatTime(endTime!)}';
  }

  /// Returns formatted date range string.
  String get dateRangeString {
    if (!isMultiDay) return '';
    return '${_formatDate(date)} – ${_formatDate(endDate!)}';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatTime(TimeOfDay time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
            ? 12
            : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  String toString() => 'CalendarEvent($title, $date'
      '${endDate != null ? ' → $endDate' : ''})';
}
