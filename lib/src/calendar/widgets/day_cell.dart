import 'package:flutter/material.dart';
import '../calendar_event.dart';
import 'event_marker.dart';

/// A single day cell in the calendar month grid.
///
/// Displays date number, event markers, and handles selection.
class DayCell extends StatelessWidget {
  /// The date this cell represents
  final DateTime date;

  /// Events on this date
  final List<CalendarEvent> events;

  /// Whether this date is selected
  final bool isSelected;

  /// Whether this date is today
  final bool isToday;

  /// Whether this date is in current month
  final bool isCurrentMonth;

  /// Whether this date is a weekend
  final bool isWeekend;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Marker style
  final EventMarkerStyle markerStyle;

  /// Selected date color
  final Color selectedColor;

  /// Today color
  final Color todayColor;

  /// Whether dark theme active
  final bool isDark;

  /// Creates a [DayCell].
  const DayCell({
    super.key,
    required this.date,
    required this.events,
    required this.isSelected,
    required this.isToday,
    required this.isCurrentMonth,
    required this.isWeekend,
    this.onTap,
    this.markerStyle = EventMarkerStyle.dot,
    this.selectedColor = Colors.indigo,
    this.todayColor = Colors.blue,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : isCurrentMonth
                  ? isWeekend
                      ? Colors.red.shade400
                      : isDark
                          ? Colors.white
                          : Colors.black87
                  : isDark
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: todayColor, width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : isCurrentMonth
                        ? isWeekend
                            ? Colors.red.shade400
                            : Colors.black87
                        : Colors.grey.shade400,
              ),
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 2),
              EventMarker(
                events: events,
                style: isSelected ? EventMarkerStyle.dot : markerStyle,
                maxMarkers: 3,
              ),
            ],
            if (events.any((e) => e.isMultiDay)) ...[
              const SizedBox(height: 2),
              Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: events
                      .firstWhere((e) => e.isMultiDay)
                      .color
                      .withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
