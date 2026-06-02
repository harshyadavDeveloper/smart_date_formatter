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
/// ```dart
/// CalendarEvent(
///   date: DateTime(2024, 6, 15),
///   title: 'Team Meeting',
///   color: Colors.blue,
/// )
/// ```
class CalendarEvent {
  /// Date of the event
  final DateTime date;

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
  ///   title: 'Meeting',
  ///   color: Colors.blue,
  ///   startTime: TimeOfDay(hour: 10, minute: 0),
  /// )
  /// ```
  const CalendarEvent({
    required this.date,
    required this.title,
    this.color = Colors.blue,
    this.description,
    this.data,
    this.allDay = true,
    this.startTime,
    this.endTime,
  });

  /// Returns true if this event is on [date].
  bool isOnDate(DateTime date) =>
      this.date.year == date.year &&
      this.date.month == date.month &&
      this.date.day == date.day;

  /// Returns formatted time string.
  String get timeString {
    if (allDay) return 'All day';
    if (startTime == null) return '';
    final start = _formatTime(startTime!);
    if (endTime == null) return start;
    return '$start – ${_formatTime(endTime!)}';
  }

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

  @override
  String toString() => 'CalendarEvent($title, $date)';
}
