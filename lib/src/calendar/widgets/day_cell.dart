import 'package:flutter/material.dart';
import '../calendar_event.dart';
import 'event_marker.dart';

/// A single day cell in the calendar grid.
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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor
              : isToday
                  ? todayColor.withValues(alpha: 0.12)
                  : Colors.transparent,
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
          ],
        ),
      ),
    );
  }
}
